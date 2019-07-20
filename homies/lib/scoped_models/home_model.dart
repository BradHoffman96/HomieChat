
import 'package:homies/services/group_service.dart';
import 'package:homies/services/user_service.dart';

import '../service_locator.dart';
import 'base_model.dart';

class HomeModel extends BaseModel {

  UserService _userService = locator<UserService>();
  GroupService _groupService = locator<GroupService>();

  Future<bool> getGroupDetails() async {
    setState(ViewState.Busy);

    var result = await _groupService.getGroupDetails();

    var getGroupState = result ? ViewState.Success : ViewState.Error;

    setState(getGroupState);
    
    return true;
  }

  Future<bool> getGroupImage() async {
    setState(ViewState.Busy);

    var result = await _groupService.getGroupImage();

    var getImageState = result ? ViewState.Success : ViewState.Error;

    setState(getImageState);
    
    return true;
  }

  Future<bool> getGroupMembers() async {
    setState(ViewState.Busy);

    var result = await _groupService.getGroupMembers();

    var getMembersState = result ? ViewState.Success : ViewState.Error;

    setState(getMembersState);
    
    return true;
  }

  Future<bool> getUserDetails() async {
    setState(ViewState.Busy);

    var result = await _userService.getUserImage();

    var loginState = result ? ViewState.Success : ViewState.Error;

    setState(loginState);
    
    return true;
  }

  Future<bool> getUserImage() async {
    setState(ViewState.Busy);

    var result = await _userService.getUserImage();

    var loginState = result ? ViewState.Success : ViewState.Error;

    setState(loginState);
    
    return true;
  }

}