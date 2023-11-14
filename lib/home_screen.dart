import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/home_container.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';
import 'package:vivarium/post/views/post_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = "home";
  static const routeURL = "/home";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(postProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => const Center(
            child: Text("Could not load moods."),
          ),
          data: (posts) {
            return Scaffold(
              appBar: AppBar(
                title: const Center(
                  child: SizedBox(
                    height: 50,
                    child: CupertinoSearchTextField(
                      placeholder: "수초나 동물이름, 궁금한 글 검색",
                      placeholderStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => context.pushNamed(PostScreen.routeName),
                elevation: 0,
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(postProvider.notifier).refetch();
                },
                child: posts.isEmpty
                    ? const Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                            child: HomeContainer(
                              category: posts[index].category,
                              title: posts[index].title,
                              content: posts[index].content,
                              uploadTime: posts[index].createdAt,
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) => Container(
                          height: 0,
                        ),
                        itemCount: posts.length,
                      ),
              ),
            );
          },
        );
  }
}
