import 'package:flutter/material.dart';
import 'core/language.dart';
import 'localization_helper.dart';

/// Simple test widget to verify localization is working
class TestLocalization extends StatefulWidget {
  const TestLocalization({Key? key}) : super(key: key);

  @override
  State<TestLocalization> createState() => _TestLocalizationState();
}

class _TestLocalizationState extends State<TestLocalization> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocalizationHelper.translate('app_title'),
      home: Scaffold(
        appBar: AppBar(
          title: Text(LocalizationHelper.translate('app_title')),
          actions: [
            // Language display (English only)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('🇺🇸 English'),
                  const SizedBox(width: 8),
                  const Icon(Icons.language),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Test basic translations
                _buildSection('Basic Translations', [
                  'app_title',
                  'dashboard',
                  'welcome_back',
                  'welcome_message',
                  'settings',
                  'save',
                  'cancel',
                  'edit',
                  'delete',
                ]),

                const SizedBox(height: 20),

                // Test task translations
                _buildSection('Task Translations', [
                  'tasks',
                  'all_tasks',
                  'my_tasks',
                  'completed_tasks',
                  'pending_tasks',
                  'overdue_tasks',
                  'ongoing_tasks',
                  'newTask',
                  'create_new_task',
                  'task_title',
                  'due_date',
                  'priority',
                ]),

                const SizedBox(height: 20),

                // Test status translations
                _buildSection('Status Translations', [
                  'active',
                  'inactive',
                  'pending',
                  'completed',
                  'cancelled',
                  'draft',
                  'published',
                  'archived',
                ]),

                const SizedBox(height: 20),

                // Test priority translations
                _buildSection('Priority Translations', [
                  'high_priority',
                  'medium_priority',
                  'low_priority',
                  'high',
                  'medium',
                  'low',
                ]),

                const SizedBox(height: 20),

                // Test settings translations
                _buildSection('Settings Translations', [
                  'user_account',
                  'app_info',
                  'help_instructions',
                  'quick_settings_panel',
                  'dark_mode_language_notifications',
                  'user_account_details',
                  'app_info_details',
                  'help_instructions_details',
                  'exit_app',
                  'exit_app_confirmation',
                ]),

                const SizedBox(height: 20),

                // Test message translations
                _buildSection('Message Translations', [
                  'loading',
                  'error',
                  'success',
                  'warning',
                  'task_created_successfully',
                  'task_updated_successfully',
                  'task_deleted_successfully',
                  'are_you_sure_delete',
                  'network_error',
                  'something_went_wrong',
                ]),

                const SizedBox(height: 40),

                // Test buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              LocalizationHelper.taskCreatedSuccessfully,
                            ),
                          ),
                        );
                      },
                      child: Text(LocalizationHelper.save),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              LocalizationHelper.translate('cancelled'),
                            ),
                          ),
                        );
                      },
                      child: Text(LocalizationHelper.cancel),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Language info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Language Info:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current Language: ${AppLocalizations.currentLanguage}',
                        ),
                        const Text('Is RTL: false'),
                        Text(
                          'Supported Languages: ${AppLocalizations.supportedLanguages.join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> keys) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...keys.map(
              (key) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        key,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Text(' → '),
                    Expanded(
                      child: Text(
                        AppLocalizations.translate(key),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Test function to run the localization test
void main() {
  runApp(const TestLocalization());
}
