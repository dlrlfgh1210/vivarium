import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/comment_model.dart';
import 'package:vivarium/post/view_models/comment_view_model.dart';
import 'package:vivarium/post/view_models/post_detail_view_model.dart';
import 'package:vivarium/post/views/widgets/comment_input_field.dart';
import 'package:vivarium/post/views/widgets/comment_section.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;
  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addComment(String content) async {
    final currentUser = ref.read(authRepository).user;
    final currentUserEmail = currentUser?.email ?? '';
    final currentUserUid = currentUser?.uid ?? '';
    final currentUserAvatarUrl = currentUser != null
        ? "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2F${currentUser.uid}?alt=media"
        : "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media";

    if (currentUser == null) {
      return;
    }

    final comment = CommentModel(
      id: '',
      postId: widget.postId,
      content: content,
      creatorUid: currentUserUid,
      creatorEmail: currentUserEmail,
      creatorAvatarUrl: currentUserAvatarUrl,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await ref.read(commentProvider(widget.postId).notifier).addComment(comment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postDetail = ref.watch(postDetailProvider(widget.postId));
    final comments = ref.watch(commentProvider(widget.postId));
    final bottomSheetVisible = ref.watch(bottomSheetVisibleProvider);

    return postDetail.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Error loading post details')),
      data: (post) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                        child: Center(
                          child: Text(
                            post.category,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(
                    width: 500,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashPattern: const [8, 4],
                    radius: const Radius.circular(12),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        post.content,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (post.photoList.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: post.photoList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Image.network(
                                post.photoList[index],
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(500)),
                                  child: Text(
                                    '${index + 1} / ${post.photoList.length}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  CommentSection(
                    comments: comments.asData?.value ?? [],
                    addComment: _addComment,
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: bottomSheetVisible
              ? CommentInputField(addComment: _addComment)
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
