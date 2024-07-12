// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmedia/Auth_view/Signup.dart';
import 'package:socialmedia/home/homepage.dart';

abstract class Logninconteroller extends GetxController {
  lognin();
  Gotosingup();
}

class lognincontrollerImp extends Logninconteroller {
  static bool is_logged_in = false;

  GlobalKey<FormState> formstat = GlobalKey<FormState>();
  late TextEditingController password;
  late TextEditingController email;
  final iconData = Icons.lock_clock_outlined;
  bool isshowpassword = true;
  showpassword() {
    isshowpassword = !isshowpassword;
    update();
  }

  @override
  lognin() async {
    var formdata = formstat.currentState;
    if (formdata!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        Get.offAll(const Homepage());

        return true;
      } on FirebaseAuthException catch (error) {
        print(error);
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('The password or email is incorrect'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
        return false;
      }
    } else {
      print('Not valid');
      return false;
    }
  }

  IconData icons() {
    if (isshowpassword == false) {
      return Icons.lock_open_outlined;
    } else {
      return Icons.lock_clock_outlined;
    }
  }

  @override
  Gotosingup() {
    Get.off(const SingUp());
  }

  @override
  onInit() {
    password = TextEditingController();
    email = TextEditingController();
    super.onInit();
  }

  @override
  dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
