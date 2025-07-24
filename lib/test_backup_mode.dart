import 'package:flutter/material.dart';
import 'core/backup_manager.dart';
import 'screens/backup_screen.dart';
import 'screens/dashboard_screen.dart';

/// Test widget to demonstrate backup functionality
class TestBackupMode extends StatefulWidget {
  const TestBackupMode({super.key});

  @override
  State<TestBackupMode> createState() => _TestBackupModeState();
}

class _TestBackupModeState extends State<TestBackupMode> {
  final BackupManager _backupManager = BackupManager.instance;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _backupManager.initialize();
    _backupManager.addListener(_onBackupStateChanged);
    _initializeSampleTasks();
  }

  @override
  void dispose() {
    _backupManager.removeListener(_onBackupStateChanged);
    super.dispose();
  }

  void _onBackupStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _initializeSampleTasks() {
    _tasks = [
      Task(
        id: '1',
        title: 'Complete Flutter Project',
        description: 'Finish the dashboard UI implementation',
        category: TaskCategory.immediate,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: Priority.high,
        progress: 0.7,
      ),
      Task(
        id: '2',
        title: 'Prepare for Meeting',
        description: 'Review presentation slides and prepare notes',
        category: TaskCategory.dueSoon,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: Priority.medium,
        progress: 0.4,
      ),
      Task(
        id: '3',
        title: 'Update Documentation',
        description: 'Update API documentation with new endpoints',
        category: TaskCategory.favourite,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        priority: Priority.low,
        progress: 0.6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backup Mode Test',
      theme: ThemeData(primarySwatch: Colors.cyan, fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text('Backup Mode Test'),
          backgroundColor: const Color(0xFF00BCD4),
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.backup_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BackupScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
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
                            Icons.backup_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Backup Mode Test',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Test backup and restore functionality',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_backupManager.isBackingUp ||
                        _backupManager.isRestoring) ...[
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: _backupManager.backupProgress,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _backupManager.isBackingUp
                            ? 'Backing up...'
                            : 'Restoring...',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Backup Status
              _buildStatusCard(),

              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(),

              const SizedBox(height: 24),

              // Sample Tasks
              _buildTasksList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF00BCD4),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Backup Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Status', _backupManager.backupStatus),
          const SizedBox(height: 12),
          _buildInfoRow('Total Tasks', '${_tasks.length} tasks'),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Last Backup',
            _backupManager.lastBackupDate != null
                ? '${_backupManager.lastBackupDate!.day}/${_backupManager.lastBackupDate!.month}/${_backupManager.lastBackupDate!.year}'
                : 'Never',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Backup Size',
            _backupManager.getBackupSizeEstimate(_tasks),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        // Create Backup
        _buildActionButton(
          icon: Icons.backup_rounded,
          title: 'Create Backup',
          subtitle: 'Backup all tasks and settings',
          color: const Color(0xFF4CAF50),
          onPressed:
              _backupManager.isBackingUp || _backupManager.isRestoring
                  ? null
                  : () async {
                    final success = await _backupManager.createBackup(_tasks);
                    if (success) {
                      _showMessage(
                        'Backup created successfully!',
                        Colors.green,
                      );
                    } else {
                      _showMessage('Backup failed!', Colors.red);
                    }
                  },
        ),
        const SizedBox(height: 16),

        // Restore Backup
        _buildActionButton(
          icon: Icons.restore_rounded,
          title: 'Restore Backup',
          subtitle: 'Restore from previous backup',
          color: const Color(0xFFFF9800),
          onPressed:
              _backupManager.isBackingUp || _backupManager.isRestoring
                  ? null
                  : () async {
                    final restoredTasks = await _backupManager.restoreBackup();
                    if (restoredTasks != null) {
                      setState(() {
                        _tasks = restoredTasks;
                      });
                      _showMessage('Data restored successfully!', Colors.green);
                    } else {
                      _showMessage('Restore failed!', Colors.red);
                    }
                  },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.task_alt_rounded,
                color: const Color(0xFF00BCD4),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Sample Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._tasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.category.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.category.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(task.category.icon, color: task.category.color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getPriorityText(task.priority),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getPriorityColor(task.priority),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'HIGH';
      case Priority.medium:
        return 'MED';
      case Priority.low:
        return 'LOW';
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
