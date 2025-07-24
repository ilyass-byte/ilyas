import 'core/language.dart';

/// Helper class to make localization easier to use throughout the app
class LocalizationHelper {
  // Common UI elements
  static String get cancel => AppLocalizations.translate('cancel');
  static String get save => AppLocalizations.translate('save');
  static String get edit => AppLocalizations.translate('edit');
  static String get delete => AppLocalizations.translate('delete');
  static String get add => AppLocalizations.translate('add');
  static String get update => AppLocalizations.translate('update');
  static String get create => AppLocalizations.translate('create');
  static String get view => AppLocalizations.translate('view');
  static String get search => AppLocalizations.translate('search');
  static String get filter => AppLocalizations.translate('filter');
  static String get sort => AppLocalizations.translate('sort');
  static String get settings => AppLocalizations.translate('settings');

  // Status messages
  static String get loading => AppLocalizations.translate('loading');
  static String get error => AppLocalizations.translate('error');
  static String get success => AppLocalizations.translate('success');
  static String get warning => AppLocalizations.translate('warning');
  static String get info => AppLocalizations.translate('info');

  // Common actions
  static String get retry => AppLocalizations.translate('retry');
  static String get refresh => AppLocalizations.translate('refresh');
  static String get confirm => AppLocalizations.translate('confirm');
  static String get close => AppLocalizations.translate('close');
  static String get open => AppLocalizations.translate('open');
  static String get share => AppLocalizations.translate('share');
  static String get copy => AppLocalizations.translate('copy');
  static String get paste => AppLocalizations.translate('paste');
  static String get cut => AppLocalizations.translate('cut');
  static String get undo => AppLocalizations.translate('undo');
  static String get redo => AppLocalizations.translate('redo');

  // Navigation
  static String get next => AppLocalizations.translate('next');
  static String get previous => AppLocalizations.translate('previous');
  static String get first => AppLocalizations.translate('first');
  static String get last => AppLocalizations.translate('last');
  static String get home => AppLocalizations.translate('home');

  // User account
  static String get login => AppLocalizations.translate('login');
  static String get register => AppLocalizations.translate('register');
  static String get logout => AppLocalizations.translate('logout');
  static String get profile => AppLocalizations.translate('profile');
  static String get username => AppLocalizations.translate('username');
  static String get password => AppLocalizations.translate('password');
  static String get email => AppLocalizations.translate('email');
  static String get name => AppLocalizations.translate('name');
  static String get phone => AppLocalizations.translate('phone');
  static String get address => AppLocalizations.translate('address');

  // Date and time
  static String get today => AppLocalizations.translate('today');
  static String get yesterday => AppLocalizations.translate('yesterday');
  static String get tomorrow => AppLocalizations.translate('tomorrow');
  static String get thisWeek => AppLocalizations.translate('this_week');
  static String get thisMonth => AppLocalizations.translate('this_month');
  static String get thisYear => AppLocalizations.translate('this_year');
  static String get date => AppLocalizations.translate('date');
  static String get time => AppLocalizations.translate('time');
  static String get startDate => AppLocalizations.translate('start_date');
  static String get endDate => AppLocalizations.translate('end_date');
  static String get dueDate => AppLocalizations.translate('due_date');

  // Status
  static String get active => AppLocalizations.translate('active');
  static String get inactive => AppLocalizations.translate('inactive');
  static String get pending => AppLocalizations.translate('pending');
  static String get completed => AppLocalizations.translate('completed');
  static String get cancelled => AppLocalizations.translate('cancelled');
  static String get draft => AppLocalizations.translate('draft');
  static String get published => AppLocalizations.translate('published');
  static String get archived => AppLocalizations.translate('archived');

  // Tasks
  static String get tasks => AppLocalizations.translate('tasks');
  static String get allTasks => AppLocalizations.translate('all_tasks');
  static String get myTasks => AppLocalizations.translate('my_tasks');
  static String get completedTasks =>
      AppLocalizations.translate('completed_tasks');
  static String get pendingTasks => AppLocalizations.translate('pending_tasks');
  static String get overdueTasks => AppLocalizations.translate('overdue_tasks');
  static String get tasksDueSoon =>
      AppLocalizations.translate('tasks_due_soon');
  static String get favouriteTasks =>
      AppLocalizations.translate('favourite_tasks');
  static String get personalTasks =>
      AppLocalizations.translate('personal_tasks');

