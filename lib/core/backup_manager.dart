import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../screens/dashboard_screen.dart';

class BackupManager extends ChangeNotifier {
  static final BackupManager _instance = BackupManager._internal();
  factory BackupManager() => _instance;
  BackupManager._internal();

  static BackupManager get instance => _instance;

  // Backup state
  bool _isBackingUp = false;
  bool _isRestoring = false;
  DateTime? _lastBackupDate;
  String _backupStatus = 'No backup found';
  double _backupProgress = 0.0;
  bool _autoBackupEnabled = true;
  bool _includeSettings = true;
  bool _cloudSyncEnabled = false;

  // Getters
  bool get isBackingUp => _isBackingUp;
  bool get isRestoring => _isRestoring;
  DateTime? get lastBackupDate => _lastBackupDate;
  String get backupStatus => _backupStatus;
  double get backupProgress => _backupProgress;
  bool get autoBackupEnabled => _autoBackupEnabled;
  bool get includeSettings => _includeSettings;
  bool get cloudSyncEnabled => _cloudSyncEnabled;

  // Initialize backup manager
  void initialize() {
    _loadBackupSettings();
    _checkLastBackup();
  }

  // Load backup settings from storage
  void _loadBackupSettings() {
    // In a real app, this would load from SharedPreferences or secure storage
    // For now, we'll use default values
    _autoBackupEnabled = true;
    _includeSettings = true;
    _cloudSyncEnabled = false;
    notifyListeners();
  }

  // Check for last backup
  void _checkLastBackup() {
    // In a real app, this would check actual backup files
    // For demo purposes, we'll simulate having a backup from 3 days ago
    _lastBackupDate = DateTime.now().subtract(const Duration(days: 3));
    _backupStatus = 'Last backup: 3 days ago';
    notifyListeners();
  }

