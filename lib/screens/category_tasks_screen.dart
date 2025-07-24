import 'package:flutter/material.dart';
import 'package:ilyas/screens/task_detail_screen.dart';
import 'dashboard_screen.dart';

class CategoryTasksScreen extends StatefulWidget {
  final TaskCategory category;
  final List<Task> tasks;

  const CategoryTasksScreen({
    super.key,
    required this.category,
    required this.tasks,
  });

  @override
  State<CategoryTasksScreen> createState() => _CategoryTasksScreenState();
}

class _CategoryTasksScreenState extends State<CategoryTasksScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  List<Task> filteredTasks = [];
  String searchQuery = '';
  TaskSortOption sortOption = TaskSortOption.dueDate;

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

    _filterTasks();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterTasks() {
    setState(() {
      filteredTasks =
          widget.tasks
              .where(
                (task) =>
                    task.category == widget.category &&
                    !task.isCompleted &&
                    (searchQuery.isEmpty ||
                        task.title.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ) ||
                        task.description.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        )),
              )
              .toList();

      _sortTasks();
    });
  }

  void _sortTasks() {
    switch (sortOption) {
      case TaskSortOption.dueDate:
        filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSortOption.priority:
        filteredTasks.sort(
          (a, b) => _getPriorityValue(
            b.priority,
          ).compareTo(_getPriorityValue(a.priority)),
        );
        break;
      case TaskSortOption.progress:
        filteredTasks.sort((a, b) => b.progress.compareTo(a.progress));
        break;
      case TaskSortOption.title:
        filteredTasks.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
  }

  int _getPriorityValue(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
    }
  }

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
            gradient: LinearGradient(
              colors: widget.category.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: widget.category.color.withValues(alpha: 0.3),
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
          widget.category.displayName,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
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
            child: PopupMenuButton<TaskSortOption>(
              icon: Icon(Icons.sort_rounded, color: widget.category.color),
              onSelected: (TaskSortOption option) {
                setState(() {
                  sortOption = option;
                  _sortTasks();
                });
              },
              itemBuilder:
                  (BuildContext context) =>
                      TaskSortOption.values
                          .map(
                            (option) => PopupMenuItem<TaskSortOption>(
                              value: option,
                              child: Row(
                                children: [
                                  Icon(
                                    _getSortIcon(option),
                                    color: widget.category.color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(option.displayName),
                                ],
                              ),
                            ),
                          )
                          .toList(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section with Stats
          Container(
            margin: const EdgeInsets.all(24.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.category.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.category.color.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
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
                        child: Icon(
                          widget.category.icon,
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
                              widget.category.displayName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${filteredTasks.length} active tasks',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${filteredTasks.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress Overview
                  if (filteredTasks.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Avg Progress',
                            '${(filteredTasks.map((t) => t.progress).reduce((a, b) => a + b) / filteredTasks.length * 100).toInt()}%',
                            Icons.trending_up_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'High Priority',
                            '${filteredTasks.where((t) => t.priority == Priority.high).length}',
                            Icons.priority_high_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Due Soon',
                            '${filteredTasks.where((t) => t.dueDate.difference(DateTime.now()).inDays <= 2).length}',
                            Icons.schedule_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                _filterTasks();
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: widget.category.color,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tasks List
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
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
                                child: _buildTaskCard(task, index),
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

  Widget _buildTaskCard(Task task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
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
                        color: widget.category.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.category.icon,
                        color: widget.category.color,
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
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ),
                              _buildPriorityBadge(task.priority),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Text(
                      '${(task.progress * 100).toInt()}% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.category.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: task.progress,
                  backgroundColor: widget.category.color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.category.color,
                  ),
                  minHeight: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(Priority priority) {
    Color color;
    String text;

    switch (priority) {
      case Priority.high:
        color = Colors.red;
        text = 'HIGH';
        break;
      case Priority.medium:
        color = Colors.orange;
        text = 'MED';
        break;
      case Priority.low:
        color = Colors.green;
        text = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
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
              color: widget.category.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.category.icon,
              size: 64,
              color: widget.category.color.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No ${widget.category.displayName.toLowerCase()} found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Create your first task to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getSortIcon(TaskSortOption option) {
    switch (option) {
      case TaskSortOption.dueDate:
        return Icons.schedule_rounded;
      case TaskSortOption.priority:
        return Icons.priority_high_rounded;
      case TaskSortOption.progress:
        return Icons.trending_up_rounded;
      case TaskSortOption.title:
        return Icons.sort_by_alpha_rounded;
    }
  }
}

enum TaskSortOption { dueDate, priority, progress, title }

extension TaskSortOptionExtension on TaskSortOption {
  String get displayName {
    switch (this) {
      case TaskSortOption.dueDate:
        return 'Due Date';
      case TaskSortOption.priority:
        return 'Priority';
      case TaskSortOption.progress:
        return 'Progress';
      case TaskSortOption.title:
        return 'Title';
    }
  }
}
