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
  final String apiUrl = "http://10.0.2.2:8980/api.php/home"; // Replace with your actual API URL
  final String featuredUrl = "http://10.0.2.2:8980/api.php/featured"; // API endpoint for featured movie

  Map<String, dynamic> movieCategories = {};
  Map<String, dynamic>? featuredMovie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApiResponse();
    fetchFeaturedMovie();
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
      appBar: AppBar(
        title: const Text(
          'Pour Melvyn',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // App bar with black background
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the featured movie with border radius and padding
            featuredMovie != null
                ? Container(
              width: double.infinity,
              height: 600, // Increased height for more prominence
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://image.tmdb.org/t/p/w500" + featuredMovie!['poster_path'], // Use poster_path with base URL
                  ),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(16.0), // Border radius added here
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    featuredMovie!['original_name'],
                    style: TextStyle(
                      fontSize: 28, // Larger font size for better visibility
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black.withOpacity(0.5), offset: Offset(2, 2))
                      ],
                    ),
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),

            SizedBox(height: 24.0), // Increased padding between the featured poster and the carousels

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
      backgroundColor: Colors.black, // Black background for contrast
    );
  }
}