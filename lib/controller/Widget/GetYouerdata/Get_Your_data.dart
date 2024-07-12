import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:socialmedia/Auth/Signup.dart';

class PostDataFetcherYouer {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    try {
      final SinincontrollerImp sinincontrollerImp =
          Get.find<SinincontrollerImp>();
      String? userId = sinincontrollerImp.getCurrentUserUID();

      if (userId != null) {
        DatabaseEvent snapshot =
            await _database.child('posts').child(userId).once();
        DataSnapshot dataSnapshot = snapshot.snapshot;

        Map<dynamic, dynamic>? data =
            dataSnapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          List<Map<String, dynamic>> fetchedPosts = [];

          data.forEach((postId, value) {
            if (value is Map<dynamic, dynamic>) {
              try {
                fetchedPosts.add({
                  'postId': postId,
                  'imageBytesList':
                      List<String>.from(value['image_bytes_list']),
                  'text': value['text'],
                  'email': value['email'],
                  'name': value['name'],
                  'timestamp': value['timestamp'],
                  'likes': value['likes'] ?? 0,
                  'comments': value['comments'] ?? [],
                });
              } catch (e) {
                print('Error parsing post data: $e');
              }
            }
          });

          fetchedPosts.shuffle();

          return fetchedPosts;
        } else {
          return [];
        }
      } else {
        print('Error: User ID is null');
        return [];
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
