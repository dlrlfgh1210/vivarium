class MovieDetailModel {
  final String posterPath, title, overview;
  final int id;
  final bool isAdult;
  final List genres;
  final dynamic stars;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        posterPath = json['poster_path'],
        overview = json['overview'],
        isAdult = json['adult'],
        genres = json['genres'],
        stars = json['vote_average'];
}
