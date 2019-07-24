
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class GroupSettingsModel extends BaseModel {
  final GroupService _groupService;

  TextEditingController _nameController, _topicController;

  TextEditingController get nameController => _nameController;
  TextEditingController get topicController => _topicController;

  GroupSettingsModel({GroupService groupService}) : _groupService = groupService;

  initializeTextFields({Group group}) {
    setBusy(true);
    _nameController = TextEditingController(text: group.name);
    _topicController = TextEditingController(text: group.topic);
    setBusy(false);
  }

  Future<bool> updateGroup({Group group}) async {
    setBusy(true);

    group.name = _nameController.text;
    group.topic = _topicController.text;
    var success = await _groupService.updateGroup(group: group);

    setBusy(false);

    return success;
  }

  Future<bool> logout() {

    //TODO: logout User

  }
}