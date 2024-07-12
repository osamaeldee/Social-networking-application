import 'package:flutter/material.dart';

class custam_tital extends StatelessWidget {
  final String text;
  const custam_tital({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Romanesco Font'),
    );
  }
}
