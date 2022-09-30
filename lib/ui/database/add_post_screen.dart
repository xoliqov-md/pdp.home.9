import 'dart:io';

import 'package:database/models/DatabasePostUser.dart';
import 'package:database/services/network/firebase/database/database_service.dart';
import 'package:database/services/network/firebase/storage/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>{

  var user = FirebaseAuth.instance.currentUser;

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  final ImagePicker picker = ImagePicker();
  File? image;

  Future getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null) return;
    final imageTem = File(image.path);
    setState(() {
      this.image = imageTem;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    getImageFromGallery();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Center(
                      child: image != null ? Image.file(image!) : const Image(image: NetworkImage('https://getstamped.co.uk/wp-content/uploads/WebsiteAssets/Placeholder.jpg')),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
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
                    onPressed: () async{
                      showDialog(context: context, builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },);
                      await uploadImage();
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
  Future uploadImage() async{
    await StorageService.uploadImage(image!).then((value) => {
      DatabaseService.addPost(
          Post(
             title: title.text.trim(),
              userId: user!.uid,
              content: content.text.trim(),
              imgUrl: value
          )
      ),
      Navigator.pop(context)
    });
  }
}
