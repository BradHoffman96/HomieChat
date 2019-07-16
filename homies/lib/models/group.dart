import 'dart:io';

import 'package:scoped_model/scoped_model.dart';

class Group extends Model {
  String _name;
  String _topic;
  List<String> _members;
  File _group_image;

  Group(this._name, this._topic, this._members, this._group_image); 
}