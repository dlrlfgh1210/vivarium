import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivarium/post/models/comment_model.dart';

class CommentList extends ConsumerStatefulWidget {
  final CommentModel comment;
  final String? currentUserEmail;

  const CommentList({
    Key? key,
    required this.comment,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  ConsumerState<CommentList> createState() => _CommentListState();
}

class _CommentListState extends ConsumerState<CommentList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: FaIcon(
          FontAwesomeIcons.users,
          color: Colors.white,
        ),
      ),
      title: Text(
        'Posted by ${widget.comment.creatorEmail.split('@')[0]}',
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        widget.comment.content,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
