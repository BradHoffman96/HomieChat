
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/services/authentication_service.dart';

import 'api.dart';

class GroupService {
  final Api _api;

  GroupService({Api api}) 
    : _api = api;

  StreamController<Group> _groupController = StreamController<Group>.broadcast();

  Stream<Group> get group => _groupController.stream;

  Future<bool> getGroup({@required groupId}) async {
    var groupDetails = await _api.getGroupDetails(id: groupId);

    var hasGroup = groupDetails != null;
    if (hasGroup) {
      _groupController.add(groupDetails);
    }

    return hasGroup;
  }

  Future<bool> getGroupMembers({@required Group group}) async {
    print("getGroupMembers() called");
    var groupMembers = await _api.getGroupMembers(id: group.id);

    print("GROUP MEMBERS");
    print(groupMembers);

    var hasMembers = groupMembers != null;
    if (hasMembers) {
      group.members = groupMembers;
      _groupController.add(group);
    }

    return hasMembers;
  }
}