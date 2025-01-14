import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/CategoryWidget.dart';

// Main Movie Grid Widget
class MainMovieGrid extends StatefulWidget {
  const MainMovieGrid({Key? key}) : super(key: key);

  @override
  _MainMovieGridState createState() => _MainMovieGridState();
}

class _MainMovieGridState extends State<MainMovieGrid> {
  final String apiUrl = "http://192.168.1.27:8980/api.php/home"; // Replace with your actual API URL
  final String featuredUrl = "http://192.168.1.27:8980/api.php/featured"; // API endpoint for featured movie

  Map<String, dynamic> movieCategories = {};
  Map<String, dynamic>? featuredMovie;
  bool isLoading = true;

  String? selectedCountry = 'US'; // Default selected country code
  final List<String> countries = ['US', 'FR', 'DE', 'IN']; // Example country codes

  ScrollController _scrollController = ScrollController(); // Controller to track scroll position
  bool _isScrolled = false; // Flag to detect scroll

  @override
  void initState() {
    super.initState();
    fetchApiResponse();
    fetchFeaturedMovie();

    // Listener to track scroll and change the app bar color
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 100; // Change 100 to control when it switches to gray
      });
    });
  }

  // Fetch the featured movie data
  Future<void> fetchFeaturedMovie() async {
    try {
      final response = await http.get(Uri.parse(featuredUrl));
      if (response.statusCode == 200) {
        setState(() {
          featuredMovie = json.decode(response.body); // Decode the response to map
        });
      } else {
        throw Exception("Failed to load featured movie");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fetch the main movie categories data
  Future<void> fetchApiResponse() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          movieCategories = json.decode(response.body); // Decode the response to map
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        movieCategories = {};
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isScrolled ? Color(0x363636).withOpacity(0.9) : Colors.black, // Change to gray when scrolled
        title: const Text(
          'Pour Melvyn',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Country flag select box in the AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: selectedCountry,
              icon: Icon(Icons.arrow_downward, color: Colors.white),
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCountry = newValue;
                });
              },
              items: countries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // You can replace this with country flag icons
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            // Centered container with border for featured movie and buttons
            featuredMovie != null
                ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),// White border
              ),
              child: Column(
                children: [
                  // Featured movie with border radius
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0), // Border radius for the image
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500" + featuredMovie!['poster_path'], // Use poster_path with base URL
                      fit: BoxFit.fitHeight,
                      height: 375, // Increased height for more prominence
                    ),
                  ),
                  // Row with play and add to favorites buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Play button
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, // White background
                              backgroundColor: Colors.white, // Black text
                              minimumSize: Size(160, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Slight border radius
                              ),
                            ),
                            icon: Icon(Icons.play_arrow, color: Colors.black), // Play icon
                            label: Text(
                              "Play",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Bold text
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8), // Add a small space between the buttons
                        // Add to favorites button
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800], // Dark gray background
                              foregroundColor: Colors.white, // White text
                              minimumSize: Size(160, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Slight border radius
                              ),
                            ),
                            icon: Icon(Icons.favorite_border, color: Colors.white), // Favorite icon
                            label: Text(
                              "Favori",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Bold text
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
                : SizedBox.shrink(),

            SizedBox(height: 24.0), // Additional space between buttons and carousels

            // Categories and Carousels
            ...movieCategories.entries.map((category) {
              // For each category, display its name and movies in a carousel
              return CategoryWidget(
                categoryName: category.key,
                movies: List<Map<String, dynamic>>.from(category.value), // Ensure correct type
              );
            }).toList(),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Black background for the body
    );
  }
}