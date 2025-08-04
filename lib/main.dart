import 'package:flutter/material.dart';
import 'localized_app.dart';
import 'core/profile_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ProfileManager
  await ProfileManager.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LocalizedApp();
  }
}
// /Users/imac/Desktop/ilyas/lib/screens/settings_screen.dartßß