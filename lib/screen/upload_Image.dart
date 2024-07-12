import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth/Signup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:socialmedia/Auth_view/Signup.dart';
import 'package:socialmedia/Auth_view/logen.dart';

class Imageup extends StatefulWidget {
  const Imageup({super.key, String? imageUrl});

  @override
  State<Imageup> createState() => _ImageupState();
}

class _ImageupState extends State<Imageup> {
  Uint8List? imageBytes;
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();

  void selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List? img = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = img;
      });
    }
  }

  void saveImage() async {
    String? userId = sinincontrollerImp.getCurrentUserUID();
    if (userId != null && imageBytes != null) {
      try {
        await Firebase.initializeApp();

        String base64Image = base64Encode(imageBytes!);

        String fieldName = 'profileImage';

        DatabaseReference dbRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .child(fieldName);

        // حذف الصورة القديمة إذا كانت موجودة
        dbRef.remove().then((_) {
          // إضافة الصورة الجديدة
          dbRef.set(base64Image).then((_) {
            print('تم رفع الصورة بنجاح إلى Realtime Database');
            Navigator.pop(context);
          }).catchError((error) {
            print('حدث خطأ أثناء رفع الصورة إلى Realtime Database: $error');
          });
        }).catchError((error) {
          print(
              'حدث خطأ أثناء حذف الصورة القديمة من Realtime Database: $error');
        });
      } catch (e) {
        print('حدث خطأ أثناء رفع الصورة إلى Realtime Database: $e');
      }
    }
  }

  void editProfileImage() {
    print('تم فتح صفحة تعديل الصورة');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(const SingUp());
          },
        ),
        centerTitle: true,
        title: const Text('صفحه رفع الصوره الشخصيه '),
        actions: [
          if (imageBytes != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveImage,
              tooltip: 'حفظ الصورة',
            ),
        ],
        elevation: 5,
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.yellow[300]!, Colors.orange[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: Colors.orange[600]!, width: 4),
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
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes!,
                            fit: BoxFit.cover,
                            width: 300,
                            height: 300,
                          )
                        : const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              saveImage();
              Get.offAll(const Logen());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'حفظ',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
