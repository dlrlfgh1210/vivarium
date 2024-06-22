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
    super.key,
    required this.comment,
    required this.currentUserEmail,
  });

  @override
  ConsumerState<CommentList> createState() => _CommentListState();
}

class _CommentListState extends ConsumerState<CommentList> {
  late String _avatarUrl;
  bool _isReplying = false;
  bool _showReplies = false;
  final TextEditingController _replyController = TextEditingController();
  late final CommentViewModel _commentViewModel;

  final List<String> _reportReasons = [
    '광고',
    '폭언/욕설/혐오 발언',
    '불법성 정보',
    '음란성 정보',
    '개인정보 노출'
  ];
  late Map<String, bool> _selectedReasons;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.comment.creatorAvatarUrl.isNotEmpty
        ? widget.comment.creatorAvatarUrl
        : "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media";
    _commentViewModel =
        ref.read(commentProvider(widget.comment.postId).notifier);
    _selectedReasons = {for (var reason in _reportReasons) reason: false};
  }

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

  void _addReply() async {
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

    await _commentViewModel.addReply(widget.comment.id, newReply);

    setState(() {
      _replyController.clear();
      _isReplying = false;
      widget.comment.replies.add(newReply); // 상태를 즉시 업데이트
    });
    ref.read(bottomSheetVisibleProvider.notifier).state = true;
  }

  void _reportComment() {
    _commentViewModel.reportComment(widget.comment.id);
  }

  void _reportReply(int replyCreatedAt) {
    _commentViewModel.reportReply(widget.comment.id, replyCreatedAt);
  }

  void _showReportBottomSheet({int? replyCreatedAt}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '신고 이유',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._reportReasons.map((reason) {
                    return CheckboxListTile(
                      title: Text(reason),
                      value: _selectedReasons[reason],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedReasons[reason] = value ?? false;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (replyCreatedAt != null) {
                            _reportReply(replyCreatedAt);
                          } else {
                            _reportComment();
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text('신고하기'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
          trailing: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.ellipsis,
              size: 20,
            ),
            onPressed: () => _showReportBottomSheet(),
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
                    hintText: '답글을 입력하세요',
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
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              children: widget.comment.replies.map((reply) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: ClipOval(
                      child: Image.network(
                        reply.creatorAvatarUrl.isNotEmpty
                            ? reply.creatorAvatarUrl
                            : "null",
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
                        reply.creatorEmail.split('@')[0],
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
                    reply.content,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.ellipsis,
                      size: 20,
                    ),
                    onPressed: () =>
                        _showReportBottomSheet(replyCreatedAt: reply.createdAt),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
