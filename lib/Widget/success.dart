import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth_view/logen.dart';

import 'costomboom.dart';

class SuccessSignup extends StatelessWidget {
  const SuccessSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Success',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle_outline,
              size: 300,
              color: Colors.green,
            ),
          ),
          const Text(
            'The account was created successfully',
            style: TextStyle(
                color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomAuthButton(
              onPressed: () {
                Get.offAll(const Logen());
              },
              title: 'Log in!',
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
