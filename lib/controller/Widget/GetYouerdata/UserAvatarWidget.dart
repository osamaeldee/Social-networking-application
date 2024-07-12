import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth/Signup.dart';

class UserAvatarWidgetY extends StatefulWidget {
  final String? name;
  final String? email;

  const UserAvatarWidgetY({Key? key, this.name, this.email}) : super(key: key);

  @override
  _UserAvatarWidgetYState createState() => _UserAvatarWidgetYState();
}

class _UserAvatarWidgetYState extends State<UserAvatarWidgetY> {
  final SinincontrollerImp sinincontrollerImp = Get.find<SinincontrollerImp>();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImage();
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: imageUrl != null
            ? MemoryImage(base64Decode(imageUrl!))
            : const AssetImage('image/logo.jpg') as ImageProvider,
        radius: 20,
      ),
      title: Text(
        widget.name ?? 'Anonymous',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.email ?? 'No email',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}
