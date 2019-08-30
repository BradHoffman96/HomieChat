

import 'dart:convert';
import 'dart:io';

import 'user.dart';

class Group {
  String id;
  //String owner;
  String name;
  String topic;
  Map<String, User> members;
  File image;


  Group({this.id, this.name, this.topic, this.members});

  Group.fromJson(Map<String, dynamic> data) {
    id = data["_id"];
    name = data["name"];
    topic = data["topic"];
    List<User> users = List<User>();

    for (Map<String, dynamic> item in data['members']) {
      User user = User.fromJson(item);
      users.add(user);
    }

    members = new Map.fromIterable(users,
      key: (item) => item.id,
      value: (item) => item,
    );
  }
}