import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeViewModel extends BaseModel {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  AuthenticationService _authenticationService;
  GroupService _groupService;
  WebSocketChannel _channel;
  String _groupId;

  HomeViewModel({
    @required AuthenticationService authenticationService,
    @required GroupService groupService
  }) 
    : _authenticationService = authenticationService,
      _groupService = groupService;

  Future<bool> getUser() async {
    setBusy(true);
    var success = await _authenticationService.getUser();
    print("GET USER: $success");
    setBusy(false);
    return success;
  }

  Future<dynamic> displayNotification(Map<String, dynamic> notification) {
    print(notification);
  }

  Future<bool> getGroupDetails(User _user) async {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(onMessage: displayNotification);
    setBusy(true);

    await connectToUpdateSocket();

    var success = false;
    if (_user != null) {
      _groupId = _user.groups[0];
      success = await _groupService.getGroup(groupId: _groupId);
      print("GET GROUP: $success");
    }

    setBusy(false);

    return success;
  }

  connectToUpdateSocket() async {
    _channel = IOWebSocketChannel.connect("ws://18.195.142.159:3000");
    _channel.stream.listen((message) => _receivedMessage(message));
  }

  Future<dynamic> closeSocket() async {
    return _channel.sink.close();
  }

  _receivedMessage(String payload) async {
    var message = json.decode(payload);

    if (message['type'] == "update") {
      setBusy(true);
      print("Updating data");
      await _groupService.getGroup(groupId: _groupId);
      setBusy(false);
    }
  }

}