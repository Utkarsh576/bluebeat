import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const BlueBeatApp());
}

class BlueBeatApp extends StatelessWidget {
  const BlueBeatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlueBeat',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
