import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth/Signup.dart';
import 'package:socialmedia/Widget/Appbar.dart';
import 'package:socialmedia/controller/Widget/GetYouerdata/Get_Your_data.dart';
import 'package:socialmedia/controller/Widget/GetYouerdata/PostActionsWidget.dart';
import 'package:socialmedia/controller/Widget/GetYouerdata/PostImagesWidget.dart';
import 'package:socialmedia/controller/Widget/GetYouerdata/PostTextWidget.dart';
import 'package:socialmedia/controller/Widget/GetYouerdata/UserAvatarWidget.dart';

class Youer_Post extends StatefulWidget {
  @override
  _Youer_PostState createState() => _Youer_PostState();
}

class _Youer_PostState extends State<Youer_Post> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  String? imageUrl;
  String? userName;
  List<Map<String, dynamic>> posts = [];
  bool isLoadingImage = true;
  bool isLoadingPosts = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchImage();
    _fetchPosts();
  }

  Future<void> _fetchUserData() async {
    try {
      String? userId = sinincontrollerImp.getCurrentUserUID();
      if (userId != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          if (mounted) {
            setState(() {
              userName = userSnapshot['name'];
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = 'حدث خطأ أثناء جلب البيانات';
        });
      }
    }
  }

  Future<void> _fetchImage() async {
    try {
      String? userId = sinincontrollerImp.getCurrentUserUID();
      if (userId != null) {
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .child('profileImage');
        DataSnapshot dataSnapshot = (await databaseReference.once()).snapshot;
        if (dataSnapshot.value != null) {
          String base64String = dataSnapshot.value.toString();
          if (mounted) {
            setState(() {
              imageUrl = base64String;
              isLoadingImage = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoadingImage = false;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching image: $e');
      if (mounted) {
        setState(() {
          isLoadingImage = false;
        });
      }
    }
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        isLoadingPosts = true;
      });

      List<Map<String, dynamic>> fetchedPosts =
          await PostDataFetcherYouer().fetchPosts();

      setState(() {
        posts.clear();
        posts.addAll(fetchedPosts);
        isLoadingPosts = false;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        isLoadingPosts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                isLoadingImage
                    ? Container(
                        height: 400,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        height: 400,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageUrl != null
                                ? MemoryImage(base64Decode(imageUrl!))
                                : const AssetImage('image/pro.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageUrl != null
                                      ? MemoryImage(base64Decode(imageUrl!))
                                      : const AssetImage('image/pro.jpg')
                                          as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              left: 20,
                              child: Text(
                                userName ?? 'اسم المستخدم',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
                isLoadingPosts
                    ? const Center(child: CircularProgressIndicator())
                    : posts.isEmpty
                        ? const Center(child: Text('No posts available.'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return _buildPostCard(posts[index]);
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    List<dynamic> comments = [];
    if (post['comments'] is List<dynamic>) {
      comments = List<dynamic>.from(post['comments']);
    }
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatarWidgetY(name: post['name'], email: post['email']),
          const SizedBox(height: 8),
          PostImagesWidgetY(
              imageBytesList: List<String>.from(post['imageBytesList'])),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PostTextWidgetY(text: post['text']),
          ),
          const SizedBox(height: 8),
          PostActionsWidgetY(comments: comments, postId: post['postId']),
        ],
      ),
    );
  }
}
