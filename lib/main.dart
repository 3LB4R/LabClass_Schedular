import 'package:flutter/material.dart';
//Import package provider
import 'package:provider/provider.dart';

import 'core/globals.dart';
import 'core/theme.dart';
import 'pages/login_page.dart';
// Import provider
import 'provider/schedule_providers.dart';

void main() {
  // 3. Bungkus LabClassApp dengan MultiProvider
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ScheduleProvider())],
      child: const LabClassApp(),
    ),
  );
}

class LabClassApp extends StatelessWidget {
  const LabClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LabClass Scheduler',
          themeMode: currentMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const LoginPage(),
        );
      },
    );
  }
}
