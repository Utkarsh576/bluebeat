import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/theme/app_theme.dart';
import 'providers/music_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const BlueBeatApp());
}

class BlueBeatApp extends StatelessWidget {
  const BlueBeatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: MaterialApp(
        title: 'BlueBeat',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
