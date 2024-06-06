import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentInputField extends StatefulWidget {
  final Function(String) addComment;

  const CommentInputField({super.key, required this.addComment});

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  bool _isWriting = false;
  TextEditingController commentController = TextEditingController();

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
            backgroundColor: Colors.grey.shade500,
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
                hintText: "Add a comment...",
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
