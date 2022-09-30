import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Post {
  String title;
  String userId;
  String content;
  String imgUrl;

  Post(
      {required this.title,
      required this.userId,
      required this.content,
      required this.imgUrl});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['title'],
        title = json['userId'],
        content = json['content'],
        imgUrl = json['imgUrl'];

  Map<String, dynamic> toJson() =>
      {'userId': userId, 'title': title, 'content': content,'imgUrl':imgUrl};
}
