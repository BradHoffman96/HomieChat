

import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class MessagesModel extends BaseModel {
  // This is going to be difficult as our 'API' is probably going to be an actual APi
  // And a WebSocket...
  /*
  Api _api;

  PostsModel({
    @required Api api
  }) : _api = api;
  */

  MessagesModel();

  List<Message> messages; 

  /*
  Future getMessages() async {
    setBusy(true);
    messages = await _api.getMessages();
    setBusy(false;)
  }
  */
}