import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmedia/Auth/logen.dart';
import 'package:socialmedia/Widget/Pop.dart';
import 'package:socialmedia/Widget/costom_body.dart';
import 'package:socialmedia/Widget/costomboom.dart';
import 'package:socialmedia/Widget/custam_tital.dart';
import 'package:socialmedia/Widget/logo.dart';
import 'package:socialmedia/Widget/textformfild.dart';
import 'package:socialmedia/Widget/vaild.dart';
import '../Widget/havw_in_acount.dart';

class Logen extends StatelessWidget {
  const Logen({super.key, Key});

  Future<void> sinup() async {
    lognincontrollerImp controller = Get.put(lognincontrollerImp());

    try {
      await controller.lognin();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    lognincontrollerImp controller = Get.put(lognincontrollerImp());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Sign up',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: WillPopScope(
        onWillPop: alertexitapp,
        child: Form(
          key: controller.formstat,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
            child: ListView(
              children: [
                const LogoAuth(
                  height: 160,
                ),
                const custam_tital(
                  text: 'Welcome Back',
                ),
                const SizedBox(
                  height: 10,
                ),
                const custm_body(
                  text:
                      "Sign In With Your Email, And Password OR Continue With Social Media.",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text_form_failed(
                  isNumber: false,
                  vild: (val) {
                    return vaildinput(val!, 8, 50, 'email');
                  },
                  hintText: 'Enter Your Email',
                  icon: Icons.email_outlined,
                  text: 'Email',
                  mycontroller: controller.email,
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<lognincontrollerImp>(
                  builder: (context) => Text_form_failed(
                    ontapicon: () {
                      controller.showpassword();
                    },
                    obscure: controller.isshowpassword,
                    isNumber: false,
                    vild: (val) {
                      return vaildinput(val!, 5, 20, 'password');
                    },
                    hintText: 'Enter your password',
                    icon: controller.icons(),
                    text: 'Enter your password',
                    mycontroller: controller.password,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomAuthButton(
                  onPressed: () async {
                    await controller
                        .lognin(); // استدعاء الدالة lognin() المعدلة
                  },
                  title: 'Sign In',
                ),
                const SizedBox(
                  height: 10,
                ),
                Have_in_acount(
                  text: "You don't have an account",
                  text2: 'Register?',
                  ontap: () {
                    controller
                        .Gotosingup(); // استدعاء الدالة Gotosingup() المعدلة
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
