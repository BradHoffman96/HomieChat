
import 'dart:async';
import 'dart:convert';

import 'package:homie_chat/core/models/message.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageService {
  //TODO: Initialize the sockets, subscribe to necessary events, and connect to the socket
  //TODO: Pipe the socket subscription callbacks to the Streams to update the 

  List<Message> _messages;
  WebSocketChannel _channel;

  MessageService() {
    _messages = List<Message>();
  }

  final StreamController<List<Message>> _messagesController = StreamController<List<Message>>();

  Stream<List<Message>> get messages => _messagesController.stream;

  Future<bool> connectToSocket() async {
    _channel = IOWebSocketChannel.connect("ws://localhost:3000");

    _channel.stream.listen((message) => _receivedMessage(message));

    _messagesController.add(_messages);

    return true;
  }

  Future<bool> sendMessage(String message) async {
    //TODO: Needs to be rewritten for WebSockets

    _channel.sink.add(message);
    return true;
  }

  _receivedMessage(String payload) {
    Message message = Message.fromJson(json.decode(payload));

    print(message.timestamp);

    _messages.add(message);
    _messagesController.add(_messages);
  }

}