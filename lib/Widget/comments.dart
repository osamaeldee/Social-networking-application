import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Auth/Signup.dart';

class CommentPage extends StatefulWidget {
  final String postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = [];
  String? userName;
  String? userEmail;
  String? errorText;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      String? userId = sinincontrollerImp.getCurrentUserUID();

      if (userId != null) {
        // Fetch user data (name and email) from Firestore
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          if (mounted) {
            setState(() {
              userName = userSnapshot['name'];
              userEmail = userSnapshot['email'];
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorText = 'Error fetching user data: $e';
        });
      }
    }

    // Fetch user profile image from Firebase Realtime Database
    _fetchUserImage();
  }

  Future<void> _fetchUserImage() async {
    try {
      String? userId = sinincontrollerImp.getCurrentUserUID();
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId!)
          .child('profileImage');

      DataSnapshot dataSnapshot = (await databaseReference.once()).snapshot;
      if (dataSnapshot.value != null) {
        String base64String = dataSnapshot.value.toString();
        setState(() {
          imageUrl = base64String;
        });
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  Future<void> _fetchComments() async {
    try {
      // Fetch comments from Firebase Realtime Database
      DatabaseEvent snapshot =
          await _database.child('posts/${widget.postId}/comments').once();

      DataSnapshot? dataSnapshot = snapshot.snapshot;
      if (dataSnapshot.value != null) {
        setState(() {
          comments = (dataSnapshot.value as Map<dynamic, dynamic>)
              .values
              .map((comment) => comment.toString())
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _addComment() async {
    String newComment = _commentController.text.trim();
    if (newComment.isEmpty) {
      return;
    }

    try {
      String? userId = sinincontrollerImp.getCurrentUserUID();
      String commentWithUser = '$newComment - $userName';

      if (userId != null) {
        // Add new comment to Firebase Realtime Database
        await _database
            .child('posts/${widget.postId}/comments')
            .push()
            .set(commentWithUser);

        setState(() {
          comments.add(commentWithUser);
        });

        _commentController.clear();
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments for Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add a Comment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Enter your comment here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _addComment,
                child: const Text('Add'),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                List<String> commentParts = comments[index].split(' - ');
                String commentText = commentParts[0];
                String commentUser =
                    commentParts.length > 1 ? commentParts[1] : 'Unknown';

                return ListTile(
                  leading: imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(base64Decode(imageUrl!)),
                        )
                      : const CircleAvatar(),
                  title: Text(commentText),
                  subtitle: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(
                          text: 'Comment by ',
                        ),
                        TextSpan(
                          text: commentUser,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
