import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/home/views/home_container.dart';
import 'package:vivarium/post/view_models/delete_post_view_model.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';
import 'package:vivarium/post/view_models/update_post_view_model.dart';
import 'package:vivarium/post/views/post_detail_screen.dart';
import 'package:vivarium/post/views/post_screen.dart';
import 'package:vivarium/post/views/update_post_screen.dart';
import 'package:vivarium/users/models/user_profile_model.dart';
import 'package:vivarium/users/view_models/users_view_model.dart';

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
  ) async {
    final currentUserUid = ref.read(authRepository).user?.uid;

    if (currentUserUid != creatorUid) {
      return;
    }

    final pickedText = [
      '질문',
      '이름이 궁금해요',
      '내 자연 자랑',
      '나만의 팁',
      '나눔',
      '자유',
      '사용후기',
    ];
    final initialCategoryIndex = pickedText.indexOf(category);

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("어떻게 하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () async {
                await ref.read(deletePostProvider.notifier).deletePost(
                      postId,
                      context,
                    );
                if (context.mounted) {
                  context.pop(true);
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
                      initialCategoryIndex: initialCategoryIndex,
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

                Navigator.pop(context, false);
              },
              child: const Text("수정"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("취소"),
            ),
          ],
        );
      },
    );

    if (result == null || result == false) {
    } else if (result == true) {
      await ref.read(postProvider.notifier).refetch();
    }
  }

  void _onSearchChanged(String query) {
    ref.watch(postProvider.notifier).searchPosts(query);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(postProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => const Center(
            child: Text("다시 확인 해주세요"),
          ),
          data: (posts) {
            // Filter out reported posts
            final currentUserUid = ref.read(authRepository).user?.uid;
            final filteredPosts = posts
                .where((post) => !post.reportedBy.contains(currentUserUid))
                .toList();

            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: SizedBox(
                    height: 50,
                    child: CupertinoSearchTextField(
                      onChanged: _onSearchChanged,
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
                child: filteredPosts.isEmpty
                    ? const Center(
                        child: Text(
                          "글이 없습니다",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: ((context, index) {
                          return FutureBuilder<UserProfileModel>(
                            future: ref
                                .read(usersProvider.notifier)
                                .getUserProfile(
                                    filteredPosts[index].creatorUid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Error loading user"));
                              } else if (!snapshot.hasData) {
                                return const Center(
                                    child: Text("No user data"));
                              } else {
                                final userProfile = snapshot.data!;
                                final post = filteredPosts[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 20,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetailScreen(
                                            postId: post.id,
                                          ),
                                        ),
                                      );
                                    },
                                    onLongPress: () => _onLongPress(
                                      filteredPosts[index].id,
                                      filteredPosts[index].category,
                                      filteredPosts[index].title,
                                      filteredPosts[index].content,
                                      filteredPosts[index].photoList,
                                      filteredPosts[index].creatorUid,
                                    ),
                                    child: HomeContainer(
                                      postId: filteredPosts[index].id,
                                      category: filteredPosts[index].category,
                                      title: filteredPosts[index].title,
                                      content: filteredPosts[index].content,
                                      photoList: filteredPosts[index].photoList,
                                      uploadTime:
                                          filteredPosts[index].createdAt,
                                      writer: userProfile.email.split('@')[0],
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }),
                        separatorBuilder: (context, index) => Container(
                          height: 0,
                        ),
                        itemCount: filteredPosts.length,
                      ),
              ),
            );
          },
        );
  }
}
