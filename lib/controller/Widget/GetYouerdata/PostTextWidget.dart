// ignore_for_file: dead_code

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostTextWidgetY extends StatelessWidget {
  final String? text;

  const PostTextWidgetY({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) {
      return const SizedBox.shrink();
    }

    const maxLines = 3;
    bool showMore = text!.split('\n').length > maxLines;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isExpanded = false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: isExpanded
                    ? text!
                    : text!.split('\n').take(maxLines).join('\n'),
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  if (!isExpanded && showMore)
                    TextSpan(
                      text: '... إقرأ المزيد',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isExpanded = true;
                          });
                        },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
