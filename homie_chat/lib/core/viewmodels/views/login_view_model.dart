import 'package:flutter/material.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({
    @required AuthenticationService authenticationService
  }) : _authenticationService = authenticationService;

  Future<bool> login({@required email, @required password}) async {
    setBusy(true);
    var success = await _authenticationService.login(email: email, password: password);
    setBusy(false);
    return success;
  }
}