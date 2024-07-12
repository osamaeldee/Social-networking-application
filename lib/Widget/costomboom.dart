import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;

  const CustomAuthButton(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // ignore: sort_child_properties_last
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
