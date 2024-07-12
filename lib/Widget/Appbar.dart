import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialmedia/posts/Addpost/Addpost.dart';
import 'package:socialmedia/posts/Show_your_post/Youer_Post.dart';
import 'package:socialmedia/screen/UserProfileSettingsPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('PostStream'),
        ],
      ),
      centerTitle: true,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('image/App_icons.png'),
        ),
      ),
      backgroundColor: Colors.blue,
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Get.off(const UserProfileSettingsPage());
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Get.off(Youer_Post());
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text('Add Post'),
                onTap: () {
                  Get.off(const PostPage());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
