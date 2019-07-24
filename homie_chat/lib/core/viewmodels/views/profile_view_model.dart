
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class ProfileModel extends BaseModel {
  final AuthenticationService _authenticationService;

  TextEditingController _displayNameController;

  TextEditingController get controller => _displayNameController;

  ProfileModel({AuthenticationService authenticationService}) : _authenticationService = authenticationService;

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

    var success = await _authenticationService.logout();

    setBusy(false);
    return success;
  }
}