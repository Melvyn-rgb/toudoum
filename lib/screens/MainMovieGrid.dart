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

  Map<String, dynamic> movieCategories = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApiResponse();
  }

  // Fetch API response as raw JSON
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
        title: Text('Movie Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: movieCategories.entries.map((category) {
            // For each category, display its name and movies in a carousel
            return CategoryWidget(
              categoryName: category.key,
              movies: List<Map<String, dynamic>>.from(category.value), // Ensure correct type
            );
          }).toList(),
        ),
      ),
      backgroundColor: Colors.black, // Black background for contrast
    );
  }
}
