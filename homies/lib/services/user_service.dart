
import 'dart:convert';

import 'package:homies/models/user.dart';
import 'package:homies/services/web_service.dart';

import '../service_locator.dart';

class UserService {
  final WebService _webService = locator<WebService>();

  User _user;

  User get currentUser => _user;

  Future<bool> loginUser({String email, String password}) async {
    var loginResponse = await _webService.login(email: email, password: password);

    if (!loginResponse.hasError) {
      var userFromLogin = User.fromJson(json.decode(loginResponse.body));

      if (userFromLogin != null) {
        _user = userFromLogin;
      }
    }

    return !loginResponse.hasError;
  }

  Future<bool> checkForUser() async {
    //TODO: check for user in persistence service
    //if null, return false, else, return true

    return true;
  }
}