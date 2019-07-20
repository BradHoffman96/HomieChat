
import 'package:homies/scoped_models/base_model.dart';
import 'package:homies/services/group_service.dart';

import '../service_locator.dart';

class GroupModel extends BaseModel {

  GroupService _groupService = locator<GroupService>();

  Future<bool> updateGroup() async {
    setState(ViewState.Busy);

    var result = await _groupService.updateGroupDetails();

    var updateState = result ? ViewState.Success : ViewState.Error;
    
    setState(updateState);

    return result;
  }

}