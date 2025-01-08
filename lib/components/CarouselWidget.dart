import 'package:flutter/material.dart';

// Reusable Carousel Widget
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
    return Container(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          String posterUrl = item['stream_icon'] ?? '';
          if (posterUrl.isEmpty) {
            posterUrl = 'https://placehold.co/400x600/png'; // Fallback image
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => onTap(item),
              child: Container(
                width: 150, // Width of each item
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
