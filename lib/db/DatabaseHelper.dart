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
            stream_type TEXT
          )
        ''');
      },
      version: 1,
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
}
