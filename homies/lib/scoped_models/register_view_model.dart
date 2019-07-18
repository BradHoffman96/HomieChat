import 'dart:io';

import 'package:homies/services/user_service.dart';

import '../service_locator.dart';
import 'base_model.dart';

class RegisterModel extends BaseModel {
  UserService _userService = locator<UserService>();

  Future<bool> register({String email, String password, String displayName, File image}) async {
    setState(ViewState.Busy);

    var result = await _userService.registerUser(email: email, password: password, displayName: displayName, image: image);

    var loginState = result ? ViewState.Success : ViewState.Error;

    setState(loginState);
    
    return true;
  }
}