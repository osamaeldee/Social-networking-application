import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostTextWidget extends StatefulWidget {
  final String? text;

  const PostTextWidget({Key? key, this.text}) : super(key: key);

  @override
  _PostTextWidgetState createState() => _PostTextWidgetState();
}

class _PostTextWidgetState extends State<PostTextWidget> {
  bool isExpanded = false;
  bool showMore = false; // Added to toggle between expanded and collapsed views

  @override
  void initState() {
    super.initState();
    showMore = widget.text!.split('\n').length >
        3; // Check if text exceeds 3 lines initially
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text == null || widget.text!.isEmpty) {
      return const SizedBox.shrink();
    }

    const maxLines = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: showMore
                ? widget.text!
                : widget.text!.split('\n').take(maxLines).join('\n'),
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              if (!showMore)
                TextSpan(
                  text: '... إقرأ المزيد',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        showMore = true;
                      });
                    },
                ),
            ],
          ),
        ),
        if (showMore)
          TextButton(
            onPressed: () {
              setState(() {
                showMore = false;
              });
            },
            child: Text(
              'عرض أقل',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
