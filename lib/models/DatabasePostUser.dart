
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Post {

  String title;
  String userId;
  String content;

  Post({required this.title, required this.userId, required this.content});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['title'],
        title = json['userId'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'content': content};
}