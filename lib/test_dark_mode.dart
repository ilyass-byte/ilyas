import 'package:flutter/material.dart';
import 'core/settings_manager.dart';
import 'core/language.dart';

/// Simple test widget to verify dark mode is working
class TestDarkMode extends StatefulWidget {
  const TestDarkMode({super.key});

  @override
  State<TestDarkMode> createState() => _TestDarkModeState();
}

class _TestDarkModeState extends State<TestDarkMode> {
  @override
  void initState() {
    super.initState();
    SettingsManager.instance.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    SettingsManager.instance.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Mode Test',
      theme: SettingsManager.instance.currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dark Mode Test'),
          actions: [
            IconButton(
              icon: Icon(
                SettingsManager.instance.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: () {
                SettingsManager.instance.toggleDarkMode();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      SettingsManager.instance.isDarkMode
                          ? AppLocalizations.translate('dark_mode_enabled')
                          : AppLocalizations.translate('light_mode_enabled'),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            SettingsManager.instance.isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Theme',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  SettingsManager.instance.isDarkMode
                                      ? AppLocalizations.translate('dark_mode')
                                      : AppLocalizations.translate(
                                        'light_mode',
                                      ),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Theme Details:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Brightness: ${Theme.of(context).brightness.name}'),
                      Text(
                        'Background: ${Theme.of(context).scaffoldBackgroundColor}',
                      ),
                      Text('Card Color: ${Theme.of(context).cardColor}'),
                      Text('Primary Color: ${Theme.of(context).primaryColor}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Test Buttons
              Text(
                'Test Components:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Elevated Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Elevated Button Pressed!')),
                    );
                  },
                  child: const Text('Elevated Button'),
                ),
              ),

              const SizedBox(height: 12),

              // Outlined Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Outlined Button Pressed!')),
                    );
                  },
                  child: const Text('Outlined Button'),
                ),
              ),

              const SizedBox(height: 12),

              // Text Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Text Button Pressed!')),
                    );
                  },
                  child: const Text('Text Button'),
                ),
              ),

              const SizedBox(height: 24),

              // Toggle Theme Button
              Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    SettingsManager.instance.toggleDarkMode();
                  },
                  icon: Icon(
                    SettingsManager.instance.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  label: Text(
                    SettingsManager.instance.isDarkMode
                        ? 'Switch to Light'
                        : 'Switch to Dark',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Test function to run the dark mode test
void main() {
  runApp(const TestDarkMode());
}
