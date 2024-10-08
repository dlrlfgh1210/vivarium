import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivarium/post/views/camera_screen.dart';
import 'package:vivarium/post/views/widgets/update_post_category.dart';

class UpdatePostScreen extends ConsumerStatefulWidget {
  static const routeName = "UpdatePost";
  static const routeURL = "/UpdatePost";
  final TextEditingController categoryController;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String initialCategory;
  final String initialTitle;
  final String initialContent;
  final List<File>? initialPhotoList;
  final String postId;
  final int initialCategoryIndex;
  const UpdatePostScreen({
    super.key,
    required this.categoryController,
    required this.titleController,
    required this.contentController,
    required this.initialCategory,
    required this.initialTitle,
    required this.initialContent,
    this.initialPhotoList,
    required this.postId,
    required this.initialCategoryIndex,
  });

  @override
  ConsumerState<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends ConsumerState<UpdatePostScreen> {
  void onCategoryEdited(int index) {}

  List<XFile> photoList = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialPhotoList != null) {
      photoList =
          widget.initialPhotoList!.map((file) => XFile(file.path)).toList();
    }
  }

  Future<void> _onUpdateTap() async {
    final newCategory = widget.categoryController.text;
    final newTitle = widget.titleController.text;
    final newContent = widget.contentController.text;

    final List<String> photoPaths = [];
    final List<XFile> updatedPhotoList = [];

    for (var xFile in photoList) {
      if (xFile.path.startsWith('http')) {
        photoPaths.add(xFile.path);
      } else {
        final file = File(xFile.path);
        if (file.existsSync()) {
          photoPaths.add(file.path);
          updatedPhotoList.add(xFile);
        }
      }
    }

    final updatedData = {
      "newCategory": newCategory,
      "newTitle": newTitle,
      "newContent": newContent,
      "newPhoto": photoPaths,
    };

    Navigator.pop(context, updatedData);
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
            const Text("수정하기"),
            GestureDetector(
              onTap: _onUpdateTap,
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
              UpdatePostCategory(
                onCategoryEdited: onCategoryEdited,
                categoryController: widget.categoryController,
                initialIndex: widget.initialCategoryIndex,
              ),
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
                        controller: widget.titleController,
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
                        controller: widget.contentController,
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("어떻게 하시겠습니까?"),
                            content: const Text("갤러리 또는 카메라"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  final newPictures =
                                      await ImagePicker().pickMultiImage();
                                  if (newPictures.isNotEmpty) {
                                    setState(() {
                                      photoList.addAll(newPictures);
                                    });
                                  }
                                  navigator.pop();
                                },
                                child: const Text("갤러리"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final newPictures =
                                      await Navigator.push<List<XFile>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CameraScreen(),
                                    ),
                                  );

                                  if (newPictures != null) {
                                    setState(() {
                                      photoList.addAll(newPictures);
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
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      strokeWidth: 1,
                      dashPattern: const [8, 4],
                      radius: const Radius.circular(12),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Center(
                          child: Image.asset(
                            "lib/assets/images/camera.png",
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photoList.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.hardEdge,
                              height: 90,
                              width: 90,
                              child: photoList[index].path.startsWith('http')
                                  ? Image.network(
                                      photoList[index].path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(photoList[index].path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    photoList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
