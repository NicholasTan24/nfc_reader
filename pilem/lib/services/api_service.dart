import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String apiKey = '43f0f0d19b6aef4ac263f94a2e03a83b';

  Future<List<Map<String, dynamic>>> getAllMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/movie/now_playing?api_key=$apiKey"),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // getTrendingMovies
  Future<List<Map<String, dynamic>>> getAllTrendingMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/trending/movie/day?api_key=$apiKey"),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // getPopularMovies
  Future<List<Map<String, dynamic>>> getAllPopularMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/movie/popular?api_key=$apiKey"),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}
