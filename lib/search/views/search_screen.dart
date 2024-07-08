import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivarium/search/view_models/search_view_model.dart';
import 'package:vivarium/search/views/widget/category_grid_view.dart';

final categories = [
  "물고기",
  "새우",
  "수초",
  "도마뱀",
  "기타용품",
];

class SearchScreen extends ConsumerStatefulWidget {
  static const routeName = "Search";
  static const routeURL = "/Search";
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late SharedPreferences favorites;
  Set<String> likedNatures = {};
  late TextEditingController _controller;
  String selectedCategory = categories[0];

  Future initFavorites() async {
    favorites = await SharedPreferences.getInstance();
    final likedNaturesList = favorites.getStringList('likedNatures');
    if (likedNaturesList != null) {
      setState(() {
        likedNatures = likedNaturesList.toSet();
      });
    } else {
      await favorites.setStringList('likedNatures', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initFavorites();
    _controller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchViewModelProvider.notifier).fetchNatures(selectedCategory);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onHeartTap(String natureTitle) async {
    setState(() {
      if (likedNatures.contains(natureTitle)) {
        likedNatures.remove(natureTitle);
      } else {
        likedNatures.add(natureTitle);
      }
    });

    await favorites.setStringList('likedNatures', likedNatures.toList());
  }

  void _onSearchChanged(String query) {
    ref
        .read(searchViewModelProvider.notifier)
        .searchPosts(selectedCategory, query);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: categories.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 1,
            title: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: CupertinoSearchTextField(
                onChanged: _onSearchChanged,
                controller: _controller,
              ),
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
              onTap: (index) {
                setState(() {
                  selectedCategory = categories[index];
                  _controller.clear();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(searchViewModelProvider.notifier)
                        .fetchNatures(selectedCategory);
                  });
                });
              },
            ),
          ),
          body: Consumer(
            builder: (context, ref, child) {
              final searchState = ref.watch(searchViewModelProvider);
              return searchState.when(
                data: (natures) => natures.isEmpty
                    ? const Center(child: Text("검색 결과가 없습니다."))
                    : CategoryGridView(
                        category: selectedCategory,
                        likedNatures: likedNatures,
                        onHeartTap: onHeartTap,
                        onRefresh: initFavorites,
                        natures: natures,
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, stack) => const Center(child: Text("오류가 발생했습니다.")),
              );
            },
          ),
        ),
      ),
    );
  }
}
