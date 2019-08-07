
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/services/message_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class ChatModel extends BaseModel {
  final MessageService _messageService;
  final GroupService _groupService;
  //Might not need AuthenticationService
  final AuthenticationService _authenticationService;

  ChatModel({
    MessageService messageService,
    GroupService groupService,
    AuthenticationService authenticationService
  }) :
    _messageService = messageService,
    _groupService = groupService,
    _authenticationService = authenticationService;

  List<Message> messages; 

}