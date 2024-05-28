import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
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
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPress(
    String postId,
    String category,
    String title,
    String content,
    List<String>? photoList,
    String creatorUid,
  ) {
    final currentUserUid = ref.read(authRepository).user?.uid;

    if (currentUserUid != creatorUid) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제 확인"),
          content: const Text("이 항목을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(deletePostProvider.notifier).deletePost(
                        postId,
                        context,
                      );
                  if (context.mounted) {
                    context.pop();
                  }
                } catch (e) {
                  // Handle the error if any
                  print(e);
                }
              },
              child: const Text("삭제"),
            ),
            TextButton(
              onPressed: () async {
                final List<File>? files =
                    photoList?.map((path) => File(path)).toList();
                final updatedData = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePostScreen(
                      categoryController: TextEditingController(text: category),
                      titleController: TextEditingController(text: title),
                      contentController: TextEditingController(text: content),
                      initialCategory: category,
                      initialTitle: title,
                      initialContent: content,
                      initialPhotoList: files,
                      postId: postId,
                    ),
                  ),
                );

                if (updatedData != null &&
                    updatedData.containsKey("newCategory") &&
                    updatedData.containsKey("newTitle") &&
                    updatedData.containsKey("newContent") &&
                    updatedData.containsKey("newPhoto")) {
                  final newCategory = updatedData["newCategory"] as String;
                  final newTitle = updatedData["newTitle"] as String;
                  final newContent = updatedData["newContent"] as String;
                  final newPhoto = updatedData["newPhoto"] as List<String>;

                  await ref.read(updatePostProvider.notifier).updatePost(
                        postId,
                        newCategory,
                        newTitle,
                        newContent,
                        newPhoto,
                      );

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
                title: Center(
                  child: SizedBox(
                    height: 50,
                    child: CupertinoSearchTextField(
                      controller: _controller,
                      placeholder: "수초나 동물이름, 궁금한 글 검색",
                      placeholderStyle: const TextStyle(
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
                                posts[index].photoList,
                                posts[index].creatorUid,
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
