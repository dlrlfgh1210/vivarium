import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:vivarium/post/models/comment_model.dart';
import 'package:vivarium/post/view_models/comment_view_model.dart';

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
  bool _isReplying = false;
  bool _showReplies = false;
  final TextEditingController _replyController = TextEditingController();
  late final CommentViewModel _commentViewModel;

  String _getFormattedTime() {
    final DateTime now = DateTime.now();
    final DateTime commentDateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.comment.createdAt);
    final Duration difference = now.difference(commentDateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 시간 전';
    } else {
      return DateFormat('MM월 dd일').format(commentDateTime);
    }
  }

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.comment.creatorAvatarUrl.isNotEmpty
        ? widget.comment.creatorAvatarUrl
        : "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media";
    _commentViewModel =
        ref.read(commentProvider(widget.comment.postId).notifier);
  }

  void _toggleReplying() {
    setState(() {
      _isReplying = !_isReplying;
    });
    ref.read(bottomSheetVisibleProvider.notifier).state = !_isReplying;
  }

  void _toggleShowReplies() async {
    if (!_showReplies && widget.comment.replies.isEmpty) {
      List<CommentModel> replies =
          await _commentViewModel.getReplies(widget.comment.id);
      setState(() {
        widget.comment.replies.addAll(replies);
      });
    }
    setState(() {
      _showReplies = !_showReplies;
    });
  }

  void _addReply() {
    if (_replyController.text.isEmpty) return;

    final currentUser = ref.read(authRepository).user;
    if (currentUser == null) return;

    final newReply = CommentModel(
      id: '',
      postId: widget.comment.postId,
      content: _replyController.text,
      creatorUid: currentUser.uid,
      creatorEmail: currentUser.email!,
      creatorAvatarUrl:
          "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2F${currentUser.uid}?alt=media",
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _commentViewModel.addReply(widget.comment.id, newReply);

    setState(() {
      _replyController.clear();
      _isReplying = false;
    });
    ref.read(bottomSheetVisibleProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
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
          title: Row(
            children: [
              Text(
                widget.comment.creatorEmail.split('@')[0],
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.circle,
                size: 5,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(_getFormattedTime(),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          subtitle: Text(
            widget.comment.content,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          trailing: const FaIcon(
            FontAwesomeIcons.ellipsis,
            size: 20,
          ),
        ),
        if (_isReplying)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _replyController,
                  decoration: const InputDecoration(
                    hintText: '답글을 입력하세요...',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _toggleReplying,
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: _addReply,
                      child: const Text('답글 달기'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Row(
          children: [
            TextButton(
              onPressed: _toggleReplying,
              child: const Text("답글 달기"),
            ),
            if (widget.comment.replies.isNotEmpty)
              TextButton(
                onPressed: _toggleShowReplies,
                child: Text(_showReplies ? "접기" : "더보기"),
              ),
          ],
        ),
        if (_showReplies && widget.comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              children: widget.comment.replies.map((reply) {
                return CommentList(
                  comment: reply,
                  currentUserEmail: widget.currentUserEmail,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
