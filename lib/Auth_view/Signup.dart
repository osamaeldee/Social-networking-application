import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth_view/logen.dart';
import 'package:socialmedia/Widget/Pop.dart';
import 'package:socialmedia/Widget/costom_body.dart';
import 'package:socialmedia/Widget/costomboom.dart';
import 'package:socialmedia/Widget/custam_tital.dart';
import 'package:socialmedia/Widget/havw_in_acount.dart';
import 'package:socialmedia/Widget/logo.dart';
import 'package:socialmedia/Widget/textformfild.dart';
import 'package:socialmedia/Widget/vaild.dart';
import 'package:socialmedia/Auth/Signup.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFieldFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SinincontrollerImp controller = Get.put(SinincontrollerImp());
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
                _isPasswordFieldFocused
                    ? Image.asset(
                        'image/password.gif',
                        height: 210,
                      )
                    : const LogoAuth(
                        height: 210,
                      ),
                const custam_tital(
                  text: 'Welcome to LifeNetwork',
                ),
                const SizedBox(
                  height: 10,
                ),
                const custm_body(
                  text: "Create an account in the LifeNetwork",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text_form_failed(
                  isNumber: false,
                  vild: (val) {
                    return vaildinput(val!, 3, 10, 'name');
                  },
                  hintText: 'Enter Your name',
                  icon: Icons.person_outline,
                  text: 'name',
                  mycontroller: controller.name,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text_form_failed(
                  isNumber: false,
                  vild: (val) {
                    return vaildinput(val!, 8, 50, 'email');
                  },
                  hintText: 'Enter Your Email',
                  icon: Icons.email_outlined,
                  mycontroller: controller.email,
                  text: 'Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                GetBuilder<SinincontrollerImp>(
                  builder: (context) => Text_form_failed(
                    focusNode: _passwordFocusNode,
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
                  height: 30,
                ),
                CustomAuthButton(
                  onPressed: () {
                    controller.signup();
                  },
                  title: 'Sign Up',
                ),
                const SizedBox(
                  height: 5,
                ),
                Have_in_acount(
                  text: "You already have an account",
                  text2: 'Log In?',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Logen()),
                    );
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
