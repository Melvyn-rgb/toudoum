import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchMoviesFromAPI() async {
  final url = 'http://fzahtv.com/player_api.php?username=dc12a1f9bf&password=251dc788f523&action=get_vod_streams';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> movies = json.decode(response.body);
    return movies.map((movie) {
      return {
        'stream_id': movie['stream_id'],
        'name': movie['name'],
        'stream_icon': movie['stream_icon'],
        'tmdb': movie['tmdb'],
        'stream_type': movie['stream_type'],
        'container_extension': movie['container_extension'],
      };
    }).toList();
  } else {
    throw Exception('Failed to load movies');
  }
}