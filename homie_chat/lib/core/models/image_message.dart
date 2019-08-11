//This is identical to a message, but it makes understanding a little more straightforward with the gallery
import 'dart:convert';
import 'dart:typed_data';

class ImageMessage {
  String id;
  String senderId;
  String timestamp;
  Uint8List image;
  //int likes;
  //File image;

  ImageMessage({this.senderId, this.id, /*this.likes,*/ this.timestamp});

  ImageMessage.fromJson(Map<String, dynamic> json) {
    senderId = json['sender'];
    id = json['_id'];
    timestamp = json['timestamp'];

    //Might have to add a type variable for message to make this process a little easier
    if (json['image'] != null) {
      image = base64Decode(json['data']) ;
    }
  }

}