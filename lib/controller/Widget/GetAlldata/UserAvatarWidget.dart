import 'dart:convert';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? imageUrl;

  const UserAvatarWidget({
    Key? key,
    this.name,
    this.email,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: imageUrl != null
            ? MemoryImage(base64Decode(imageUrl!))
            : const AssetImage('image/logo.jpg') as ImageProvider,
        radius: 20,
      ),
      title: Text(
        name ?? 'Anonymous',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        email ?? 'No email',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}
