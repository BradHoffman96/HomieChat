import 'package:flutter/material.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/services/storage_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:homie_chat/ui/views/home_view.dart';

class RootViewModel extends BaseModel {
  StorageService _storageService;
  AuthenticationService _authenticationService;
  GroupService _groupService;

  bool hasUser;

  RootViewModel({
    @required StorageService storageService,
    @required AuthenticationService authenticationService,
    @required GroupService groupService
  }) : _authenticationService = authenticationService, _groupService = groupService, _storageService = storageService;

  Future<bool> checkLogin() async {
    setBusy(true);
    String token = await _storageService.getKey("TOKEN");
    print(token);

    var isLoggedIn = token != null;
    if (isLoggedIn) {
      hasUser = await _authenticationService.getUser();

      //TODO: potentially add the getGroup functions in here, but I want to try something first.
    }
    setBusy(false);

    return isLoggedIn;
  }
}