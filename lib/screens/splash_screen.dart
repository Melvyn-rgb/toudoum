import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'package:toudoum/screens/home.dart';
import 'package:toudoum/screens/loading_page.dart';
import 'main_page.dart';
import '../utils/localization.dart';

class SplashScreen extends StatefulWidget {
  final Localization localization;

  const SplashScreen({Key? key, required this.localization}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Development mode flag
  int DEV_MODE = 1; // Set to 1 for development mode (bypasses login)
  int SHOULD_RELOAD_DB = 0; // Set to 1 to delete and reload the database

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (SHOULD_RELOAD_DB == 1) {
      await _deleteDatabaseFile();
    }

    if (DEV_MODE == 1) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingPage(),
          ),
        );
      });
    } else {
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

  Future<void> _deleteDatabaseFile() async {
    try {
      String dbPath = Path.join(await getDatabasesPath(), 'movies.db');
      File dbFile = File(dbPath);

      if (await dbFile.exists()) {
        await dbFile.delete();
        print('Database file deleted successfully.');
      } else {
        print('No database file found to delete.');
      }
    } catch (e) {
      print('Error deleting database file: $e');
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
