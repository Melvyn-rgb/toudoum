import 'package:flutter/material.dart';

import 'CarouselWidget.dart';

// Category Widget for displaying a category with a carousel of movies
class CategoryWidget extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> movies; // Changed the type to List<Map<String, dynamic>>

  const CategoryWidget({
    Key? key,
    required this.categoryName,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Padding between categories
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Category Name
          Text(
            categoryName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White font color
            ),
          ),
          SizedBox(height: 8.0),
          // Display Movies in a carousel under the Category
          CarouselWidget(
            items: movies,
            onTap: (movie) {
              // Action on tap (you can modify this to navigate to a movie details page, for example)
              print('Tapped on: ${movie['original_name']}');
            },
          ),
        ],
      ),
    );
  }
}