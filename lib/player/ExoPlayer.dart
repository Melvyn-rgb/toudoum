import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HLSPlayerScreen extends StatefulWidget {
  final String streamUrl; // Stream URL passed as parameter

  const HLSPlayerScreen({Key? key, required this.streamUrl}) : super(key: key);

  @override
  _HLSPlayerScreenState createState() => _HLSPlayerScreenState();
}

class _HLSPlayerScreenState extends State<HLSPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlayerInitialized = false;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  // Initialize the video player with the stream URL
  Future<void> _initializePlayer() async {
    try {
      // Use HLS stream URL passed from the widget
      _controller = VideoPlayerController.network(widget.streamUrl)
        ..initialize().then((_) {
          setState(() {
            _isPlayerInitialized = true;
          });
          _controller.play();
          _controller.setLooping(true);  // Optional: loop video
        });
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = "Error initializing player: $e";
      });
      print(_errorMessage); // Log error
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HLS Stream'),
        backgroundColor: Colors.red,
      ),
      body: _isError
          ? Center(
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      )
          : Center(
        child: _isPlayerInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

