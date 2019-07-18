
import 'dart:convert';
import 'dart:io';

import 'package:homies/models/user.dart';
import 'package:homies/services/persistence_service.dart';
import 'package:homies/services/web_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../service_locator.dart';

class UserService {
  final WebService _webService = locator<WebService>();
  final PersistenceService _persistenceService = locator<PersistenceService>();

  User _user;

  User get currentUser => _user;

  Future<bool> registerUser({String email, String password, String displayName, File image}) async {
    var loginResponse = await _webService.register(
      email: email, 
      password: password,
      displayName: displayName,
      image: image);

    if (!loginResponse.hasError) {
      var result = json.decode(loginResponse.body);

      if (result != null && result['success']) {
        print("SUCCESS");

        //TODO: Save token to shared preferences here
        //_persistenceService.storeKey("LOGGED_IN", true);
        //_persistenceService.storeKey("TOKEN", result['token']);

        //TODO: Get user data next
      } else {
        //_persistenceService.storeKey("LOGGED_IN", false);
        print("No SUCCESS");
      }
    }

    return !loginResponse.hasError;
  }

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

  Future<bool> logoutUser() async {
    var logoutResponse = await _webService.logout();

    if (!logoutResponse.hasError) {
      var result = json.decode(logoutResponse.body);
      print(result);

      if (result != null && result['success']) {
        _persistenceService.storeKey("LOGGED_IN", false);
        _persistenceService.deleteKey("TOKEN");
        _persistenceService.deleteKey("USER");
      }
    } else {
      print(logoutResponse.body);
    }

    return !logoutResponse.hasError;
  }

  Future<bool> getUser() async {
    var getUserResponse = await _webService.getUser();

    if (!getUserResponse.hasError) {
      var result = json.decode(getUserResponse.body);
      print(result);

      if (result != null && result['success']) {
        var userFromLogin = User.fromJson(result['user']);
        
        if (userFromLogin != null) {
          _user = userFromLogin;

          _persistenceService.storeKey("USER", userFromLogin);
        }
      }
    } else {
      print(getUserResponse.body);
    }

    return !getUserResponse.hasError;
  }

  /*Future<bool> getImageFromGallery() async {

    if (image == null) return false;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String path = appDocDir.path;
    final File profileImage = await image.copy('$path/profile.png');

    _persistenceService.storeKey("PROFILE_IMAGE_PATH", profileImage.path);

    return true;
  }*/

  Future<bool> checkForUser() async {
    //TODO: check for user in persistence service
    //if null, return false, else, return true

    return true;
  }
}