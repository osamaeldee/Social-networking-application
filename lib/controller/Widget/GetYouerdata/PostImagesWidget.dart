import 'dart:convert';

import 'package:flutter/material.dart';

class PostImagesWidgetY extends StatelessWidget {
  final List<String> imageBytesList;

  const PostImagesWidgetY({Key? key, required this.imageBytesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageBytesList.isEmpty) {
      return const SizedBox.shrink();
    } else if (imageBytesList.length == 1) {
      return Image.memory(
        base64Decode(imageBytesList[0]),
        fit: BoxFit.cover,
      );
    } else if (imageBytesList.length <= 3) {
      return Column(
        children: imageBytesList.map((image) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.memory(
              base64Decode(image),
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.memory(
                    base64Decode(imageBytesList[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.memory(
                    base64Decode(imageBytesList[1]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                Image.memory(
                  base64Decode(imageBytesList[2]),
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black54.withOpacity(0.6),
                  child: Center(
                    child: Text(
                      '+${imageBytesList.length - 3}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
