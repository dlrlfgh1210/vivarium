import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vivarium/post/view_models/post_view_model.dart';

class HomeContainer extends ConsumerStatefulWidget {
  final String category, title, content, writer;
  final int uploadTime;
  final List<String>? photoList;
  final String postId;

  const HomeContainer({
    super.key,
    required this.category,
    required this.title,
    required this.content,
    required this.uploadTime,
    required this.writer,
    this.photoList,
    required this.postId,
  });

  @override
  ConsumerState<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends ConsumerState<HomeContainer> {
  late final List<String> _reportReasons;
  late final Map<String, bool> _selectedReasons;

  @override
  void initState() {
    super.initState();
    _reportReasons = ['광고', '폭언/욕설/혐오 발언', '불법성 정보', '음란성 정보', '개인정보 노출'];
    _selectedReasons = {for (var reason in _reportReasons) reason: false};
  }

  void _showReportBottomSheet() {
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
                          Navigator.of(context).pop(); // 모달 닫기
                        },
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(postProvider.notifier)
                              .reportPost(widget.postId);
                          Navigator.of(context).pop(); // 모달 닫기
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

  String _getFormattedTime() {
    final DateTime now = DateTime.now();
    final DateTime uploadDateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.uploadTime ~/ 1000);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.writer,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.content,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.photoList != null && widget.photoList!.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        height: 128,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.photoList!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                widget.photoList![index],
                                fit: BoxFit.cover,
                                height: 128,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getFormattedTime(),
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.ellipsis,
                size: 20,
              ),
              onPressed: _showReportBottomSheet,
            ),
          ],
        )
      ],
    );
  }
}
