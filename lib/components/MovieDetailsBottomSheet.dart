import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../db/DatabaseHelper.dart';
import '../player/ExoPlayer.dart';

class MovieDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> item;

  const MovieDetailsBottomSheet({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String movieId = item['movie_id']?.toString() ?? 'N/A';

    return FutureBuilder<http.Response>(
      future: http.get(Uri.parse('http://192.168.1.27:8980/api.php/movie/$movieId')),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(context);
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.statusCode != 200) {
          return _buildError(context);
        }

        Map<String, dynamic> movieDetails = json.decode(snapshot.data!.body);

        // Fetch the stream_id from the database based on tmdbId
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().searchMovie(tmdbId: movieId), // Use searchMovie by tmdbId
          builder: (context, dbSnapshot) {
            if (dbSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading(context);
            }

            if (dbSnapshot.hasError || !dbSnapshot.hasData || dbSnapshot.data!.isEmpty) {
              return _buildError(context);
            }

            // Get the stream_id from the database
            int numberOfResults = dbSnapshot.data!.length;

            String streamId = "";
            String containerExtension = "";

            if (numberOfResults == 1) {
              // If there's exactly 1 result, get the stream_id
              streamId = dbSnapshot.data!.first['stream_id']?.toString() ?? 'N/A';
              containerExtension = dbSnapshot.data!.first['container_extension']?.toString() ?? 'N/A';
              // Do something with the streamId
            } else {
              List<String> names = [];
              List<String> languageCodes = [];

              for (var item in dbSnapshot.data!) {
                String name = item['name']?.toString() ?? 'N/A';
                names.add(name);

                // Extract language code from the 'name' by splitting at ' - '
                String languageCode = name.split(' - ').first;
                languageCodes.add(languageCode);
              }

              // Print all language codes
              print("Language Codes in the results: ${languageCodes.join(', ')}");

              // Prioritize languages: 'FR', 'EN', 'NF', or use the first available language
              String selectedLanguage = '';
              for (var priority in ['FR', 'EN', 'NF']) {
                if (languageCodes.contains(priority)) {
                  selectedLanguage = priority;
                  break;
                }
              }

              // If no priority language is found, use the first language code available
              if (selectedLanguage.isEmpty) {
                selectedLanguage = languageCodes.first;
              }

              print("Selected Language: $selectedLanguage");

              // Get the first streamId and containerExtension
              streamId = dbSnapshot.data!.first['stream_id']?.toString() ?? 'N/A';
              containerExtension = dbSnapshot.data!.first['container_extension']?.toString() ?? 'N/A';
            }


            print(dbSnapshot.data!);
            return _buildContent(context, movieDetails, streamId, containerExtension);
          },
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: Text(
          'Failed to load movie details',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> movieDetails, String streamId, String containerExtension) {
    String title = movieDetails['title'] ?? 'N/A';
    String overview = movieDetails['overview'] ?? 'N/A';
    String tagline = movieDetails['tagline'] ?? 'N/A';
    double voteAverage = movieDetails['vote_average']?.toDouble() ?? 0.0;
    List<dynamic> genres = movieDetails['genres'] ?? [];
    String? trailerKey = movieDetails['trailer']?['key'];
    String? backdropPath = movieDetails['backdrop_path'];
    String? releaseDate = movieDetails['release_date'];
    String  streamUrl   = "http://fzahtv.com:80/movie/dc12a1f9bf/251dc788f523/" + streamId + "." + containerExtension;
    print(streamUrl);

    bool hasValidTrailer = trailerKey != null && trailerKey.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: hasValidTrailer
                ? YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: trailerKey!,
                  flags: YoutubePlayerFlags(
                    hideControls: true,
                    autoPlay: true,
                    mute: false,
                    enableCaption: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
                bottomActions: [
                  const SizedBox(width: 14.0),
                  CurrentPosition(),
                  const SizedBox(width: 8.0),
                  ProgressBar(isExpanded: true),
                  RemainingDuration(),
                  const PlaybackSpeedButton(),
                ],
              ),
              builder: (context, player) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: player,
                );
              },
            )
                : Image.network(
              'http://image.tmdb.org/t/p/original$backdropPath',
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      '$releaseDate',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HLSPlayerScreen(streamUrl: streamUrl),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      label: const Text(
                        'Play',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Text(
                      '$overview',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                      maxLines: 3, // Limit the text to 3 lines
                      overflow: TextOverflow.ellipsis, // Add ellipsis when text overflows
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Genres: ${genres.isNotEmpty ? genres.map((genre) => genre['name']).join(' · ') : 'N/A'}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Production: ${movieDetails['production_companies'].isNotEmpty ? movieDetails['production_companies'].map((company) => company['name']).join(' · ') : 'N/A'}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}