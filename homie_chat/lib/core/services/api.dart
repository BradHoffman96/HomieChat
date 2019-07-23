
import 'dart:convert';

import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/storage.dart';
import 'package:http/http.dart' as http;

class Api {
  final Storage _storage;

  Api({Storage storage}) : _storage = storage;

  static const baseUrl = "http://127.0.0.1:3000";

  static const loginEndpoint = "auth/login";
  static const registerEndpoint = "auth/register";
  static const getUserEndpoint = "profile";

  var baseHeaders = {
    "content-type": "application/json",
    "accept": "application/json"
  };

  var client = new http.Client();

  Future<bool> registerUser({String email, String password, String displayName}) async {
    var body = {
      'email': email,
      'password': password,
      'display_name': displayName
    };

    var response = await client.post('$baseUrl/$registerEndpoint', headers: baseHeaders, body: json.encode(body));

    return json.decode(response.body)['success'];
  }

  Future<bool> loginUser({String email, String password}) async {
    var body = {
      'email': email,
      'password': password
    };
    
    print(body);

    var response = await client.post('$baseUrl/$loginEndpoint', headers: baseHeaders, body: json.encode(body));
    
    //TODO: store the token
    var result = json.decode(response.body);
    print(result);

    print(_storage);
    _storage.storeKey("TOKEN", result['token']);

    return result['success'];
  }

  Future<User> getUserDetails() async {
    String token = await _storage.getKey("TOKEN");
    var headers = {
      'Authorization': token
    };
    
    headers.addAll(baseHeaders);

    var response = await client.get('$baseUrl/$getUserEndpoint', headers: headers);

    return User.fromJson(json.decode(response.body)['user']);
  }
}