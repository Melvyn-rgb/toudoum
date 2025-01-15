import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For screen orientation control
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class HLSPlayerScreen extends StatefulWidget {
  final String streamUrl;

  const HLSPlayerScreen({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSPlayerScreenState createState() => _HLSPlayerScreenState();
}

class _HLSPlayerScreenState extends State<HLSPlayerScreen> {
  late VlcPlayerController _vlcPlayerController;
  bool _isPlayerInitialized = false;
  double _progress = 0.0;
  double _duration = 0.0;

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

    // Listen to player progress
    _vlcPlayerController.addListener(() {
      setState(() {
        _progress = _vlcPlayerController.value.position.inSeconds.toDouble();
        _duration = _vlcPlayerController.value.duration.inSeconds.toDouble();
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
          // Timeline (progress bar) stacked over the player
          Positioned(
            bottom: 50, // Place the timeline over the video
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigitMinutes}:${twoDigitSeconds}";
  }
}
