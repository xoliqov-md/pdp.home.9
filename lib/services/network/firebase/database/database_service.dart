import 'dart:convert';

import 'package:database/models/DatabasePostUser.dart';
import 'package:database/services/network/firebase/database/list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService with ChangeNotifier {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Post post) async {
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static List<Post> items = [];
  static Future<List<Post>?> getAllPosts(String id) async {
    Data.postsList = [];
    final query =
          _database.child("posts");
    await query.once().then((snapshot) {
        final v = snapshot.snapshot.children;
        for(var i in v){
          Map map = i.value as Map;
          items.add(Post(title: map['title'], userId: map['userId'], content: map['content']));
        }
    });
    Data.postsList = [];
    return items;
  }
}
