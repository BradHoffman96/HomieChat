
import 'dart:convert';
import 'dart:io';

import 'package:homies/models/group.dart';
import 'package:homies/models/user.dart';
import 'package:homies/service_locator.dart';
import 'package:homies/services/persistence_service.dart';
import 'package:homies/services/user_service.dart';
import 'package:homies/services/web_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class GroupService {
  final UserService _userService = locator<UserService>();
  final WebService _webService = locator<WebService>();
  final PersistenceService _persistenceService = locator<PersistenceService>();

  Group _group;

  Group get currentGroup => _group;

  Future<bool> updateGroupDetails() async {
    var updateGroupResponse = await _webService.updateGroupDetails(groupId: _group.id, name: _group.name, topic: _group.topic, image: _group.image);

    if (!updateGroupResponse.hasError) {
      print(updateGroupResponse.body);
    } else {
      print("UPDATE PROFILE: ${updateGroupResponse.body}");
    }

    return !updateGroupResponse.hasError;
  }

  Future<bool> getGroupDetails() async {
    var getDetailsResponse = await _webService.getGroupDetails(_userService.currentUser.groups[0]);

    if (!getDetailsResponse.hasError) {
      var result = json.decode(getDetailsResponse.body);

      if (result['success']) {
        var groupDetails = Group.fromJson(result['group']);

        if (groupDetails != null) {
          _group = groupDetails;

          //TODO: Do I need to store the group information?
        }
      }

    } else {
      print("GET GROUP DETAILS");
      print(getDetailsResponse.body);
    }

    return !getDetailsResponse.hasError;
  }

  Future<bool> getGroupImage() async {
    var groupId = _userService.currentUser.groups[0];
    var getImageResponse = await _webService.getGroupImage(groupId);

    if (!getImageResponse.hasError) {
      Directory directory = await getApplicationDocumentsDirectory();

      var path = join(directory.toString(), "$groupId-image.png");

      File file = new File(path);

      if (file.existsSync()) {
        file.deleteSync();
      }

      file.writeAsBytesSync(getImageResponse.bodyBytes);
      _group.image = file;
    } else {
      print("GROUP IMAGE");
      print(getImageResponse.body);
    }

    return !getImageResponse.hasError;
  }

  Future<bool> getGroupMembers() async {
    var groupId = _userService.currentUser.groups[0];
    var getMembersResponse = await _webService.getGroupMembers(groupId);

    if (!getMembersResponse.hasError) {
      var result = json.decode(getMembersResponse.body);
      print(result);

      for (var item in result['users']) {
        User user = User.fromJson(item);

        _group.members.add(user);
      }
    } else {
      print("GROUP MEMBERS");
      print(getMembersResponse.body);
    }

    return !getMembersResponse.hasError;
  }
}