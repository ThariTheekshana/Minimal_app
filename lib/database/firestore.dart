/*
  This databse stores posts that user have published in the app.
  it is stored in a collection called 'Posts' in firebase

  Each post contains:
  - a message
  - email of user
  - timestamp
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts in firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  // post a messeage
  Future<void> addPost(String message) {
    return posts.add({
      'Useremail': user!.email,
      'PostMessage': message,
      'Timestamp': Timestamp.now(),
    });
  }

  // read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('Timestamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
