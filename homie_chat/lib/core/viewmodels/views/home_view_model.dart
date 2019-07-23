import 'package:flutter/material.dart';
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

  Future<bool> getInitialData(BuildContext context) async {
    setBusy(true);
    Stream<User> stream = _authenticationService.user.take(1);

    var success = _authenticationService.getUser();

    User _user;
    await for (User user in stream) {
      print("GET INITIAL DATA");
      print(user.displayName);
      _user = user;
    }

    if (await success) {
      //print("USER DATA");
      //print("USER: $_user");
      var groupId = _user.groups[0];

      //List<User> users = await _authenticationService.user.toList();
      //print("USER: ${users[0]}");
      //var groupId = users[0].groups[0];

      success = _groupService.getGroup(groupId: groupId);
      success = _groupService.getGroupMembers(groupId: groupId);
    }
    setBusy(false);
    return await success;
  }
}