import 'package:flutter/material.dart';
import 'package:trueurl/theme/app_theme.dart';
import 'package:trueurl/features/welcome/welcome_screen.dart';
import 'package:trueurl/features/check/check_screen.dart';

class TrueURLApp extends StatelessWidget {
  const TrueURLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrueURL',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        '/check': (context) => const CheckScreen(),
        // Add more routes later
      },
    );
  }
}