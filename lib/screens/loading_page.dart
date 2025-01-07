import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Netflix dark background
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.red, // Red loading indicator
        ),
      ),
    );
  }
}
