import 'package:firebase_database/firebase_database.dart';

class PostDataFetcher {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    try {
      DatabaseEvent snapshot = await _database.child('posts').once();
      DataSnapshot dataSnapshot = snapshot.snapshot;

      Map<dynamic, dynamic>? data =
          dataSnapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<String, dynamic>> fetchedPosts = [];
        data.forEach((userId, userPosts) {
          if (userPosts is Map<dynamic, dynamic>) {
            userPosts.forEach((postId, value) {
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
                    'profile_image': value['profile_image'], 
                  });
                } catch (e) {
                  print('Error parsing post data: $e');
                }
              }
            });
          }
        });
        fetchedPosts.shuffle();
        return fetchedPosts;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
