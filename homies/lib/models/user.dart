import 'dart:io';

class User {
  final String id;
  final String email;
  String displayName;
  List<String> groups;
  File image;

  //String profilePicPath;

  User({this.id, this.email, this.displayName, this.groups});

  factory User.fromJson(Map<String, dynamic> data) {
    User user = new User(
      id: data['_id'],
      email: data['email'],
      displayName: data['display_name'],
      groups: new List<String>.from(data['groups'].cast<String>()),
    );

    return user;
  }
}