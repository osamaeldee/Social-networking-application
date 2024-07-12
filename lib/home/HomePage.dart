import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth_view/getYouerdart/PostActionsWidget.dart';
import 'package:socialmedia/Widget/Appbar.dart';
import 'package:socialmedia/controller/Widget/GetAlldata/PostImagesWidget.dart';
import 'package:socialmedia/controller/Widget/GetAlldata/PostTextWidget.dart';
import 'package:socialmedia/controller/Widget/GetAlldata/UserAvatarWidget.dart';
import 'package:socialmedia/controller/Widget/GetAlldata/get_veiw.dart';
import '../Auth/Signup.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  final PostDataFetcher _dataFetcher = PostDataFetcher();
  List<Map<String, dynamic>> posts = [];
  bool isLoading = false;
  String? userName;
  String? userEmail;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _fetchUserNameAndEmail();
  }

  Future<void> _fetchUserNameAndEmail() async {
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
              userEmail = userSnapshot['email'];
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorText = 'حدث خطأ أثناء جلب البيانات: $e';
        });
      }
    }
  }

  Future<void> _fetchPosts() async {
    try {
      if (mounted) {
        setState(() {});
      }

      List<Map<String, dynamic>> fetchedPosts = await _dataFetcher.fetchPosts();

      setState(() {
        posts.clear();
        posts.addAll(fetchedPosts);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: isLoading
              ? Image.asset('image/loading.gif')
              : posts.isEmpty
                  ? Image.asset('image/loading.gif')
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return _buildPostCard(posts[index]);
                      },
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
          UserAvatarWidget(
            name: post['name'],
            email: post['email'],
            imageUrl: post['profile_image'],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PostTextWidget(text: post['text']),
          ),
          const SizedBox(height: 8),
          PostImagesWidget(
            imageBytesList: List<String>.from(post['imageBytesList']),
          ),
          const SizedBox(height: 8),
          PostActionsWidget(comments: comments, postId: post['postId']),
        ],
      ),
    );
  }
}
