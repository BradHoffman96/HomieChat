import 'dart:io';

class User {
  String id;
  String email;
  String displayName;
  List<String> groups;
  File image;

  User.initial()
    : id = '',
      email = '',
      displayName = '',
      groups = [];

  User({this.id, this.email, this.displayName, this.groups});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    email = json['email'];
    displayName = json['displayName'];
    groups = List<String>.from(json['groups'].cast<String>());
  }
}