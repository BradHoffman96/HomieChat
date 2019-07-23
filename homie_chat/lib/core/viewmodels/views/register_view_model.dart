
import 'package:flutter/material.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class RegisterViewModel extends BaseModel {
  AuthenticationService _authenticationService;

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
}