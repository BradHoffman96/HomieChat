
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/services/message_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';
import 'package:image_picker/image_picker.dart';

class InputViewModel extends BaseModel {
  MessageService _messageService;

  InputViewModel({
    MessageService messageService
  }) : _messageService = messageService;

  Future<bool> sendMessage(User user, String text) async {
    setBusy(true);

    var payload = {
      "sender": user.id,
      "text": text 
    };

    var result = await _messageService.sendMessage(json.encode(payload));

    setBusy(false);

    return result;
  }

  Future<void> sendImage({@required User user, @required bool fromCamera}) async {
    var imageFile = await ImagePicker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery, maxHeight: 600.0, maxWidth: 600.0);

    if (imageFile != null) {
      setBusy(true);

      var payload = {
        "sender": user.id,
        "image": base64Encode(imageFile.readAsBytesSync())
      };

      //TODO: Handle errors appropriately!
      var result = await _messageService.sendMessage(json.encode(payload));

      setBusy(false);
    }
  }
}