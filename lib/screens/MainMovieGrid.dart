import 'package:flutter/material.dart';
import '../db/DatabaseHelper.dart';
import '../player/ExoPlayer.dart';
import '../components/CarouselWidget.dart';

// Main Movie Grid Screen
class MainMovieGrid extends StatefulWidget {
  const MainMovieGrid({Key? key}) : super(key: key);

  @override
  _MainMovieGridState createState() => _MainMovieGridState();
}

class _MainMovieGridState extends State<MainMovieGrid> {
  late Future<List<Map<String, dynamic>>> _randomMovies;

  @override
  void initState() {
    super.initState();
    _randomMovies = _fetchRandomMovies();
  }

  Future<List<Map<String, dynamic>>> _fetchRandomMovies() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM movies WHERE tmdb IS NOT NULL AND tmdb != "" AND stream_icon IS NOT NULL AND stream_icon != "" ORDER BY RANDOM() LIMIT 10',
    );

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
                    CarouselWidget(
                      items: movies,
                      onTap: (movie) {
                        String streamId = movie['stream_id']?.toString() ?? '';
                        String streamUrl = 'http://portott.com:80/movie/dc12a1f9bf/251dc788f523/$streamId.mkv';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HLSPlayerScreen(
                              streamUrl: streamUrl,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    if (missingPosterMovies.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: missingPosterMovies.length,
                          itemBuilder: (context, index) {
                            var movie = missingPosterMovies[index];
                            return Card(
                              color: Colors.grey[850],
                              child: ListTile(
                                title: Text(
                                  movie['name'] ?? 'Unknown',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'TMDb ID: ${movie['tmdb_id'] ?? 'Unknown ID'}',
                                  style: TextStyle(color: Colors.white70),
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