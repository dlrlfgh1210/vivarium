import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeContainer extends StatelessWidget {
  final String category, title, content;
  final int uploadTime;
  final List<String>? photoList;
  const HomeContainer({
    super.key,
    required this.category,
    required this.title,
    required this.content,
    required this.uploadTime,
    this.photoList,
  });

  String _getFormattedTime() {
    final DateTime now = DateTime.now();
    final DateTime uploadDateTime =
        DateTime.fromMillisecondsSinceEpoch(uploadTime ~/ 1000);
    final Duration difference = now.difference(uploadDateTime);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 시간 전';
    } else {
      return DateFormat('MM월 dd일').format(uploadDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 400,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(-2, 5),
              )
            ],
            border: Border.all(
              color: Colors.black,
              width: 2,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                photoList != null && photoList!.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        height: 128,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: photoList!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                photoList![index],
                                fit: BoxFit.cover,
                                height: 128,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          _getFormattedTime(),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
