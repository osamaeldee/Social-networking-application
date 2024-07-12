import 'package:flutter/material.dart';

class LogoAuth extends StatelessWidget {
  const LogoAuth({
    super.key,
    required int height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      padding: const EdgeInsets.only(bottom: 50),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Container(
          child: Image.asset(
            "image/welcome.gif",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
