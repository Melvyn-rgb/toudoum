import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double height;
  final Function(Map<String, dynamic>) onTap;

  const CarouselWidget({
    Key? key,
    required this.items,
    this.height = 250.0,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          String posterUrl = 'https://image.tmdb.org/t/p/w1280' + item['poster_path'] ?? '';
          if (posterUrl.isEmpty) {
            posterUrl = 'https://placehold.co/400x600/png'; // Fallback image
          }

          // Calculate the width of each poster (3.5 posters per screen)
          double itemWidth = screenWidth / 3.5;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0), // Adjusted padding for more space
            child: GestureDetector(
              onTap: () => onTap(item),
              child: Container(
                width: itemWidth, // Set width to fit 3.5 posters
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(posterUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
