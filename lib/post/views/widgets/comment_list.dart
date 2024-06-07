import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late String _avatarUrl;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.comment.creatorAvatarUrl.isNotEmpty
        ? widget.comment.creatorAvatarUrl
        : "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 18,
        child: ClipOval(
          child: Image.network(
            _avatarUrl,
            fit: BoxFit.cover,
            width: 36,
            height: 36,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media",
                fit: BoxFit.cover,
                width: 36,
                height: 36,
              );
            },
          ),
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
