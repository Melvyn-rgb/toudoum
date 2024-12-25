import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Netflix-like dark background
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(
            color: Colors.white, // White text color
            fontSize: 24, // Large font size
            fontWeight: FontWeight.bold, // Bold text
          ),
          textAlign: TextAlign.center, // Center the text
        ),
      ),
    );
  }
}