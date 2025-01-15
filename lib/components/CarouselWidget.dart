import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'MovieDetailsBottomSheet.dart';

class CarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double height;
  final Function(Map<String, dynamic>) onTap;
  final bool isLoading;

  const CarouselWidget({
    Key? key,
    required this.items,
    this.height = 175.0,
    required this.onTap,
    this.isLoading = false, // Default to false (data loaded)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the width of each item (3 posters per screen)
    double itemWidth = screenWidth / 3;

    return Container(
      height: height,
      child: isLoading
          ? _buildSkeletonLoading(screenWidth)
          : ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          String posterUrl = item['poster_path'] ?? '';

          // Handle empty URLs gracefully
          if (posterUrl.isEmpty) {
            posterUrl = 'https://placehold.co/400x600/png'; // Fallback image
          } else {
            posterUrl = 'https://image.tmdb.org/t/p/w342$posterUrl';
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () => _showBottomSheet(context, item),
              child: Container(
                width: itemWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(posterUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 3.8 / 1, // Maintain the 3.8:1 width-to-height ratio
                  child: Container(), // The container for the image will maintain the aspect ratio
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _showBottomSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MovieDetailsBottomSheet(item: item),
    );
  }


  // Function to build skeleton loading for movie posters
  Widget _buildSkeletonLoading(double screenWidth) {
    double itemWidth = screenWidth / 3;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5, // Show 5 skeleton loaders as placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}