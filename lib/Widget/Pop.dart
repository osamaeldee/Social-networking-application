import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

Future<bool> alertexitapp() {
  return Get.defaultDialog(
    title: "Attention!",
    titleStyle: const TextStyle(color: Colors.red, fontSize: 20),
    content: Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: const Text(
        "Do you want to exit the application already?",
        style: TextStyle(fontSize: 16),
      ),
    ),
    actions: [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
        ),
        onPressed: () {
          exit(0);
        },
        child: const Text(
          "Yes, I want to go out",
          style: TextStyle(fontSize: 16),
        ),
      ),
      TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(fontSize: 16),
        ),
      )
    ],
  ).then((value) => value ?? false);
}
