import 'package:homies/services/user_service.dart';

import '../service_locator.dart';
import 'base_model.dart';

class LoginModel extends BaseModel {
  UserService _userService = locator<UserService>();

  Future<bool> login({String email, String password}) async {
    setState(ViewState.Busy);

    var result = await _userService.loginUser(email: email, password: password);

    if (result) {
      print("GET USER AND IMAGE");
      result = await _userService.getUser();
      result = await _userService.getUserImage();
    }

    var loginState = result ? ViewState.Success : ViewState.Error;

    setState(loginState);
    
    return true;
  }


}