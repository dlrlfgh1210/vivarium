import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vivarium/search/models/coming_soon_movie_model.dart';
import 'package:vivarium/search/models/movie_detail_model.dart';
import 'package:vivarium/search/models/now_playing_model.dart';
import 'package:vivarium/search/models/popular_movie_model.dart';

class ApiService {
  static String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static String popular = "popular";
  static String nowPlaying = "now-playing";
  static String comingSoon = "coming-soon";

  static Future<List<PopularMovieModel>> getPopularMovies() async {
    List<PopularMovieModel> popularInstances = [];
    final url = Uri.parse('$baseUrl/$popular');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      final movies = json['results'];
      for (var movie in movies) {
        popularInstances.add(PopularMovieModel.fromJson(movie));
      }
      return popularInstances;
    }
    throw Error();
  }

  static Future<List<NowPlayingMovieModel>> getnowPlayingMovies() async {
    List<NowPlayingMovieModel> nowInstances = [];
    final url = Uri.parse('$baseUrl/$nowPlaying');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      final List<dynamic> movies = json['results'];
      for (var movie in movies) {
        nowInstances.add(NowPlayingMovieModel.fromJson(movie));
      }
      return nowInstances;
    }
    throw Error();
  }

  static Future<List<ComingSoonMovieModel>> getcomingSoonMovies() async {
    List<ComingSoonMovieModel> comingInstances = [];
    final url = Uri.parse('$baseUrl/$comingSoon');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      final List<dynamic> movies = json["results"];

      for (var movie in movies) {
        comingInstances.add(ComingSoonMovieModel.fromJson(movie));
      }
      return comingInstances;
    }
    throw Error();
  }

  static Future<MovieDetailModel> getMovieById(int id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movie = jsonDecode(response.body);
      return MovieDetailModel.fromJson(movie);
    }
    throw Error();
  }
}
