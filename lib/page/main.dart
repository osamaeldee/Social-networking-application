import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth/Signup.dart';
import 'package:socialmedia/Auth_view/Signup.dart';
import 'package:socialmedia/home/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print(e);
  }
  Get.put(SinincontrollerImp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? isLoggedIn = FirebaseAuth.instance.currentUser;

    return GetMaterialApp(
      initialRoute: isLoggedIn != null ? '/home' : '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => const SingUp()),
        GetPage(name: '/home', page: () => const Homepage()),
      ],
    );
  }
}
