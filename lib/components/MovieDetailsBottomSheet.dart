import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
        return _buildContent(context, movieDetails);
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

  Widget _buildContent(BuildContext context, Map<String, dynamic> movieDetails) {
    String title = movieDetails['title'] ?? 'N/A';
    String overview = movieDetails['overview'] ?? 'N/A';
    String tagline = movieDetails['tagline'] ?? 'N/A';
    double voteAverage = movieDetails['vote_average']?.toDouble() ?? 0.0;
    List<dynamic> genres = movieDetails['genres'] ?? [];

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: movieDetails['trailer']['key'],
      flags: YoutubePlayerFlags(
        hideControls: true,
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
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
                  ProgressBar(
                    isExpanded: true,
                  ),
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
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Title: $title',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text('Overview: $overview', style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Tagline: $tagline', style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Vote Average: $voteAverage', style: TextStyle(fontSize: 16, color: Colors.white)),
                    SizedBox(height: 8),
                    Text(
                      'Genres: ${genres.isNotEmpty ? genres.map((genre) => genre['name']).join(', ') : 'N/A'}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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