  // Priority
  static String get highPriority => AppLocalizations.translate('high_priority');
  static String get mediumPriority =>
      AppLocalizations.translate('medium_priority');
  static String get lowPriority => AppLocalizations.translate('low_priority');
  static String get high => AppLocalizations.translate('high');
  static String get medium => AppLocalizations.translate('medium');
  static String get low => AppLocalizations.translate('low');

  // Notifications
  static String get notifications =>
      AppLocalizations.translate('notifications');
  static String get unread => AppLocalizations.translate('unread');
  static String get markAsRead => AppLocalizations.translate('mark_as_read');
  static String get markAllRead => AppLocalizations.translate('mark_all_read');
  static String get noNotifications =>
      AppLocalizations.translate('no_notifications');
  static String get noUnreadNotifications =>
      AppLocalizations.translate('no_unread_notifications');

  // Validation messages
  static String get requiredField =>
      AppLocalizations.translate('required_field');
  static String get invalidEmail => AppLocalizations.translate('invalid_email');
  static String get passwordTooShort =>
      AppLocalizations.translate('password_too_short');
  static String get passwordsDontMatch =>
      AppLocalizations.translate('passwords_dont_match');

  // Error messages
  static String get networkError => AppLocalizations.translate('network_error');
  static String get serverError => AppLocalizations.translate('server_error');
  static String get noInternet => AppLocalizations.translate('no_internet');
  static String get tryAgain => AppLocalizations.translate('try_again');
  static String get somethingWentWrong =>
      AppLocalizations.translate('something_went_wrong');

  // Success messages
  static String get taskCreatedSuccessfully =>
      AppLocalizations.translate('task_created_successfully');
  static String get taskUpdatedSuccessfully =>
      AppLocalizations.translate('task_updated_successfully');
  static String get taskDeletedSuccessfully =>
      AppLocalizations.translate('task_deleted_successfully');
  static String get passwordChangedSuccessfully =>
      AppLocalizations.translate('password_changed_successfully');

  // Confirmation messages
  static String get areYouSureDelete =>
      AppLocalizations.translate('are_you_sure_delete');
  static String get areYouSureLogout =>
      AppLocalizations.translate('are_you_sure_logout');
  static String get areYouSureExit =>
      AppLocalizations.translate('are_you_sure_exit');

  // Language and settings
  static String get language => AppLocalizations.translate('language');
  static String get darkMode => AppLocalizations.translate('dark_mode');
  static String get quickSettings =>
      AppLocalizations.translate('quick_settings');
  static String get userAccount => AppLocalizations.translate('user_account');
  static String get appInfo => AppLocalizations.translate('app_info');
  static String get helpInstructions =>
      AppLocalizations.translate('help_instructions');
  static String get quickExit => AppLocalizations.translate('quick_exit');
  static String get changePassword =>
      AppLocalizations.translate('change_password');
  static String get currentPassword =>
      AppLocalizations.translate('current_password');
  static String get newPassword => AppLocalizations.translate('new_password');
  static String get confirmPassword =>
      AppLocalizations.translate('confirm_password');

  // Dashboard
  static String get dashboard => AppLocalizations.translate('dashboard');
  static String get welcomeBack => AppLocalizations.translate('welcome_back');
  static String get welcomeMessage =>
      AppLocalizations.translate('welcome_message');
  static String get ongoingTasks => AppLocalizations.translate('ongoing_tasks');
  static String get viewAll => AppLocalizations.translate('view_all');
  static String get newTask => AppLocalizations.translate('newTask');
  static String get createNewTask =>
      AppLocalizations.translate('create_new_task');

  // File operations
  static String get export => AppLocalizations.translate('export');
  static String get import => AppLocalizations.translate('import');
  static String get download => AppLocalizations.translate('download');
  static String get upload => AppLocalizations.translate('upload');
  static String get print => AppLocalizations.translate('print');

  // Utility methods
  static String translate(String key) => AppLocalizations.translate(key);

  static bool get isRTL => AppLocalizations.isRTL;

  static String get currentLanguage => AppLocalizations.currentLanguage;

  static List<String> get supportedLanguages =>
      AppLocalizations.supportedLanguages;

  static void setLanguage(String language) =>
      AppLocalizations.setLanguage(language);
}
