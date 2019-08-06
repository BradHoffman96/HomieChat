
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/services/socket_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class ChatModel extends BaseModel {
  final SocketService _socketService;
  final GroupService _groupService;
  //Might not need AuthenticationService
  final AuthenticationService _authenticationService;

  ChatModel({
    SocketService socketService,
    GroupService groupService,
    AuthenticationService authenticationService
  }) :
    _socketService = socketService,
    _groupService = groupService,
    _authenticationService = authenticationService;

  List<Message> messages; 

}