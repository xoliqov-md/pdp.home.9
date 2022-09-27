import 'package:database/models/DatabasePostUser.dart';
import 'package:database/services/network/firebase/database/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {

  var user = FirebaseAuth.instance.currentUser;

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: content,
                  decoration: const InputDecoration(
                      hintText: 'Content',
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 7,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      DatabaseService.addPost(
                          Post(
                              title: title.text.trim(),
                              userId: user!.uid,
                              content: content.text.trim()
                          )
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('post'),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}
