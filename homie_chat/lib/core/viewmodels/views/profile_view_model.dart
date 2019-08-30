
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/message_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileModel extends BaseModel {
  final AuthenticationService _authenticationService;
  final MessageService _messageService;

  TextEditingController _displayNameController;
  Uint8List _image;

  TextEditingController get controller => _displayNameController;
  Uint8List get image => _image;

  ProfileModel({AuthenticationService authenticationService, MessageService messageService}) 
    : _authenticationService = authenticationService,
      _messageService = messageService;

  initialize({User user}) {
    setBusy(true);
    _displayNameController = TextEditingController(text: user.displayName);
    _image = user.image;
    setBusy(false);
  }

  Future<bool> updateUser({User user}) async {
    setBusy(true);

    user.displayName = _displayNameController.text;
    user.image = _image;
    var success = await _authenticationService.updateUser(user: user);

    setBusy(false);

    return success;
  }

  Future<bool> logout() async {
    setBusy(true);

    var result = await _messageService.closeSocket();
    var success = await _authenticationService.logout();

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