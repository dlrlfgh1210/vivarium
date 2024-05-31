import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivarium/search/models/movie_detail_model.dart';
import 'package:vivarium/search/services/api_service.dart';

class SearchDetailScreen extends StatefulWidget {
  final String title, posterPath;
  final int id;
  const SearchDetailScreen({
    super.key,
    required this.title,
    required this.posterPath,
    required this.id,
  });

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  late Future<MovieDetailModel> details;
  late SharedPreferences favorites;
  bool isLiked = false;

  Future initFavorites() async {
    favorites = await SharedPreferences.getInstance();
    final likedMovies = favorites.getStringList('likedMovies');
    if (likedMovies != null && likedMovies.contains(widget.id.toString())) {
      setState(() {
        isLiked = true;
      });
    } else {
      await favorites.setStringList('likedMovies', []);
    }
  }

  @override
  void initState() {
    super.initState();
    details = ApiService.getMovieById(widget.id);
    initFavorites();
  }

  void onHeartTap() async {
    final likedMovies = favorites.getStringList('likedMovies');
    if (likedMovies != null) {
      setState(() {
        if (isLiked) {
          likedMovies.remove(widget.id.toString());
        } else {
          likedMovies.add(widget.id.toString());
        }
        isLiked = !isLiked;
      });
      await favorites.setStringList('likedMovies', likedMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Back to list',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
              color: Colors.red,
            ),
            iconSize: 40,
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500${widget.posterPath}',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 300,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                      future: details,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data!.genres.length;
                                      i++)
                                    Text(
                                      '${snapshot.data!.genres[i]['name']}${i == snapshot.data!.genres.length - 1 ? '' : ', '}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Storyline',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  snapshot.data!.overview,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const Text("...");
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
