import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('BlueBeat Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome to BlueBeat!',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
