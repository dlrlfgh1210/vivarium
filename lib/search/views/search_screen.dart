import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium/search/services/api_service.dart';
import 'package:vivarium/search/models/now_playing_model.dart';
import 'package:vivarium/search/models/popular_movie_model.dart';

import '../models/coming_soon_movie_model.dart';

final categories = [
  "ComingSoon",
  "Now",
  "Popular",
];

class SearchScreen extends StatefulWidget {
  static const routeName = "Search";
  static const routeURL = "/Search";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Future<List<PopularMovieModel>> populars =
      ApiService.getPopularMovies();
  final Future<List<NowPlayingMovieModel>> nows =
      ApiService.getnowPlayingMovies();
  final Future<List<ComingSoonMovieModel>> comings =
      ApiService.getcomingSoonMovies();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: const CupertinoSearchTextField(),
          ),
          centerTitle: true,
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            tabs: [
              for (var category in categories)
                Tab(
                  text: category,
                )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: comings,
              builder: (context, snapshotComing) {
                if (snapshotComing.hasData) {
                  return makeComingList(snapshotComing);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            FutureBuilder(
              future: nows,
              builder: (context, snapshotNow) {
                if (snapshotNow.hasData) {
                  return makeNowList(snapshotNow);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            FutureBuilder(
              future: populars,
              builder: (context, snapshotPopular) {
                if (snapshotPopular.hasData) {
                  return makePopularList(snapshotPopular);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

GridView makeComingList(
    AsyncSnapshot<List<ComingSoonMovieModel>> snapshotComing) {
  return GridView.builder(
    itemCount: snapshotComing.data!.length,
    padding: const EdgeInsets.all(
      5,
    ),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 6,
      childAspectRatio: 9 / 19,
    ),
    itemBuilder: (context, index) {
      var movie = snapshotComing.data![index];
      return GestureDetector(
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 9 / 15,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}

GridView makeNowList(AsyncSnapshot<List<NowPlayingMovieModel>> snapshotNow) {
  return GridView.builder(
    itemCount: snapshotNow.data!.length,
    padding: const EdgeInsets.all(
      5,
    ),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 6,
      childAspectRatio: 9 / 19,
    ),
    itemBuilder: (context, index) {
      var movie = snapshotNow.data![index];
      return GestureDetector(
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 9 / 15,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}

GridView makePopularList(
    AsyncSnapshot<List<PopularMovieModel>> snapshotPopular) {
  return GridView.builder(
    itemCount: snapshotPopular.data!.length,
    padding: const EdgeInsets.all(
      5,
    ),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 6,
      childAspectRatio: 9 / 19,
    ),
    itemBuilder: (context, index) {
      var movie = snapshotPopular.data![index];
      return GestureDetector(
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 9 / 15,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}
