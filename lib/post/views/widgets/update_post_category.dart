import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<String> pickedText = [
  '질문',
  '이름이 궁금해요',
  '내 자연 자랑',
  '나만의 팁',
  '나눔',
  '자유',
  '사용후기',
];

class UpdatePostCategory extends StatefulWidget {
  final ValueChanged<int> onCategoryEdited;
  final TextEditingController categoryController;
  final int initialIndex;

  const UpdatePostCategory({
    super.key,
    required this.onCategoryEdited,
    required this.categoryController,
    required this.initialIndex,
  });

  @override
  State<UpdatePostCategory> createState() => _UpdatePostCategoryState();
}

class _UpdatePostCategoryState extends State<UpdatePostCategory> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    for (int i = 0; i < pickedText.length; i++) {
      buttons.add(
        TextButton(
          onPressed: () {
            setState(() {
              selectedIndex = i;
            });
            widget.onCategoryEdited(selectedIndex);

            widget.categoryController.text = pickedText[selectedIndex];
            Navigator.pop(context);
          },
          child: Text(
            pickedText[i],
            style: TextStyle(
              color: selectedIndex == i ? Colors.green : Colors.grey,
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
          pickedText[selectedIndex],
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
