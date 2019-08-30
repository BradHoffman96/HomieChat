
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/services/api.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageService {
  Api _api;

  List<Message> _messages;
  WebSocketChannel _channel;

  MessageService({@required Api api}) {
    _api = api;
    _messages = List<Message>();
  }

  final StreamController<List<Message>> _messagesController = StreamController<List<Message>>.broadcast();

  Stream<List<Message>> get messages => _messagesController.stream;

  Future<bool> connectToSocket() async {
    _channel = IOWebSocketChannel.connect("ws://localhost:3000");

    _channel.stream.listen((message) => _receivedMessage(message));

    var messages = await _api.getMostRecentMessages();
    if (messages != null) {
      _messages = messages;
    }
    
    _messagesController.add(_messages);

    return true;
  }

  Future<dynamic> closeSocket() async {
    return _channel.sink.close();
  }

  Future<bool> sendMessage(String message) async {
    _channel.sink.add(message);
    return true;
  }

  _receivedMessage(String payload) {
    var result = json.decode(payload);

    if(result['type'] == 'message') {
      Message message = Message.fromJson(result['message']);
      _messages.insert(0, message);
      _messagesController.add(_messages);
    }
  }

}