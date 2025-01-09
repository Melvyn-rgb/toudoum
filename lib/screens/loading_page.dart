import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import '../db/DatabaseHelper.dart';
import '../db/ApiHandler.dart';
import '../screens/home.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  String _progressMessage = "Initializing...";

  @override
  void initState() {
    super.initState();
    _checkDatabaseAndProceed();
  }

  Future<void> _checkDatabaseAndProceed() async {
    try {
      setState(() {
        _progressMessage = "Checking database existence...";
      });

      // Check if the database file exists
      String dbPath = Path.join(await getDatabasesPath(), 'movies.db');
      bool dbExists = await File(dbPath).exists();

      if (dbExists) {
        setState(() {
          _progressMessage = "Database found. Loading Home Page...";
        });
        // Navigate to HomePage if the database already exists
        _navigateToHome();
      } else {
        setState(() {
          _progressMessage = "Database not found. Initializing...";
        });
        // Create the database and populate it if it doesn't exist
        await _initializeDatabase();
        setState(() {
          _progressMessage = "Database initialized. Loading Home Page...";
        });
        _navigateToHome();
      }
    } catch (e) {
      // Handle errors (e.g., show an error message)
      setState(() {
        _progressMessage = "Error: $e";
      });
      print('Error during database initialization: $e');
    }
  }

  Future<void> _initializeDatabase() async {
    // Initialize the DatabaseHelper
    DatabaseHelper dbHelper = DatabaseHelper();

    // Fetch movies from the API
    try {
      setState(() {
        _progressMessage = "Fetching movies from API...";
      });

      List<Map<String, dynamic>> movies = await fetchMoviesFromAPI();
      int totalMovies = movies.length; // Total number of movies
      int insertedCount = 0; // Counter for inserted movies

      // Insert movies into the database
      for (var movie in movies) {
        await dbHelper.insertMovie(movie);
        insertedCount++; // Increment counter

        // Update progress message
        setState(() {
          _progressMessage =
          "Inserting movies into database... ($insertedCount / $totalMovies)";
        });
      }

      setState(() {
        _progressMessage = "Movies successfully added to the database.";
      });
    } catch (e) {
      setState(() {
        _progressMessage = "Error fetching or inserting movies: $e";
      });
      print('Error fetching or inserting movies: $e');
    }
  }


  void _navigateToHome() {
    Navigator.pushReplacement(
      context, // No need to cast or modify this
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Netflix dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.red, // Red loading indicator
            ),
            const SizedBox(height: 20),
            Text(
              _progressMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}