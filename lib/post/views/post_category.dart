import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCategory extends StatefulWidget {
  const PostCategory({Key? key}) : super(key: key);

  @override
  State<PostCategory> createState() => _PostCategoryState();
}

class _PostCategoryState extends State<PostCategory> {
  String selectedText = '비바리움 질문';
  List<String> pickedText = [
    '비바리움 질문',
    '이름이 궁금해요',
    '내 아쿠아리움 자랑',
    '비바리움 팁',
    '수초나눔',
    '자유',
    '사용후기',
  ];

  void changeText(int index) {
    setState(() {
      selectedText = pickedText[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    for (int i = 0; i < pickedText.length; i++) {
      buttons.add(
        TextButton(
          onPressed: () {
            changeText(i);
            Navigator.pop(context);
          },
          child: Text(
            pickedText[i],
            style: TextStyle(
              color: selectedText == pickedText[i] ? Colors.green : Colors.grey,
              fontSize: 20,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selectedText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        IconButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    children: [
                      const Text(
                        "주제를 선택하세요",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 500,
                        child: Divider(
                          color: Colors.black.withOpacity(0.1),
                          thickness: 2.0,
                        ),
                      ),
                      ...buttons,
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined,
                            color: Colors.grey, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronDown,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
