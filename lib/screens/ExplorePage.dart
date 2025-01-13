import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePage createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  List movies = [];
  bool isLoading = false;

  // Fetch movies from the API
  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        movies = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('http://10.0.2.2:8980/api.php/search?query=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List fetchedMovies = json.decode(response.body);
        setState(() {
          movies = fetchedMovies;
        });
      } else {
        setState(() {
          movies = [];
        });
      }
    } catch (e) {
      setState(() {
        movies = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                fetchMovies(query);
              },
              style: const TextStyle(color: Colors.white), // White font
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black, // Black background
                labelText: 'Search for movies',
                labelStyle: const TextStyle(color: Colors.white), // White label text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white), // White border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white), // White border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white), // White border when enabled
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : movies.isEmpty
                ? const Center(
              child: Text(
                'No movies found',
                style: TextStyle(color: Colors.white), // White text for no results
              ),
            )
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2 / 3, // Vertical poster-like aspect ratio
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  color: Colors.black,
                  elevation: 3.0,
                  child: movie['poster_path'] != null
                      ? Image.network(
                    "https://image.tmdb.org/t/p/w600_and_h900_bestv2" + movie['poster_path'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                      : const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}