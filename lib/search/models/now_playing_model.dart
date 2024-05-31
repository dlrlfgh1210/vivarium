class NowPlayingMovieModel {
  final String posterPath, title;
  final int id;

  NowPlayingMovieModel.fromJson(Map<String, dynamic> json)
      : posterPath = json['poster_path'],
        title = json['title'],
        id = json['id'];
}
