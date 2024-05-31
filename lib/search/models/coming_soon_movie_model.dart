class ComingSoonMovieModel {
  final String posterPath, title;
  final int id;

  ComingSoonMovieModel.fromJson(Map<String, dynamic> json)
      : posterPath = json['poster_path'],
        title = json['title'],
        id = json['id'];
}
