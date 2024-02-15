// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_firebase/components/my_drawer.dart';
import 'package:minimal_firebase/components/my_list_tile.dart';
import 'package:minimal_firebase/components/my_post_button.dart';
import 'package:minimal_firebase/components/my_textfield.dart';
import 'package:minimal_firebase/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // access the firestore
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    // only post the message if there is something in textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text(
          'W A L  L',
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // Text box to user to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: 'Say something...',
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
                // posts button
                MyPostButton(onTap: postMessage),
              ],
            ),
          ),

          // all posts
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                // show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // get all posts
                final posts = snapshot.data!.docs;

                // no data
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text('No posts... Post something'),
                    ),
                  );
                }

                // return as a list
                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      // get each individuaal post
                      final post = posts[index];

                      // get data from each post
                      String message = post['PostMessage'];
                      String useremail = post['Useremail'];
                      // Timestamp timestamp = post['Timestamp'];

                      // return as a list tile
                      return MyListTile(title: message, subTitle: useremail);
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
