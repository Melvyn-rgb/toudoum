import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'movies.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE movies(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          stream_id INTEGER,
          name TEXT,
          stream_icon TEXT,
          tmdb TEXT,
          stream_type TEXT,
          container_extension TEXT
        )
      ''');
      },
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            'ALTER TABLE movies ADD COLUMN container_extension TEXT',
          );
        }
      },
    );
  }

  Future<int> insertMovie(Map<String, dynamic> movie) async {
    final db = await database;
    return db.insert('movies', movie);
  }

  Future<List<Map<String, dynamic>>> fetchMovies() async {
    final db = await database;
    return db.query('movies');
  }

  // Search for a movie by tmdb or movie_id
  Future<List<Map<String, dynamic>>> searchMovie({int? movieId, String? tmdbId}) async {
    final db = await database;

    if (movieId != null) {
      // Search by movie ID
      return db.query('movies', where: 'id = ?', whereArgs: [movieId]);
    } else if (tmdbId != null) {
      // Search by tmdb ID
      return db.query('movies', where: 'tmdb = ?', whereArgs: [tmdbId]);
    } else {
      return [];
    }
  }



  static Future<List<Map<String, dynamic>>> fetchLanguagesForMovie(String movieId) async {
    final db = await DatabaseHelper().database;

    // Fetch the movie details using the movie ID
    List<Map<String, dynamic>> movieDetails = await DatabaseHelper().searchMovie(tmdbId: movieId);

    List<Map<String, dynamic>> result = []; // To hold the movie and title association

    // Check if movie details exist
    if (movieDetails.isNotEmpty) {
      print('Found movie with ID: $movieId');

      // Loop through the movie details
      for (var movie in movieDetails) {
        String title = movie['name'] ?? 'No Name'; // Replace 'name' with the correct column name
        String id = movie['id'].toString(); // Assuming 'id' is the column name for movie ID

        // Print for debugging
        print('Movie Title: $title');

        // Create a map with movie id and title
        result.add({
          'movieId': id,
          'movieTitle': title,
        });
      }
    } else {
      print('No movie found with ID: $movieId');
    }

    return result; // Return the list of movies with their titles
  }

}