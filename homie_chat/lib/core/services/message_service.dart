
import 'dart:async';
import 'dart:convert';

import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:homie_chat/core/models/message.dart';

class MessageService {
  //TODO: Initialize the sockets, subscribe to necessary events, and connect to the socket
  //TODO: Pipe the socket subscription callbacks to the Streams to update the 

  List<Message> _messages;
  SocketIO socketIO;

  MessageService();

  final StreamController<List<Message>> _messagesController = StreamController<List<Message>>();

  Stream<List<Message>> get messages => _messagesController.stream;

  Future<bool> connectToSocket() async {
    socketIO = SocketIOManager().createSocketIO("http://127.0.0.1:3000", "/chat", socketStatusCallback: _socketStatus);
    await socketIO.init();
    await socketIO.subscribe("get messsage", _getMessage);
    await socketIO.connect();

    var messages = List<Message>();
    _messagesController.add(messages);

    return true;
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  _getMessage(dynamic data) {
    print("Message Received: " + data);
    Message message = Message.fromJson(data);
    _messages.add(message);
    _messagesController.add(_messages);
  }

  Future<bool> sendMessage(String message) async {
    if (socketIO != null) {
      await socketIO.sendMessage("send message", json.encode(message), _getMessage);
      return true;
    } else {
      return false;
    }
  }

}