import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivarium/post/views/camera_screen.dart';
import 'package:vivarium/home/views/home_screen.dart';
import 'package:vivarium/post/view_models/create_post_view_model.dart';
import 'package:vivarium/post/views/widgets/post_category.dart';

class PostScreen extends ConsumerStatefulWidget {
  static const routeName = "Post";
  static const routeURL = "/Post";
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  int selectedCategoryIndex = 0;
  List<XFile> pictures = [];
  late TextEditingController _postTitleController;
  late TextEditingController _postContentController;
  @override
  void initState() {
    super.initState();
    _postTitleController = TextEditingController();
    _postContentController = TextEditingController();
  }

  void onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  Future<void> _onPostTap() async {
    String selectedCategory =
        selectedCategoryIndex >= 0 ? pickedText[selectedCategoryIndex] : "";
    ref.read(createPostProvider.notifier).createSoocho(
          selectedCategory,
          _postTitleController.text,
          _postContentController.text,
          pictures
              .map(
                (e) => File(e.path),
              )
              .toList(),
          context,
        );
    _postTitleController.clear();
    _postContentController.clear();
    pictures.clear();

    context.goNamed(HomeScreen.routeName);
  }

  @override
  void dispose() {
    _postTitleController.dispose();
    _postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 2,
            ),
            const Text("글쓰기"),
            GestureDetector(
              onTap: _onPostTap,
              child: const Text(
                "완료",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 36,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCategory(onCategorySelected: onCategorySelected),
              SizedBox(
                width: 500,
                child: Divider(
                  color: Colors.black.withOpacity(0.1),
                  thickness: 2.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: const [8, 4],
                radius: const Radius.circular(12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        autofocus: false,
                        maxLines: null,
                        minLines: null,
                        controller: _postTitleController,
                        decoration: const InputDecoration(
                          hintText: '제목을 30자 내외로 적어주세요',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: const [8, 4],
                radius: const Radius.circular(12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        autofocus: false,
                        maxLines: null,
                        minLines: null,
                        controller: _postContentController,
                        decoration: const InputDecoration(
                          hintText: '자유롭게 작성해주세요.',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("어떻게 하시겠습니까?"),
                        content: const Text("갤러리 또는 직접 찍어보세요"),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              final newPictures =
                                  await ImagePicker().pickMultiImage();

                              if (newPictures.isEmpty) {
                                navigator.pop();
                                return;
                              }

                              setState(() {
                                pictures = List.from(pictures)
                                  ..addAll(newPictures);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("갤러리"),
                          ),
                          TextButton(
                            onPressed: () async {
                              final newPictures =
                                  await Navigator.push<List<XFile>>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraScreen(),
                                ),
                              );

                              if (newPictures != null) {
                                setState(() {
                                  pictures = List.from(pictures)
                                    ..addAll(newPictures);
                                });
                              }
                              Navigator.pop(context);
                            },
                            child: const Text("직접 찍기"),
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
                },
                child: Row(
                  children: [
                    DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashPattern: const [8, 4],
                      radius: const Radius.circular(12),
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Center(
                          child: Image.asset(
                            "lib/assets/images/camera.png",
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      height: 80,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: pictures.map((XFile picture) {
                          return Stack(
                            children: [
                              SizedBox(
                                height: 90,
                                width: 90,
                                child: Image.file(
                                  File(picture.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    pictures.remove(picture);
                                  }),
                                  child: Icon(
                                    FontAwesomeIcons.solidCircleXmark,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
