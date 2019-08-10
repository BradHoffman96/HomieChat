
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/services/authentication_service.dart';
import 'package:homie_chat/core/services/group_service.dart';
import 'package:homie_chat/core/services/message_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class MessageViewModel extends BaseModel {
  MessageService _messageService;
  GroupService _groupService;
  //Might not need AuthenticationService
  AuthenticationService _authenticationService;

  MessageViewModel({
    MessageService messageService,
    GroupService groupService,
    AuthenticationService authenticationService
  }) {
    _messageService = messageService;
    _groupService = groupService;
    _authenticationService = authenticationService;

    _messageService.messages.listen(_onMessagesUpdated);
  }

  //TODO: I need to make this model listen to the message stream so that I can update on every new message
  List<Message> messages; 

  _onMessagesUpdated(List<Message> list) {
    setBusy(true);
    messages = list;
    setBusy(false);
  }

  Future<bool> connectToSocket() async {
    setBusy(true);

    print("connecting to socket");
    var result = await _messageService.connectToSocket();

    setBusy(false);

    return result;
  }

}