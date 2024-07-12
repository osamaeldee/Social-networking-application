import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmedia/Auth/Signup.dart';
import 'package:socialmedia/Auth_view/Signup.dart';
import 'package:socialmedia/home/homepage.dart';
import 'package:socialmedia/screen/Edit%20the%20image.dart';

class UserProfileSettingsPage extends StatefulWidget {
  const UserProfileSettingsPage({super.key});

  @override
  _UserProfileSettingsPageState createState() =>
      _UserProfileSettingsPageState();
}

class _UserProfileSettingsPageState extends State<UserProfileSettingsPage> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  String? userName;
  String? userEmail;
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
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          if (mounted) {
            // Check if the widget is still mounted
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
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(const SingUp());
  }

  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('كلمة المرور القديمة غير صحيحة')),
        );
      }
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                _signOut();
              },
              child: const Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تغيير كلمة المرور'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration:
                    const InputDecoration(labelText: 'كلمة المرور الحالية'),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration:
                    const InputDecoration(labelText: 'كلمة المرور الجديدة'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                _changePassword(
                  currentPasswordController.text,
                  newPasswordController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('تغيير'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Any additional cleanup can be done here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الحساب'),
        backgroundColor: const Color.fromARGB(255, 255, 251, 251),
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(const Homepage());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showSignOutDialog,
          ),
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: _showChangePasswordDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                InkWell(
                  onTap: () {
                    Get.off(const Edit_the_image());
                  },
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFD4AF37), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: imageUrl != null
                          ? Image.memory(
                              base64Decode(imageUrl!),
                              fit: BoxFit.cover,
                              width: 180,
                              height: 180,
                            )
                          : const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'الاسم: ${userName ?? ""}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              'البريد الإلكتروني: ${userEmail ?? ""}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
