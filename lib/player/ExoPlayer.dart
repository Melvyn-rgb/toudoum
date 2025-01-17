import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For screen orientation control
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import '../db/DatabaseHelper.dart';

class HLSPlayerScreen extends StatefulWidget {
  final String streamUrl;
  final String movieId;
  const HLSPlayerScreen({Key? key, required this.streamUrl, required this.movieId}) : super(key: key);

  @override
  _HLSPlayerScreenState createState() => _HLSPlayerScreenState();
}

class _HLSPlayerScreenState extends State<HLSPlayerScreen> {
  late VlcPlayerController _vlcPlayerController;
  bool _isPlayerInitialized = false;
  double _progress = 0.0;
  double _duration = 0.0;
  bool _isBuffering = false; // Flag for buffering state

  // Sample language data (you can replace it with your own data)
  List<Map<String, dynamic>> languages = [];

  @override
  void initState() {
    super.initState();

    // Lock orientation to landscape and hide system UI
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top
    ]);

    // Initialize VLC Player
    _vlcPlayerController = VlcPlayerController.network(
      widget.streamUrl,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    _fetchLanguagesFromDatabase(widget.movieId);

    _vlcPlayerController.addListener(() {
      setState(() {
        _progress = _vlcPlayerController.value.position.inSeconds.toDouble();
        _duration = _vlcPlayerController.value.duration.inSeconds.toDouble();
        _isBuffering = _vlcPlayerController.value.isBuffering; // Check buffering state
      });
    });

    print("Stream URL: ${widget.streamUrl}");
  }

  @override
  void dispose() {
    // Reset orientation to portrait and show system UI on screen exit
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top
    ]);
    _vlcPlayerController.dispose();
    super.dispose();
  }

  // Method to seek the video
  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _vlcPlayerController.seekTo(position);
  }

  Future<void> _fetchLanguagesFromDatabase(String movieId) async {
    // Replace with your actual DatabaseHelper method that fetches languages for a movie
    List<Map<String, dynamic>> fetchedLanguages = await DatabaseHelper.fetchLanguagesForMovie(movieId);

    // Update the languages list
    setState(() {
      languages = fetchedLanguages;
    });
  }

  // Method to show the languages dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: languages.map((language) {
                return ListTile(
                  title: Text(language['movieTitle']),
                  onTap: () {
                    Navigator.of(context).pop();
                    print('Selected Language: $language');
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen video player
          Positioned.fill(
            child: VlcPlayer(
              controller: _vlcPlayerController,
              aspectRatio: 16 / 9, // Set aspect ratio for video
              virtualDisplay: true, // Virtual display (for fullscreen)
            ),
          ),
          // Timeline (progress bar) and button stacked over the player
          Positioned(
            bottom: 0, // Stick to the bottom of the screen
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Adjust vertical padding for space
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use min size to not take unnecessary space
                children: [
                  Slider(
                    value: _progress,
                    min: 0,
                    max: _duration > 0 ? _duration : 1,
                    onChanged: _seekTo,
                    activeColor: Colors.red,
                    inactiveColor: Colors.white54,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(Duration(seconds: _progress.toInt())),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        _formatDuration(Duration(seconds: _duration.toInt())),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Space between timeline and button
                  ElevatedButton(
                    onPressed: _showLanguageDialog,
                    child: Text('Select Language'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(120, 40), // Reduce button size
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      foregroundColor: Colors.black, // Button text color
                      backgroundColor: Colors.white, // Button background color
                    ),
                  ),
                  if (_isBuffering) // Show loading indicator if buffering
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format duration in hours:minutes:seconds
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }
}
