
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/storage_service.dart';
import 'package:http/http.dart' as http;

class Api {
  final StorageService _storage;

  Api({StorageService storage}) : _storage = storage;

  static const baseUrl = "http://127.0.0.1:3000";

  static const loginEndpoint = "auth/login";
  static const logoutEndpoint = "auth/logout";
  static const registerEndpoint = "auth/register";
  static const getUserEndpoint = "profile";
  static const updateUserEndpoint = "profile";

  static const getGroupEndpoint = "group";
  static const updateGroupEndpoint = "group";
  static const getMembersEndpoint = "members";

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

    _storage.storeKey("TOKEN", result['token']);

    return result['success'];
  }

  Future<bool> logoutUser() async {
    String token = await _storage.getKey("TOKEN");
    var headers = {
      'Authorization': token
    };
    
    headers.addAll(baseHeaders);

    var response = await client.get('$baseUrl/$logoutEndpoint', headers: headers);
    var result = json.decode(response.body);

    if (result['success']) {
      _storage.deleteKey("TOKEN");
    }

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

  Future<User> updateUserDetails({@required User user}) async {
    String token = await _storage.getKey("TOKEN");
    var headers = {
      'Authorization': token
    };

    headers.addAll(baseHeaders);

    var body = {
      'display_name': user.displayName
    };

    var response = await client.post('$baseUrl/$updateUserEndpoint', headers: headers, body: json.encode(body));

    return User.fromJson(json.decode(response.body)['newUser']);
  }

  Future<Group> getGroupDetails({@required String id}) async {
    String token = await _storage.getKey("TOKEN");
    var headers = {
      'Authorization': token
    };

    headers.addAll(baseHeaders);

    var response = await client.get('$baseUrl/$getGroupEndpoint/$id', headers: headers);

    var group = json.decode(response.body)['group'];

    return Group.fromJson(group);
  }

  Future<Group> updateGroupDetails({@required Group group}) async {
    String token = await _storage.getKey("TOKEN");
    var headers = {
      'Authorization': token
    };

    headers.addAll(baseHeaders);

    var body = {
      "name": group.name,
      "topic": group.topic
    };

    var response = await client.post('$baseUrl/$updateGroupEndpoint/${group.id}', headers: headers, body: json.encode(body));

    return Group.fromJson(json.decode(response.body)['newGroup']);
  }

  Future<List<User>> getGroupMembers({@required String id}) async {
    String token = await _storage.getKey("TOKEN");
    var headers = {
      'Authorization': token
    };

    headers.addAll(baseHeaders);

    var response = await client.get('$baseUrl/$getGroupEndpoint/$id/$getMembersEndpoint', headers: headers);
    var result = json.decode(response.body);

    print(result);

    if (result['success'] == false) {
      print(result);
      return null;
    }

    List<User> members = List<User>();
    for (var item in result['members']) {
      User user = User.fromJson(item);

      members.add(user);
    }

    return members;
  }
}