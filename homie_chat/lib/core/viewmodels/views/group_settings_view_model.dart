
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:image_picker/image_picker.dart';

class GroupSettingsModel extends BaseModel {
  final GroupService _groupService;

  TextEditingController _nameController, _topicController;
  Uint8List _image;

  TextEditingController get nameController => _nameController;
  TextEditingController get topicController => _topicController;
  Uint8List get image => _image;

  GroupSettingsModel({GroupService groupService}) : _groupService = groupService;

  initializeTextFields({Group group}) {
    setBusy(true);
    _nameController = TextEditingController(text: group.name);
    _topicController = TextEditingController(text: group.topic);
    _image = group.image;
    setBusy(false);
  }

  Future<bool> updateGroup({Group group}) async {
    setBusy(true);

    group.name = _nameController.text;
    group.topic = _topicController.text;
    group.image = _image;
    var success = await _groupService.updateGroup(group: group);

    setBusy(false);

    return success;
  }

  Future<bool> getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 600.0, maxWidth: 600.0);

    if (image == null) {
      return false;
    }

    setBusy(true);
    _image = image.readAsBytesSync();
    setBusy(false);

    return true;
  }
}