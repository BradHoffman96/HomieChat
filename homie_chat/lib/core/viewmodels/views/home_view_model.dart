import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends BaseModel {
  AuthenticationService _authenticationService;
  GroupService _groupService;

  HomeViewModel({
    @required AuthenticationService authenticationService,
    @required GroupService groupService
  }) 
    : _authenticationService = authenticationService,
      _groupService = groupService;

  Future<bool> getUser() async {
    setBusy(true);
    var success = await _authenticationService.getUser();
    print("GET USER: $success");
    setBusy(false);
    return success;
  }

  Future<bool> getGroupDetails(User _user) async {
    setBusy(true);

    var success = false;
    if (_user != null) {
      var groupId = _user.groups[0];
      success = await _groupService.getGroup(groupId: groupId);
      print("GET GROUP: $success");
    }

    setBusy(false);

    return success;
  }

  Future<bool> getGroupMembers(Group _group) async {
    setBusy(true);

    var success = false;
    if (_group != null) {
      print("_group is not null");
      success = await _groupService.getGroupMembers(group: _group);
      print("GET MEMBERS: $success");
    } else {
      print("_group is null");
    }

    setBusy(false);

    return success;
  }
}