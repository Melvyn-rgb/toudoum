import 'package:flutter/material.dart';
import 'package:toudoum/screens/MainMovieGrid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Track the selected tab index

  // Define the pages for each tab
  final List<Widget> _pages = [
    Center(
      child: MainMovieGrid()
    ),
    Center(
      child: Text(
        'Explore Page',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Live TV Page',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'My Account Page',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Netflix-like dark background
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.black,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            backgroundColor: Colors.black,
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            backgroundColor: Colors.black,
            label: 'TV Channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            backgroundColor: Colors.black,
            label: 'Account',
          ),
        ],
        currentIndex: _currentIndex, // Fixed: use _currentIndex
        onTap: (index) => setState(() => _currentIndex = index), // Update _currentIndex
      ),
    );
  }
}