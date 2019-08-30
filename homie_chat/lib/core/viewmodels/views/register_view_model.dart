
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:image_picker/image_picker.dart';

class RegisterViewModel extends BaseModel {
  AuthenticationService _authenticationService;
  File _image;

  File get image => _image;

  RegisterViewModel({
    @required AuthenticationService authenticationService
  }) : _authenticationService = authenticationService;

  Future<bool> register({
    @required displayName,
    @required email,
    @required password
  }) async {
    setBusy(true);
    var success = await _authenticationService.register(displayName: displayName, email: email, password: password);
    setBusy(false);
    return success;
  }

  Future<bool> getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 600.0, maxWidth: 600.0);

    if (image == null) {
      return false;
    }

    setBusy(true);
    _image = image;
    setBusy(false);

    return true;
  }
}