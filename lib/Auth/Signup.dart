import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/Auth_view/logen.dart';
import 'package:socialmedia/screen/upload_Image.dart';

class SinincontrollerImp extends GetxController {
  GlobalKey<FormState> formstat = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final iconData = Icons.lock_clock_outlined;
  bool isshowpassword = true;

  @override
  void onInit() {
    password = TextEditingController();
    email = TextEditingController();
    name = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  void showpassword() {
    isshowpassword = !isshowpassword;
    update();
  }

  IconData icons() {
    return isshowpassword
        ? Icons.lock_clock_outlined
        : Icons.lock_open_outlined;
  }

  Future<bool> signup() async {
    var formdata = formstat.currentState;
    if (formdata!.validate()) {
      try {
        if (!GetUtils.isEmail(email.text.trim())) {
          Get.snackbar('Invalid Email', 'Please enter a valid email address',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }

        if (password.text.trim().length < 8) {
          Get.snackbar(
              'Weak Password', 'Password must be at least 8 characters long',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }

        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // Save user data to Firestore under user UID
        await usersCollection.doc(userCredential.user!.uid).set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'uid': userCredential.user!.uid,
        });

        Get.offAll(const Imageup());

        Get.snackbar('Success', 'Registration Successful',
            snackPosition: SnackPosition.BOTTOM);

        return true;
      } catch (e) {
        Get.snackbar('Error', 'Error signing up: $e',
            snackPosition: SnackPosition.BOTTOM, shouldIconPulse: true);
        print('Error signing up: $e');
        return false;
      }
    } else {
      print('Not valid');
      return false;
    }
  }

  void goToLogin() {
    Get.off(const Logen());
  }

  // Function to get current user UID
  String? getCurrentUserUID() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  // Function to get current user email
  getCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await usersCollection.doc(user.uid).get();
      return userData['email'];
    }
    return null;
  }

  // Function to get current user name
  getCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await usersCollection.doc(user.uid).get();
      return userData['name'];
    }
    ImageGetAndPut() {}
    return null;
  }
}