  // Create backup
  Future<bool> createBackup(List<Task> tasks) async {
    try {
      _isBackingUp = true;
      _backupProgress = 0.0;
      notifyListeners();

      // Simulate backup process
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        _backupProgress = i / 100;
        notifyListeners();
      }

      // Create backup data
      final backupData = {
        'version': '1.0',
        'timestamp': DateTime.now().toIso8601String(),
        'tasks': tasks.map((task) => _taskToJson(task)).toList(),
        'settings': _includeSettings ? _getAppSettings() : null,
        'metadata': {
          'totalTasks': tasks.length,
          'completedTasks': tasks.where((t) => t.isCompleted).length,
          'categories': _getCategoryStats(tasks),
        },
      };

      // In a real app, this would save to file system or cloud
      await _saveBackupData(backupData);

      _isBackingUp = false;
      _lastBackupDate = DateTime.now();
      _backupStatus = 'Backup completed successfully';
      notifyListeners();

      return true;
    } catch (e) {
      _isBackingUp = false;
      _backupStatus = 'Backup failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Restore backup
  Future<List<Task>?> restoreBackup() async {
    try {
      _isRestoring = true;
      _backupProgress = 0.0;
      notifyListeners();

      // Simulate restore process
      for (int i = 0; i <= 100; i += 15) {
        await Future.delayed(const Duration(milliseconds: 300));
        _backupProgress = i / 100;
        notifyListeners();
      }

      // In a real app, this would load from actual backup file
      final backupData = await _loadBackupData();

      if (backupData == null) {
        throw Exception('No backup data found');
      }

      // Parse tasks from backup
      final List<Task> restoredTasks = [];
      if (backupData['tasks'] != null) {
        for (final taskJson in backupData['tasks']) {
          restoredTasks.add(_taskFromJson(taskJson));
        }
      }

      // Restore settings if included
      if (backupData['settings'] != null && _includeSettings) {
        await _restoreAppSettings(backupData['settings']);
      }

      _isRestoring = false;
      _backupStatus = 'Data restored successfully';
      notifyListeners();

      return restoredTasks;
    } catch (e) {
      _isRestoring = false;
      _backupStatus = 'Restore failed: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  // Convert task to JSON
  Map<String, dynamic> _taskToJson(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'category': task.category.toString(),
      'dueDate': task.dueDate.toIso8601String(),
      'priority': task.priority.toString(),
      'isCompleted': task.isCompleted,
      'progress': task.progress,
    };
  }

  // Convert JSON to task
  Task _taskFromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: _parseTaskCategory(json['category']),
      dueDate: DateTime.parse(json['dueDate']),
      priority: _parsePriority(json['priority']),
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  // Parse task category from string
  TaskCategory _parseTaskCategory(String categoryString) {
    switch (categoryString) {
      case 'TaskCategory.immediate':
        return TaskCategory.immediate;
      case 'TaskCategory.dueSoon':
        return TaskCategory.dueSoon;
      case 'TaskCategory.favourite':
        return TaskCategory.favourite;
      case 'TaskCategory.personal':
        return TaskCategory.personal;
      default:
        return TaskCategory.personal;
    }
  }

  // Parse priority from string
  Priority _parsePriority(String priorityString) {
    switch (priorityString) {
      case 'Priority.high':
        return Priority.high;
      case 'Priority.medium':
        return Priority.medium;
      case 'Priority.low':
        return Priority.low;
      default:
        return Priority.low;
    }
  }

  // Get app settings for backup
  Map<String, dynamic> _getAppSettings() {
    return {
      'darkMode': true, // This would come from SettingsManager
      'language': 'English',
      'notifications': true,
      'autoBackup': _autoBackupEnabled,
    };
  }

  // Get category statistics
  Map<String, int> _getCategoryStats(List<Task> tasks) {
    final stats = <String, int>{};
    for (final category in TaskCategory.values) {
      stats[category.toString()] =
          tasks.where((t) => t.category == category).length;
    }
    return stats;
  }

  // Save backup data (simulated)
  Future<void> _saveBackupData(Map<String, dynamic> data) async {
    // In a real app, this would save to:
    // - Local file system
    // - Cloud storage (Google Drive, iCloud, etc.)
    // - Database

    final jsonString = jsonEncode(data);
    if (kDebugMode) {
      print('Backup data saved: ${jsonString.length} characters');
    }
  }

  // Load backup data (simulated)
  Future<Map<String, dynamic>?> _loadBackupData() async {
    // In a real app, this would load from actual storage
    // For demo, return sample data
    return {
      'version': '1.0',
      'timestamp':
          DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'tasks': [
        {
          'id': 'restored_1',
          'title': 'Restored Task 1',
          'description': 'This task was restored from backup',
          'category': 'TaskCategory.immediate',
          'dueDate':
              DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'priority': 'Priority.high',
          'isCompleted': false,
          'progress': 0.5,
        },
        {
          'id': 'restored_2',
          'title': 'Restored Task 2',
          'description': 'Another restored task',
          'category': 'TaskCategory.personal',
          'dueDate':
              DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          'priority': 'Priority.medium',
          'isCompleted': true,
          'progress': 1.0,
        },
      ],
      'settings': {
        'darkMode': true,
        'language': 'English',
        'notifications': true,
      },
    };
  }

  // Restore app settings
  Future<void> _restoreAppSettings(Map<String, dynamic> settings) async {
    // In a real app, this would update SettingsManager
    if (kDebugMode) {
      print('Restoring settings: $settings');
    }
  }

  // Settings management
  void setAutoBackup(bool enabled) {
    _autoBackupEnabled = enabled;
    notifyListeners();
    // Save to persistent storage
  }

  void setIncludeSettings(bool include) {
    _includeSettings = include;
    notifyListeners();
    // Save to persistent storage
  }

  void setCloudSync(bool enabled) {
    _cloudSyncEnabled = enabled;
    notifyListeners();
    // Save to persistent storage
  }

  // Auto backup check
  Future<void> checkAutoBackup(List<Task> tasks) async {
    if (!_autoBackupEnabled) return;

    final now = DateTime.now();
    if (_lastBackupDate == null ||
        now.difference(_lastBackupDate!).inDays >= 1) {
      await createBackup(tasks);
    }
  }

  // Get backup size estimate
  String getBackupSizeEstimate(List<Task> tasks) {
    final estimatedSize =
        tasks.length * 500; // Rough estimate: 500 bytes per task
    if (estimatedSize < 1024) {
      return '${estimatedSize}B';
    } else if (estimatedSize < 1024 * 1024) {
      return '${(estimatedSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(estimatedSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }
}
