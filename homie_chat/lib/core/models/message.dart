import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class Message {
  String id;
  String senderId;
  String text;
  String timestamp;
  Uint8List image;
  //int likes;
  //File image;

  Message({this.senderId, this.id, /*this.likes,*/ this.text, this.timestamp});

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['sender'];
    id = json['_id'];
    text = json['text'];
    timestamp = json['timestamp'];

    //Might have to add a type variable for message to make this process a little easier
    if (json['image'] != null) {
      image = base64Decode(json['image']) ;
    }
  }
}