import 'package:flutter/material.dart';
import 'package:socialmedia/Widget/comments.dart';
import 'package:socialmedia/Widget/like.dart';

class PostActionsWidgetY extends StatelessWidget {
  final List<dynamic> comments;
  final String postId;

  const PostActionsWidgetY(
      {Key? key, required this.comments, required this.postId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _showCommentsDialog(context, comments, postId),
            child: const Row(
              children: [
                Icon(Icons.comment),
                SizedBox(width: 4),
                Text('Comments'),
              ],
            ),
          ),
          LikeButton(postId: postId),
        ],
      ),
    );
  }

  void _showCommentsDialog(
      BuildContext context, List<dynamic> comments, String postId) {
    showDialog(
      context: context,
      builder: (context) => CommentPage(postId: postId),
    );
  }
}
