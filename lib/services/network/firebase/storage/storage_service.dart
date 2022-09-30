import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "post_images";

  static Future<String> uploadImage(File image) async{
    String imageName = "image_${DateTime.now()}";
    var ref = _storage.child(folder).child(imageName);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }
}