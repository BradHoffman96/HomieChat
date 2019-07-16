
import 'dart:convert';

import 'package:homies/models/user.dart';
import 'package:homies/services/persistence_service.dart';
import 'package:homies/services/web_service.dart';

import '../service_locator.dart';

class UserService {
  final WebService _webService = locator<WebService>();
  final PersistenceService _persistenceService = locator<PersistenceService>();

  User _user;

  User get currentUser => _user;

  Future<bool> loginUser({String email, String password}) async {
    var loginResponse = await _webService.login(email: email, password: password);

    if (!loginResponse.hasError) {
      var result = json.decode(loginResponse.body);

      if (result != null && result['success']) {
        print(result['token']);

        //TODO: Save token to shared preferences here
        _persistenceService.storeKey("LOGGED_IN", true);
        _persistenceService.storeKey("TOKEN", result['token']);

        //TODO: Get user data next
      } else {
        _persistenceService.storeKey("LOGGED_IN", false);
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