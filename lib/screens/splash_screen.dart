import 'package:flutter/material.dart';
import 'package:toudoum/screens/home.dart';
import 'main_page.dart';
import '../utils/localization.dart';

class SplashScreen extends StatefulWidget {
  final Localization localization;

  const SplashScreen({Key? key, required this.localization}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // lib/utils/dev_mode.dart
  int DEV_MODE = 0; // Set to 1 for development mode (bypasses login)

  @override
  void initState() {
    super.initState();
    // If DEV_MODE is 1, navigate directly to HomePage
    if (DEV_MODE == 1) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });
    } else {
      // If not in DEV_MODE, wait 3 seconds and go to the login screen
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(localization: widget.localization),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 200, height: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.red),
          ],
        ),
      ),
    );
  }
}
