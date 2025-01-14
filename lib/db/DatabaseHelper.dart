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
}

