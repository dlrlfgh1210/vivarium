import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/views/update_post_category.dart';

class UpdatePostScreen extends ConsumerStatefulWidget {
  static const routeName = "UpdatePost";
  static const routeURL = "/UpdatePost";
  final TextEditingController categoryController;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String initialCategory;
  final String initialTitle;
  final String initialContent;
  final String postId;
  const UpdatePostScreen({
    Key? key,
    required this.categoryController,
    required this.titleController,
    required this.contentController,
    required this.initialCategory,
    required this.initialTitle,
    required this.initialContent,
    required this.postId,
  }) : super(key: key);

  @override
  ConsumerState<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends ConsumerState<UpdatePostScreen> {
  void onCategoryEdited(int index) {}

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
              onTap: () async {
                final newCategory = widget.categoryController.text;
                final newTitle = widget.titleController.text;
                final newContent = widget.contentController.text;

                Navigator.pop(context, {
                  "newCategory": newCategory,
                  "newTitle": newTitle,
                  "newContent": newContent,
                });
              },
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
                          hintText: '제목(필수) - 30자 내외로 적어주세요',
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
                          hintText:
                              '본문(필수) \n-최소 1자~1000자 이내 작성할 수 있어요. \n-게시물이 다른 유저로부터 신고를 받거나 운영 \n정책에 맞지 않을 경우 숨김 처리 돼요.',
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
            ],
          ),
        ),
      ),
    );
  }
}
