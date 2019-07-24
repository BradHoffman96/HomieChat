

import 'dart:convert';
import 'dart:io';

import 'user.dart';

class Group {
  String id;
  //String owner;
  String name;
  String topic;
  List<User> members;
  File image;

  Group({this.id, this.name, this.topic, this.members});

  Group.fromJson(Map<String, dynamic> data) {
    print(data);

    id = data["_id"];
    name = data["name"];
    topic = data["topic"];
    members = List<User>();

    for (Map<String, dynamic> item in data['members']) {
      User user = User.fromJson(item);
      members.add(user);
    }
  }
}