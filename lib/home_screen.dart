import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/home_container.dart';
import 'package:vivarium/post/view_models/delete_post_view_model.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';
import 'package:vivarium/post/view_models/update_post_view_model.dart';
import 'package:vivarium/post/views/post_screen.dart';
import 'package:vivarium/post/views/update_post_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = "home";
  static const routeURL = "/home";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _onLongPress(
      String postId, String category, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제 확인"),
          content: const Text("이 항목을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () async {
                await ref.read(deletePostProvider.notifier).deletePost(
                      postId,
                      context,
                    );
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text("삭제"),
            ),
            TextButton(
              onPressed: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePostScreen(
                      categoryController: TextEditingController(text: category),
                      titleController: TextEditingController(text: title),
                      contentController: TextEditingController(text: content),
                      initialCategory: category,
                      initialTitle: title,
                      initialContent: content,
                      postId: postId,
                    ),
                  ),
                );
                Navigator.pop(context);
                if (updatedData != null &&
                    updatedData.containsKey("newCategory") &&
                    updatedData.containsKey("newTitle") &&
                    updatedData.containsKey("newContent")) {
                  final newCategory = updatedData["newCategory"];
                  final newTitle = updatedData["newTitle"];
                  final newContent = updatedData["newContent"];

                  await ref
                      .read(updatePostProvider.notifier)
                      .updatePost(postId, newCategory, newTitle, newContent);

                  await ref.read(postProvider.notifier).refetch();
                }
              },
              child: const Text("수정"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
          ],
        );
      },
    );
  }

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
                            child: GestureDetector(
                              onLongPress: () => _onLongPress(
                                posts[index].id,
                                posts[index].category,
                                posts[index].title,
                                posts[index].content,
                              ),
                              child: HomeContainer(
                                category: posts[index].category,
                                title: posts[index].title,
                                content: posts[index].content,
                                photoList: posts[index].photoList,
                                uploadTime: posts[index].createdAt,
                              ),
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
