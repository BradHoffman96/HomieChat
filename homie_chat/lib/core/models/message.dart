import 'dart:io';

class Message {
  String id;
  String senderId;
  String text;
  int timestamp;
  //int likes;
  //File image;

  Message({this.senderId, this.id, /*this.likes,*/ this.text, this.timestamp});

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['sender'];
    id = json['_id'];
    text = json['text'];
    timestamp = json['timestamp'];

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