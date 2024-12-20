import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Netflix Theme',
      theme: appTheme, // Use the imported theme
      home: const SplashScreen(),
    );
  }
}
