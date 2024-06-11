import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivarium/authentication/repos/authentication_repo.dart';
import 'package:http/http.dart' as http;

class CommentInputField extends ConsumerStatefulWidget {
  final Function(String) addComment;

  const CommentInputField({
    super.key,
    required this.addComment,
  });

  @override
  ConsumerState<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends ConsumerState<CommentInputField> {
  bool _isWriting = false;
  TextEditingController commentController = TextEditingController();

  String avatarUrl =
      "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media";

  @override
  void initState() {
    super.initState();
    loadAvatar();
  }

  void loadAvatar() async {
    final currentUser = ref.read(authRepository).user;
    if (currentUser != null) {
      final avatarTestUrl =
          "https://firebasestorage.googleapis.com/v0/b/vivarium-soocho.appspot.com/o/avatars%2F${currentUser.uid}?alt=media";
      var response = await http.head(Uri.parse(avatarTestUrl));
      if (response.statusCode == 200) {
        setState(() {
          avatarUrl = avatarTestUrl;
        });
      }
    }
  }

  void _handleAddComment() {
    if (_isWriting) {
      widget.addComment(commentController.text);
      commentController.clear();
      _stopWriting();
    }
  }

  void _onTextChanged(String text) {
    setState(() {
      _isWriting = text.isNotEmpty;
    });
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: commentController,
              onChanged: _onTextChanged,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                hintText: "댓글 달아주세요",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                suffixIcon: _isWriting
                    ? GestureDetector(
                        onTap: _handleAddComment,
                        child: FaIcon(
                          FontAwesomeIcons.circleArrowUp,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
