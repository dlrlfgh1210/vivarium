import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/post/models/comment_model.dart';
import 'package:vivarium/post/view_models/comment_view_model.dart';
import 'package:vivarium/post/view_models/post_detail_view_model.dart';

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

  Future<void> _addComment() async {
    final comment = CommentModel(
      id: '', // ID는 Firestore에서 자동 생성됨
      postId: widget.postId,
      content: _commentController.text,
      creatorUid: 'creatorUid', // 실제 사용자 UID로 교체
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await ref.read(commentProvider(widget.postId).notifier).addComment(comment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postDetail = ref.watch(postDetailProvider(widget.postId));

    return postDetail.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Error loading post details')),
      data: (post) {
        return Scaffold(
          appBar: AppBar(
            title: Text(post.title),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.category),
                Text(post.title),
                Text(post.content),
                ...post.photoList.map((photo) => Image.network(photo)),
                // Comments section
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(labelText: 'Add a comment'),
                ),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text('Submit'),
                ),
                // Display comments
                Consumer(
                  builder: (context, watch, child) {
                    final comments = ref.watch(commentProvider(widget.postId));
                    return comments.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) =>
                          const Text('Error loading comments'),
                      data: (comments) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return ListTile(
                              title: Text(comment.content),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
