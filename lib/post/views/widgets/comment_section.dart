import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/comment_model.dart';
import 'package:vivarium/post/views/widgets/comment_list.dart';

class CommentSection extends ConsumerStatefulWidget {
  final List<CommentModel> comments;
  final Function(String) addComment;

  const CommentSection({
    super.key,
    required this.comments,
    required this.addComment,
  });

  @override
  ConsumerState<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final ScrollController _scrollController = ScrollController();

  void _stopWriting() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = ref.read(authRepository).user?.email ?? '';

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      child: GestureDetector(
        onTap: _stopWriting,
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              return CommentList(
                comment: widget.comments[index],
                currentUserEmail: currentUserEmail,
              );
            },
            padding: const EdgeInsets.only(bottom: 80),
          ),
        ),
      ),
    );
  }
}
