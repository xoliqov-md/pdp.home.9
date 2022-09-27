import 'package:database/services/local/shared/auth/auth_service.dart';
import 'package:database/services/network/firebase/database/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:database/models/DatabasePostUser.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{
  static List<Post> posts = [];
  bool internetConnect = false;

  @override
  void initState() {
    onAddValue();
    onChangeValue();
    _getPosts();
    load();
    super.initState();
  }

  void load(){
    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      setState(() {
        internetConnect = hasInternet;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        load();
      });
    }
  }

  void _getPosts() {
    Prefs.loadUserId().then((id) => {
          DatabaseService.getAllPosts(id!).then((value) => {
                setState(() {
                  posts = value!;
                })
              })
        });
  }

  void onChangeValue() async {
    FirebaseDatabase.instance
        .ref()
        .child("posts")
        .onChildChanged
        .listen((event) {
      final updatePost = event.snapshot.value as Map;
      for (var oldPost in posts) {
        if (oldPost.content.contains(updatePost['content'])) {
          setState(() {
            oldPost.title = updatePost['title'];
            oldPost.content = updatePost['content'];
            oldPost.userId = updatePost['userId'];
          });
        }
      }
    });
  }

  void onAddValue() async {
    FirebaseDatabase.instance.ref().child("posts").onChildAdded.listen((event) {
      final addItem = event.snapshot.value as Map;
      setState(() {
        posts.add(Post(
            title: addItem['title'],
            userId: addItem['userId'],
            content: addItem['content']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = internetConnect ? 'Posts' : 'Connecting...';
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posts[index].title,
                  style: const TextStyle(fontSize: 19),
                ),
                Text(
                  posts[index].content,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
    );
  }

  void reload() async {
    setState(() async {
      internetConnect = await InternetConnectionChecker().hasConnection;
    });
  }
}
