import 'package:flutter/material.dart';

class AppLocalizations extends ChangeNotifier {
  static final AppLocalizations _instance = AppLocalizations._internal();
  factory AppLocalizations() => _instance;
  AppLocalizations._internal();

  static AppLocalizations get instance => _instance;

  String _currentLanguage = 'English';

  static final Map<String, Map<String, String>> _localizedValues = {
    'English': {
      // App basics
      'app_title': 'Task Manager',

      // Common
      'back': 'Back',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'done': 'Done',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'settings': 'Settings',
      'view': 'View',

      // Dashboard
      'dashboard': 'Dashboard',
      'welcome_back': 'Welcome Back',
      'welcome_message': 'Welcome back! Let\'s get things done.',
      'good_morning': 'Good Morning',
      'task_overview': 'Task Overview',
      'ongoing_tasks': 'Ongoing Tasks',
      'view_all': 'View All',
      'newTask': 'New Task',
      'new_task': 'New Task',

      // Tasks
      'tasks': 'Tasks',
      'task': 'Task',
      'all_tasks': 'All Tasks',
      'my_tasks': 'My Tasks',
      'completed_tasks': 'Completed Tasks',
      'pending_tasks': 'Pending Tasks',
      'overdue_tasks': 'Overdue Tasks',
      'task_details': 'Task Details',
      'create_task': 'Create Task',
      'create_new_task': 'Create New Task',
      'edit_task': 'Edit Task',
      'task_title': 'Task Title',
      'task_description': 'Task Description',
      'enter_task_title': 'Enter task title',
      'enter_task_description': 'Enter task description',
      'please_enter_task_title': 'Please enter task title',
      'please_enter_task_description': 'Please enter task description',
      'due_date': 'Due Date',
      'due': 'Due',
      'priority': 'Priority',
      'category': 'Category',
      'progress': 'Progress',
      'completed': 'Completed',
      'incomplete': 'Incomplete',

      // Priority levels
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'urgent': 'Urgent',

      // Categories
      'work': 'Work',
      'personal': 'Personal',
      'shopping': 'Shopping',
      'health': 'Health',
      'education': 'Education',
      'finance': 'Finance',
      'travel': 'Travel',
      'home': 'Home',
      'family': 'Family',
      'hobbies': 'Hobbies',

      // Status
      'status': 'Status',
      'active': 'Active',
      'inactive': 'Inactive',
      'archived': 'Archived',
      'draft': 'Draft',

      // Time
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'yesterday': 'Yesterday',
      'this_week': 'This Week',
      'next_week': 'Next Week',
      'this_month': 'This Month',
      'next_month': 'Next Month',

      // Actions
      'add': 'Add',
      'remove': 'Remove',
      'update': 'Update',
      'create': 'Create',
      'select': 'Select',
      'select_all': 'Select All',
      'clear': 'Clear',
      'clear_all': 'Clear All',
      'refresh': 'Refresh',
      'retry': 'Retry',
      'close': 'Close',
      'open': 'Open',
      'submit': 'Submit',
      'confirm': 'Confirm',

      // Navigation
      // ignore: equal_keys_in_map
      'home': 'Home',
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'account': 'Account',
      'logout': 'Logout',
      'login': 'Login',
      'register': 'Register',

      // Profile Management
      'personal_information': 'Personal Information',
      'full_name': 'Full Name',
      'email': 'Email',
      'phone': 'Phone',
      'bio': 'Bio',
      'about': 'About',
      'change_profile_picture': 'Change Profile Picture',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'additional_options': 'Additional Options',
      'notification_preferences': 'Notification Preferences',
      'manage_notifications': 'Manage your notification settings',
      'privacy_settings': 'Privacy Settings',
      'control_privacy': 'Control your privacy and data settings',
      'profile_updated_successfully': 'Profile updated successfully',
      'error_saving_profile': 'Error saving profile',
      'update_personal_info': 'Update personal information and profile picture',

      // Validation Messages
      'please_enter_name': 'Please enter your name',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email address',
      'please_enter_phone': 'Please enter your phone number',

      // Settings
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'dark_mode_enabled': 'Dark Mode Enabled',
      'light_mode_enabled': 'Light Mode Enabled',
      'theme_switched': 'Theme Switched',
      'notifications': 'Notifications',
      'sound': 'Sound',
      'vibration': 'Vibration',
      'auto_sync': 'Auto Sync',
      'battery_saver': 'Battery Saver',
      'location': 'Location',
      'wifi': 'WiFi',
      'quick_settings': 'Quick Settings',
      'user_account': 'User Account',
      'app_info': 'App Information',
      'help_instructions': 'Help & Instructions',
      'quick_exit': 'Quick Exit',
      'change_password': 'Change Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm Password',
      'account_settings': 'Account Settings',
      'security_settings': 'Security Settings',
      'general_settings': 'General Settings',
      'biometric_authentication': 'Biometric Authentication',
      'pin_protection': 'PIN Protection',
      'two_factor_authentication': 'Two-Factor Authentication',
      'auto_lock': 'Auto Lock',
      'password_strength_indicator': 'Password Strength Indicator',
      'login_notifications': 'Login Notifications',
      'security_center': 'Security Center',
      'protect_account_data': 'Protect your account and data',
      'authentication': 'Authentication',
      'privacy_protection': 'Privacy & Protection',
      'security_monitoring': 'Security Monitoring',
      'quick_actions': 'Quick Actions',
      'security_log': 'Security Log',
      'security_checkup': 'Security Checkup',

      // Messages
      'task_created_successfully': 'Task created successfully',
      'task_updated_successfully': 'Task updated successfully',
      'task_deleted_successfully': 'Task deleted successfully',
      'password_changed_successfully': 'Password changed successfully',
      'are_you_sure_delete': 'Are you sure you want to delete?',
      'are_you_sure_logout': 'Are you sure you want to logout?',
      'are_you_sure_exit': 'Are you sure you want to exit the app?',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'info': 'Information',

      // Validation
      'required_field': 'This field is required',
      'invalid_email': 'Invalid email address',
      'password_too_short': 'Password is too short',
      'passwords_dont_match': 'Passwords don\'t match',

      // File operations
      'export': 'Export',
      'import': 'Import',
      'download': 'Download',
      'upload': 'Upload',
      'print': 'Print',

      // Backup
      'backup': 'Backup',
      'backup_data': 'Backup Data',
      'restore': 'Restore',
      'restore_backup': 'Restore Backup',
      'create_backup': 'Create Backup',
      'backup_created': 'Backup Created Successfully',
      'backup_restored': 'Data Restored Successfully',
      'auto_backup': 'Auto Backup',
      'backup_settings': 'Backup Settings',
      'backup_info': 'Backup Information',
      'last_backup': 'Last Backup',
      'backup_size': 'Backup Size',
      'include_settings': 'Include Settings',
      'cloud_sync': 'Cloud Sync',

      // Statistics
      'total': 'Total',
      'count': 'Count',
      'percentage': 'Percentage',
      'average': 'Average',
      'statistics': 'Statistics',
      'reports': 'Reports',

      // Time tracking
      'start_time': 'Start Time',
      'end_time': 'End Time',
      'duration': 'Duration',
      'time_spent': 'Time Spent',
      'estimated_time': 'Estimated Time',

      // Notifications
      'unread': 'Unread',
      'read': 'Read',
      'mark_as_read': 'Mark as Read',
      'mark_as_unread': 'Mark as Unread',

      // Search and filter
      'search_tasks': 'Search tasks',
      'filter_by': 'Filter by',
      'sort_by': 'Sort by',
      'no_results': 'No results found',
      'show_all': 'Show All',

      // Settings specific
      'customize_experience': 'Customize Your App Experience',
      'quick_settings_panel': 'Quick Settings Panel',
      'dark_mode_language_notifications': 'Dark Mode, Language & Notifications',
      'user_account_details':
          'Manage your account details and security settings',
      'app_info_details': 'App version, updates, and license information',
      'help_instructions_details': 'User guide and frequently asked questions',
      'exit_app': 'Exit Application',
      'exit_app_confirmation': 'Are you sure you want to exit the application?',
      'exit': 'Exit',
      'settings_saved': 'Settings saved successfully',
      'settings_reset': 'Settings reset to default',
      'apply_changes': 'Apply Changes',
      'reset_settings': 'Reset Settings',
      'advanced_settings': 'Advanced Settings',
    },
  };

  static String translate(String key) {
    return _localizedValues[_instance._currentLanguage]?[key] ?? key;
  }

  static void setLanguage(String language) {
    _instance._currentLanguage = language;
    _instance.notifyListeners();
  }

  static bool get isRTL => false; // English only - always LTR

  static String get currentLanguage => _instance._currentLanguage;

  static List<String> get supportedLanguages => _localizedValues.keys.toList();
}
