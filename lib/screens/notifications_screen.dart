import 'package:flutter/material.dart';
import '../core/language.dart';

// Notification Model
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? taskId;
  final IconData icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.taskId,
    required this.icon,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? taskId,
    IconData? icon,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      taskId: taskId ?? this.taskId,
      icon: icon ?? this.icon,
    );
  }
}

enum NotificationType { taskDue, taskCompleted, taskOverdue, reminder, system }

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.taskDue:
        return 'Task Due';
      case NotificationType.taskCompleted:
        return 'Task Completed';
      case NotificationType.taskOverdue:
        return 'Task Overdue';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.system:
        return 'System';
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.taskDue:
        return const Color(0xFFFF9800);
      case NotificationType.taskCompleted:
        return const Color(0xFF4CAF50);
      case NotificationType.taskOverdue:
        return const Color(0xFFE91E63);
      case NotificationType.reminder:
        return const Color(0xFF6B7EE8);
      case NotificationType.system:
        return const Color(0xFF9C27B0);
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case NotificationType.taskDue:
        return [const Color(0xFFFFF3E0), const Color(0xFFFF9800)];
      case NotificationType.taskCompleted:
        return [const Color(0xFFE8F5E8), const Color(0xFF4CAF50)];
      case NotificationType.taskOverdue:
        return [const Color(0xFFFCE4EC), const Color(0xFFE91E63)];
      case NotificationType.reminder:
        return [const Color(0xFFE8EFF9), const Color(0xFF6B7EE8)];
      case NotificationType.system:
        return [const Color(0xFFF3E5F5), const Color(0xFF9C27B0)];
    }
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Task Due Soon',
      message: 'Complete Flutter Project is due in 2 hours',
      type: NotificationType.taskDue,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      icon: Icons.schedule_rounded,
      taskId: '1',
    ),
    NotificationItem(
      id: '2',
      title: 'Task Completed',
      message: 'You completed "Update Documentation"',
      type: NotificationType.taskCompleted,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      icon: Icons.check_circle_rounded,
      isRead: true,
      taskId: '3',
    ),
    NotificationItem(
      id: '3',
      title: 'Task Overdue',
      message: 'Prepare for Meeting is overdue by 1 day',
      type: NotificationType.taskOverdue,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.warning_rounded,
      taskId: '2',
    ),
    NotificationItem(
      id: '4',
      title: 'Daily Reminder',
      message: 'Don\'t forget to review your tasks for today',
      type: NotificationType.reminder,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.notifications_active_rounded,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'System Update',
      message: 'New features are now available in the app',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.system_update_rounded,
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'Task Due Tomorrow',
      message: 'Plan Next Sprint is due tomorrow',
      type: NotificationType.taskDue,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      icon: Icons.schedule_rounded,
      taskId: '5',
    ),
  ];

  List<NotificationItem> filteredNotifications = [];
  NotificationType? selectedFilter;
  bool showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _filterNotifications();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterNotifications() {
    setState(() {
      filteredNotifications =
          notifications.where((notification) {
            // Filter by read status
            if (showUnreadOnly && notification.isRead) return false;

            // Filter by type
            if (selectedFilter != null && notification.type != selectedFilter) {
              return false;
            }

            return true;
          }).toList();

      // Sort by timestamp (newest first)
      filteredNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        _filterNotifications();
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      notifications =
          notifications.map((n) => n.copyWith(isRead: true)).toList();
      _filterNotifications();
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      notifications.removeWhere((n) => n.id == notificationId);
      _filterNotifications();
    });
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          AppLocalizations.translate('notifications'),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.done_all_rounded,
                  color: Color(0xFF667EEA),
                ),
                onPressed: _markAllAsRead,
                tooltip: 'Mark all as read',
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header with Stats
          Container(
            margin: const EdgeInsets.all(24.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildHeaderSection(),
            ),
          ),

          // Filter Chips
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildFilterChips(),
          ),

          const SizedBox(height: 16),

          // Notifications List
          Expanded(
            child:
                filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                _slideAnimation.value * (index + 1),
                              ),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildNotificationCard(
                                  notification,
                                  index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.translate('notifications'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filteredNotifications.length} notifications',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        // Notification Statistics
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                AppLocalizations.translate('total'),
                '${notifications.length}',
                Icons.notifications_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                AppLocalizations.translate('unread'),
                '$unreadCount',
                Icons.mark_email_unread_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                AppLocalizations.translate('today'),
                '${notifications.where((n) => _isToday(n.timestamp)).length}',
                Icons.today_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Show Unread Only Toggle
          FilterChip(
            label: const Text('Unread Only'),
            selected: showUnreadOnly,
            onSelected: (selected) {
              setState(() {
                showUnreadOnly = selected;
                _filterNotifications();
              });
            },
            selectedColor: const Color(0xFF667EEA).withValues(alpha: 0.2),
            checkmarkColor: const Color(0xFF667EEA),
          ),
          const SizedBox(width: 8),
          // Type Filters
          ...NotificationType.values.map((type) {
            final isSelected = selectedFilter == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type.displayName),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = selected ? type : null;
                    _filterNotifications();
                  });
                },
                selectedColor: type.color.withValues(alpha: 0.2),
                checkmarkColor: type.color,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            notification.isRead
                ? null
                : Border.all(
                  color: notification.type.color.withValues(alpha: 0.3),
                  width: 2,
                ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (!notification.isRead) {
              _markAsRead(notification.id);
            }
            // Navigate to related task if available
            if (notification.taskId != null) {
              // TODO: Navigate to task detail
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: notification.type.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        notification.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        notification.isRead
                                            ? Colors.grey[600]
                                            : const Color(0xFF2D3748),
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: notification.type.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  notification.isRead
                                      ? Colors.grey[500]
                                      : Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey[400],
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'mark_read':
                            _markAsRead(notification.id);
                            break;
                          case 'delete':
                            _deleteNotification(notification.id);
                            break;
                        }
                      },
                      itemBuilder:
                          (context) => [
                            if (!notification.isRead)
                              const PopupMenuItem(
                                value: 'mark_read',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mark_email_read_rounded,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Mark as read'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: notification.type.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        notification.type.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: notification.type.color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: const Color(0xFF667EEA).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showUnreadOnly ? 'No unread notifications' : 'No notifications',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            showUnreadOnly
                ? 'All caught up! No unread notifications.'
                : 'You\'re all set! No notifications to show.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
