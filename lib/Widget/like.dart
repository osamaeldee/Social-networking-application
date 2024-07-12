import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth/Signup.dart';

class LikeButton extends StatefulWidget {
  final String postId;

  const LikeButton({required this.postId, Key? key}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isLiked = false;
  int _likesCount = 0;
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = sinincontrollerImp.getCurrentUserUID() ?? '';
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final likeSnapshot = await _database
        .child('posts/$userId/${widget.postId}/likes/$userId')
        .get();
    if (mounted) {
      setState(() {
        _isLiked = likeSnapshot.exists;
      });
    }

    final postSnapshot = await _database
        .child('posts/$userId/${widget.postId}/likesCount')
        .get();
    if (postSnapshot.exists && mounted) {
      setState(() {
        _likesCount = postSnapshot.value as int;
      });
    }
  }

  void _toggleLike() async {
    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
      });
    }

    final postRef = _database.child('posts/$userId/${widget.postId}');
    if (_isLiked) {
      await postRef.child('likes/$userId').set(true);
      await postRef.child('likesCount').set(ServerValue.increment(1));
    } else {
      await postRef.child('likes/$userId').remove();
      await postRef.child('likesCount').set(ServerValue.increment(-1));
    }

    final postSnapshot = await postRef.child('likesCount').get();
    if (postSnapshot.exists && mounted) {
      setState(() {
        _likesCount = postSnapshot.value as int;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: _toggleLike,
        ),
        Text('$_likesCount'),
      ],
    );
  }
}
