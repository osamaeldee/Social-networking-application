// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAh06Uo5WCD0sS3XwQ6GJALkpB7hAw1hoI',
    appId: '1:384618929145:android:fc08ba2f2990659962bb28',
    messagingSenderId: '384618929145',
    databaseURL: "https://social-media-94f1f-default-rtdb.firebaseio.com/",
    projectId: 'social-media-94f1f',
    storageBucket: 'social-media-94f1f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZDJe5ZM-COyJqBT4uC9rT_e55v8PmXtY',
    appId: '1:384618929145:ios:b6440d73a546677762bb28',
    messagingSenderId: '384618929145',
    projectId: 'social-media-94f1f',
    storageBucket: 'social-media-94f1f.appspot.com',
    iosBundleId: 'com.example.socialmedia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZDJe5ZM-COyJqBT4uC9rT_e55v8PmXtY',
    appId: '1:384618929145:ios:b6440d73a546677762bb28',
    messagingSenderId: '384618929145',
    projectId: 'social-media-94f1f',
    storageBucket: 'social-media-94f1f.appspot.com',
    iosBundleId: 'com.example.socialmedia',
  );
}
