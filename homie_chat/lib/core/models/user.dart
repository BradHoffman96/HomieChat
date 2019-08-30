import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

class User {
  String id;
  String email;
  String displayName;
  List<String> groups;
  Uint8List image;

  User.initial()
    : id = '',
      email = '',
      displayName = '',
      groups = [];

  User({this.id, this.email, this.displayName, this.groups});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    email = json['email'];
    displayName = json['display_name'];
    groups = List<String>.from(json['groups'].cast<String>());
    image = image = base64Decode(json['image']);
  }
}