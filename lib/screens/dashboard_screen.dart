import 'package:flutter/material.dart';
import 'package:ilyas/core/language.dart';
import 'package:ilyas/screens/all_tasks_screen.dart';
import 'category_tasks_screen.dart';
import 'task_detail_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import '../localized_app.dart';
import '../core/settings_manager.dart';

// Task Model
class Task {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final DateTime dueDate;
  final Priority priority;
  final bool isCompleted;
  final double progress;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    this.progress = 0.0,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    double? progress,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
    );
  }
}

enum TaskCategory { immediate, dueSoon, favourite, personal }

enum Priority { low, medium, high }

// Task Category Extensions
extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.immediate:
        return 'Immediate Tasks';
      case TaskCategory.dueSoon:
        return 'Task Due Soon';
      case TaskCategory.favourite:
        return 'Favourite Tasks';
      case TaskCategory.personal:
        return 'Personal Tasks';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.immediate:
        return Icons.flash_on;
      case TaskCategory.dueSoon:
        return Icons.schedule;
      case TaskCategory.favourite:
        return Icons.star;
      case TaskCategory.personal:
        return Icons.person;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.immediate:
        return const Color(0xFF6B7EE8);
      case TaskCategory.dueSoon:
        return const Color(0xFFE91E63);
      case TaskCategory.favourite:
        return const Color(0xFF4CAF50);
      case TaskCategory.personal:
        return const Color(0xFFFF9800);
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case TaskCategory.immediate:
        return [const Color(0xFFE8EFF9), const Color(0xFF6B7EE8)];
      case TaskCategory.dueSoon:
        return [const Color(0xFFFCE4EC), const Color(0xFFE91E63)];
      case TaskCategory.favourite:
        return [const Color(0xFFE8F5E8), const Color(0xFF4CAF50)];
      case TaskCategory.personal:
        return [const Color(0xFFFFF3E0), const Color(0xFFFF9800)];
    }
  }
}

// Main Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin, LocalizationMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _cardSlideAnimation;

  List<Task> tasks = [
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
    Task(
      id: '4',
      title: 'Review Code Changes',
      description: 'Review pull requests from team members',
      category: TaskCategory.personal,
      dueDate: DateTime.now().add(const Duration(days: 4)),
      priority: Priority.medium,
      progress: 0.3,
    ),
    Task(
      id: '5',
      title: 'Plan Next Sprint',
      description: 'Organize tasks for the upcoming sprint',
      category: TaskCategory.immediate,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: Priority.high,
      progress: 0.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add listener for settings changes
    SettingsManager.instance.addListener(_onSettingsChanged);

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _cardSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fabAnimationController.forward();
    _cardAnimationController.forward();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Remove listener for settings changes
    SettingsManager.instance.removeListener(_onSettingsChanged);
    _fabAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  int getTaskCountByCategory(TaskCategory category) {
    return tasks
        .where((task) => task.category == category && !task.isCompleted)
        .length;
  }

  List<Task> getOngoingTasks() {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  void _addNewTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  void _navigateToCreateTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTaskScreen()),
    );

    if (result != null && result is Task) {
      _addNewTask(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                color: const Color.fromARGB(
                  255,
                  143,
                  143,
                  235,
                ).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Color.fromARGB(255, 235, 236, 239),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ),
        actions: [
          // Dark Mode Toggle Button
          Container(
            margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
              icon: Icon(
                SettingsManager.instance.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: const Color(0xFF667EEA),
              ),
              onPressed: () {
                setState(() {
                  SettingsManager.instance.toggleDarkMode();
                });

                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      SettingsManager.instance.isDarkMode
                          ? AppLocalizations.translate('dark_mode_enabled')
                          : AppLocalizations.translate('light_mode_enabled'),
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          // Notifications Button
          Container(
            margin: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_rounded,
                    color: Color(0xFF667EEA),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                // Notification badge
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '3', // This would be dynamic in a real app
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.translate('dashboard'),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.translate('welcome_message'),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '${getOngoingTasks().length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Task Categories Grid
            AnimatedBuilder(
              animation: _cardSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _cardSlideAnimation.value),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        TaskCategory.values.map((category) {
                          final taskCount = getTaskCountByCategory(category);
                          return _buildCategoryCard(category, taskCount);
                        }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Ongoing Tasks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.translate('ongoing_tasks'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllTasksScreen(tasks: tasks),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.translate('view_all'),
                    style: const TextStyle(
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Ongoing Tasks List
            ...getOngoingTasks().asMap().entries.map((entry) {
              final index = entry.key;
              final task = entry.value;
              return AnimatedBuilder(
                animation: _cardAnimationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _cardSlideAnimation.value * (index + 1)),
                    child: _buildTaskCard(task),
                  );
                },
              );
            }),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: _navigateToCreateTask,
          backgroundColor: const Color(0xFF667EEA),
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.add_rounded),
          label: Text(
            //'New Task',
            AppLocalizations.translate('newTask'),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(TaskCategory category, int taskCount) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: category.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: category.color.withValues(alpha: 0.3),
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
                builder:
                    (context) =>
                        CategoryTasksScreen(category: category, tasks: tasks),
              ),
            );
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      category.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$taskCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
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
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );

            if (result != null) {
              if (result == 'delete') {
                setState(() {
                  tasks.removeWhere((t) => t.id == task.id);
                });
              } else if (result is Task) {
                setState(() {
                  final index = tasks.indexWhere((t) => t.id == task.id);
                  if (index != -1) {
                    tasks[index] = result;
                  }
                });
              }
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
                        color: task.category.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        task.category.icon,
                        color: task.category.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
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
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(task.progress * 100).toInt()}% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: task.category.color,
                      ),
                    ),
                    Text(
                      'Due: ${task.dueDate.day}/${task.dueDate.month}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: task.progress,
                  backgroundColor: task.category.color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    task.category.color,
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
}

// Create Task Screen
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskCategory _selectedCategory = TaskCategory.immediate;
  Priority _selectedPriority = Priority.medium;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        dueDate: _selectedDate,
        priority: _selectedPriority,
      );

      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Task',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              _buildSectionTitle('Task Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: _buildInputDecoration('Enter task title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Task Description
              _buildSectionTitle('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: _buildInputDecoration('Enter task description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Category Selection
              _buildSectionTitle('Category'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    TaskCategory.values.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? category.color : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? category.color
                                      : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                color:
                                    isSelected ? Colors.white : category.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category.displayName,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : category.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 24),

              // Priority Selection
              _buildSectionTitle('Priority'),
              const SizedBox(height: 16),
              Row(
                children:
                    Priority.values.map((priority) {
                      final isSelected = _selectedPriority == priority;
                      final color =
                          priority == Priority.high
                              ? Colors.red
                              : priority == Priority.medium
                              ? Colors.orange
                              : Colors.green;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriority = priority;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? color : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? color : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              priority.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 24),

              // Due Date
              _buildSectionTitle('Due Date'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Create Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _createTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: const Color(0xFF667EEA).withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
