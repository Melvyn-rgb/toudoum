import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/DatabaseHelper.dart';

class Mainmoviegrid extends StatefulWidget {
  const Mainmoviegrid({Key? key}) : super(key: key);

  @override
  _MainmoviegridState createState() => _MainmoviegridState();
}

class _MainmoviegridState extends State<Mainmoviegrid> {
  late Future<List<Map<String, dynamic>>> _randomMovies;

  @override
  void initState() {
    super.initState();
    _randomMovies = _fetchRandomMovies();
  }

  // Fetch 10 random movies
  Future<List<Map<String, dynamic>>> _fetchRandomMovies() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // Query to get 10 random movies from the database
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM movies ORDER BY RANDOM() LIMIT 10',
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _randomMovies,
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
                'Error loading movies: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData) {
            var movies = snapshot.data!;
            if (movies.isEmpty) {
              return Center(
                child: Text(
                  'No movies found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Horizontal carousel (one-line view)
                    Container(
                      height: 250, // Limit the height of the carousel
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          var movie = movies[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                // Handle movie tap (e.g., show details or play the movie)
                              },
                              child: Container(
                                width: 150, // Width of each movie poster
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(movie['stream_icon']), // Displaying the stream icon
                                    fit: BoxFit.cover, // Make sure the image covers the container
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
