import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Auth/Signup.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final ImagePicker _picker = ImagePicker();
  final List<Uint8List> _imageBytesList = [];
  String _text = '';
  String? userName;
  String? userEmail;
  String? errorText;
  bool isPublishing = false;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
          setState(() {
            userName = userSnapshot['name'];
            userEmail = userSnapshot['email'];
          });
        }
      }
    } catch (e) {
      setState(() {
        errorText = 'حدث خطأ أثناء جلب البيانات: $e';
      });
    }
  }

  void _selectImage() async {
    if (_imageBytesList.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن رفع أكثر من صورتين!')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List? img = await pickedFile.readAsBytes();
      setState(() {
        _imageBytesList.add(img);
      });
    }
  }

  Future<void> _fetchImage() async {
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
      print('Error fetching image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageBytesList.removeAt(index);
    });
  }

  void _publishPost() async {
    if (_imageBytesList.isEmpty || _text.isEmpty) {
      return;
    }

    setState(() {
      isPublishing = true;
    });

    try {
      await Firebase.initializeApp();

      List<String> base64Images =
          _imageBytesList.map((img) => base64Encode(img)).toList();

      String? userId = sinincontrollerImp.getCurrentUserUID();

      var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      var postId = 'post_$timestamp';

      // Directly use the fetched image URL
      await _fetchImage(); // Assuming _fetchImage sets the imageUrl correctly

      await _database.child('posts/$userId/$postId').set({
        'image_bytes_list': base64Images,
        'text': _text,
        'email': userEmail,
        'name': userName,
        'timestamp': ServerValue.timestamp,
        'likes': 0,
        'comments': [],
        'profile_image': imageUrl, // Use fetched image URL directly
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نشر المنشور بنجاح!')),
      );

      setState(() {
        _imageBytesList.clear();
        _text = '';
      });
    } catch (e) {
      print('Error uploading post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء النشر!')),
      );
    } finally {
      setState(() {
        isPublishing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('إضافة منشور'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                height: 300,
                color: Colors.grey[300],
                child: _imageBytesList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageBytesList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.memory(
                                  _imageBytesList[index],
                                  fit: BoxFit.cover,
                                  height: 300,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'أدخل تعريف المنتج هنا...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isPublishing ? null : _publishPost,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: isPublishing ? Colors.grey : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: isPublishing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'نشر',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            if (errorText != null)
              Text(
                errorText!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
