import 'package:homies/services/user_service.dart';

import '../service_locator.dart';
import 'base_model.dart';

class ProfileModel extends BaseModel {
  UserService _userService = locator<UserService>();

  Future<bool> logout() async {
    setState(ViewState.Busy);

    var result = await _userService.logoutUser();

    var logoutState = result ? ViewState.Success : ViewState.Error;

    setState(logoutState);
    
    return true;
  }

}