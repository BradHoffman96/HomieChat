import 'dart:convert';

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
  AuthenticationService _authenticationService;
  GroupService _groupService;
  WebSocketChannel _channel;

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

  Future<bool> getGroupDetails(User _user) async {
    setBusy(true);

    await connectToUpdateSocket();

    var success = false;
    if (_user != null) {
      var groupId = _user.groups[0];
      success = await _groupService.getGroup(groupId: groupId);
      print("GET GROUP: $success");
    }

    setBusy(false);

    return success;
  }

  connectToUpdateSocket() async {
    _channel = IOWebSocketChannel.connect("ws://localhost:3000");
    _channel.stream.listen((message) => _receivedMessage(message));
  }

  Future<dynamic> closeSocket() async {
    return _channel.sink.close();
  }

  _receivedMessage(String payload) {
    var message = json.decode(payload);

    if (message['type'] == "update") {
      setBusy(true);
      print("Updating data");
      setBusy(false);
    }
  }

}