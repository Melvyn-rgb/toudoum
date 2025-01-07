import 'package:flutter/material.dart';
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
      'SELECT * FROM movies WHERE tmdb IS NOT NULL AND tmdb != "" AND stream_icon IS NOT NULL AND stream_icon != "" ORDER BY RANDOM() LIMIT 10',
    );

    // Debug: Print the result to ensure it contains valid data
    print('Fetched movies: $result');

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
              List<Map<String, dynamic>> missingPosterMovies = movies
                  .where((movie) => (movie['stream_icon'] ?? '').isEmpty)
                  .toList();
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

                          // Fallback image if the stream_icon is null or empty
                          String posterUrl = movie['stream_icon'] ?? '';
                          if (posterUrl.isEmpty) {
                            posterUrl = 'https://placehold.co/400x600/png'; // Fallback image
                          }

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
                                    image: NetworkImage(posterUrl), // Displaying the stream icon
                                    fit: BoxFit.cover, // Make sure the image covers the container
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    // ListView of missing posters (movie details)
                    if (missingPosterMovies.isNotEmpty)
                      Container(
                        height: 200, // Limit the height of the list
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: missingPosterMovies.length,
                          itemBuilder: (context, index) {
                            var movie = missingPosterMovies[index];
                            String movieName = movie['name'] ?? 'Unknown';
                            String tmdbId = movie['tmdb_id'] ?? 'Unknown ID';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                color: Colors.grey[850],
                                child: ListTile(
                                  title: Text(
                                    movieName,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'TMDb ID: $tmdbId',
                                    style: TextStyle(color: Colors.white70),
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
