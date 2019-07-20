import 'dart:io';

import 'package:homies/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class Group extends Model {
  final String id;
  final String owner;
  String name;
  String topic;
  List<User> members;
  File image;

  Group({this.id, this.name, this.topic, this.members, this.owner, this.image}); 

  factory Group.fromJson(Map<String, dynamic> data) {
    Group group = new Group(
      id: data['id'],
      owner: data['owner'],
      name: data['name'],
      topic: data['topic'],
      members: List<User>()
    );


    return group;
  }
}