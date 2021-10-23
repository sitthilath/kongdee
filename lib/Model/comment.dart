import 'package:firebase_database/firebase_database.dart';

class Comment{
  final String id;
  final String picture;
  final String message;
  final String datetime;
  final String commentID;

  Comment({this.id,this.picture,this.message,this.commentID,this.datetime});

  Comment.fromSnapshot(DataSnapshot snapshot):
   id = snapshot.key,
    picture = snapshot.value['picture'],
    message = snapshot.value['message'],
  datetime = snapshot.value['datetime'],
  commentID = snapshot.value['comment_id'];

  toJson(){
    return{
      "picture": picture,
      "message":message,
      "datetime":datetime,
      "comment_id":commentID,
    };
  }


}