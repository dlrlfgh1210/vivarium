import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vivarium/home_screen.dart';
import 'package:vivarium/post/view_models/create_post_view_model.dart';
import 'package:vivarium/post/views/post_category.dart';

class PostScreen extends ConsumerStatefulWidget {
  static const routeName = "Post";
  static const routeURL = "/Post";
  const PostScreen({super.key});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  int selectedCategoryIndex = 0;
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
          context,
        );
    _postTitleController.clear();
    _postContentController.clear();

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
                        controller: _postContentController,
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
