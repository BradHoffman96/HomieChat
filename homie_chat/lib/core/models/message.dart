import 'dart:io';

class Message {
  String userId;
  String id;
  String text;
  //int likes;
  File image;

  Message({this.userId, this.id, /*this.likes,*/ this.text});

  Message.fromJson(Map<String, dynamic> json) {
    userId = json['owner'];
    id = json['_id'];
    text = json['text'];

    //Need to build a getImage() function for the messages
    //image = getImageFromServer()
  }

  // Instead of having a toJson(), I think I am going to just send the message (or image) over
  // And let the server handle the creation, then return me a message.
  // That'll help with ordering of messages too.

  /*
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['owner'] = this.user
  }
  */
}