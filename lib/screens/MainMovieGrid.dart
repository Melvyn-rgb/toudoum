import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/DatabaseHelper.dart';

class Mainmoviegrid extends StatefulWidget {
  const Mainmoviegrid({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Mainmoviegrid> {
  late Future<Map<String, dynamic>> _firstMovie;

  @override
  void initState() {
    super.initState();
    _firstMovie = _fetchFirstMovie();
  }

  Future<Map<String, dynamic>> _fetchFirstMovie() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> result = await db.query(
      'movies',
      limit: 1, // Get only the first row
    );
    if (result.isNotEmpty) {
      return result.first; // Return the first movie row
    } else {
      return {}; // Return an empty map if no movie is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firstMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading movie: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData) {
            var movie = snapshot.data!;
            if (movie.isEmpty) {
              return Center(
                child: Text(
                  'No movies found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Movie: ${movie['name']}',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
