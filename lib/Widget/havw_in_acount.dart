import 'package:flutter/material.dart';

class Have_in_acount extends StatelessWidget {
  final String text;
  final String text2;
  final void Function()? ontap;

  const Have_in_acount({
    super.key,
    required this.text,
    required this.text2,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          const SizedBox(
            width: 3,
          ),
          InkWell(
            onTap: ontap,
            child: Text(
              text2,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
