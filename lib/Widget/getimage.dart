import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/Auth/Signup.dart';

class UserProfileSettingsPag extends StatefulWidget {
  const UserProfileSettingsPag({super.key});

  @override
  _UserProfileSettingsPagState createState() => _UserProfileSettingsPagState();
}

class _UserProfileSettingsPagState extends State<UserProfileSettingsPag> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  String? userName;
  String? imageUrl;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchImage();
  }

  Future<void> _fetchUserData() async {
    try {
      String? userId = sinincontrollerImp.getCurrentUserUID();

      if (userId != null) {
        // استرجاع الاسم
        DocumentSnapshot nameSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (nameSnapshot.exists) {
          setState(() {
            userName = nameSnapshot['name'];
          });
        }
      }
    } catch (e) {
      setState(() {
        errorText = 'حدث خطأ أثناء جلب البيانات: $e';
      });
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
          setState(() {
            imageUrl = base64String;
          });
        }
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings page'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: imageUrl != null
                    ? Image.memory(
                        base64Decode(imageUrl!),
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'الاسم: ${userName ?? ""}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'البريد الإلكتروني: ${sinincontrollerImp.getCurrentUserEmail() ?? ""}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
