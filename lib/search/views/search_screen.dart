import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivarium/search/models/nature_model_provider.dart';
import 'package:vivarium/search/views/search_detail_screen.dart';

final categories = [
  "물고기",
  "새우",
  "수초",
  "도마뱀",
  "기타용품",
];

class SearchScreen extends StatefulWidget {
  static const routeName = "Search";
  static const routeURL = "/Search";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SharedPreferences favorites;
  Set<int> likedNatures = {};

  Future initFavorites() async {
    favorites = await SharedPreferences.getInstance();
    final likedNaturesList = favorites.getStringList('likedNatures');
    if (likedNaturesList != null) {
      setState(() {
        likedNatures = likedNaturesList.map((id) => int.parse(id)).toSet();
      });
    } else {
      await favorites.setStringList('likedNatures', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initFavorites();
  }

  void onHeartTap(int natureId) async {
    setState(() {
      if (likedNatures.contains(natureId)) {
        likedNatures.remove(natureId);
      } else {
        likedNatures.add(natureId);
      }
    });

    await favorites.setStringList(
        'likedNatures', likedNatures.map((id) => id.toString()).toList());
  }

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
          bottom: TabBar(
            tabAlignment: TabAlignment.center,
            splashFactory: NoSplash.splashFactory,
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
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
            for (var category in categories)
              CategoryGridView(
                category: category,
                likedNatures: likedNatures,
                onHeartTap: onHeartTap,
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryGridView extends ConsumerWidget {
  final String category;
  final Set<int> likedNatures;
  final Function(int) onHeartTap;

  const CategoryGridView({
    super.key,
    required this.category,
    required this.likedNatures,
    required this.onHeartTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(natureProvider.notifier).fetchNatures(category);
    final natures = ref.watch(natureProvider);

    if (natures.isEmpty) {
      return const Center(child: Text("데이터가 없습니다."));
    } else {
      return GridView.builder(
        itemCount: natures.length,
        padding: const EdgeInsets.all(5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          childAspectRatio: 9 / 19,
        ),
        itemBuilder: (context, index) {
          var natural = natures[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchDetailScreen(
                    nature: natural,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AspectRatio(
                        aspectRatio: 9 / 15,
                        child: Image.network(
                          natural.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onHeartTap(index),
                      icon: Icon(
                        likedNatures.contains(index)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                      ),
                      iconSize: 35,
                      color: Colors.white,
                    ),
                  ],
                ),
                Text(
                  natural.title,
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
  }
}
