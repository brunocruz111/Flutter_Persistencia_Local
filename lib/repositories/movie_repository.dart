import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class MovieRepository {
  static const String _storageKey = 'movies_list';

  Future<List<Movie>> loadAll() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? encodedMovies = preferences.getString(_storageKey);

    final List<Movie> movies = <Movie>[];

    if (encodedMovies != null && encodedMovies.isNotEmpty) {
      final dynamic decoded = jsonDecode(encodedMovies);

      if (decoded is List) {
        movies.addAll(
          decoded.map(
            (dynamic item) => Movie.fromJson(item as Map<String, dynamic>),
          ),
        );
      }
    } else {
      final List<String> legacyEncodedMovies =
          preferences.getStringList(_storageKey) ?? <String>[];

      movies.addAll(
        legacyEncodedMovies.map(
          (String item) => Movie.fromJson(
            jsonDecode(item) as Map<String, dynamic>,
          ),
        ),
      );
    }

    movies.sort(
      (Movie first, Movie second) => first.title.toLowerCase().compareTo(
            second.title.toLowerCase(),
          ),
    );

    return movies;
  }

  Future<void> saveAll(List<Movie> movies) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String encodedMovies = jsonEncode(
      movies.map((Movie movie) => movie.toJson()).toList(),
    );
    await preferences.setString(_storageKey, encodedMovies);
  }

  Future<void> upsert(Movie movie) async {
    final List<Movie> movies = await loadAll();
    final int index = movies.indexWhere((Movie item) => item.id == movie.id);

    if (index == -1) {
      movies.add(movie);
    } else {
      movies[index] = movie;
    }

    await saveAll(movies);
  }

  Future<void> deleteById(String id) async {
    final List<Movie> movies = await loadAll();
    movies.removeWhere((Movie movie) => movie.id == id);
    await saveAll(movies);
  }

  Future<void> clearAll() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}