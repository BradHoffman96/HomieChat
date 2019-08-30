
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/message_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class ProfileModel extends BaseModel {
  final AuthenticationService _authenticationService;
  final MessageService _messageService;

  TextEditingController _displayNameController;

  TextEditingController get controller => _displayNameController;

  ProfileModel({AuthenticationService authenticationService, MessageService messageService}) 
    : _authenticationService = authenticationService,
      _messageService = messageService;

  initializeTextField({User user}) {
    setBusy(true);
    _displayNameController = TextEditingController(text: user.displayName);
    setBusy(false);
  }

  Future<bool> updateUser({User user}) async {
    setBusy(true);

    user.displayName = _displayNameController.text;
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
}