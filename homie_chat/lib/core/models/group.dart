

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

  Group.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    topic = json["topic"];
    members = List<User>();
  }
}