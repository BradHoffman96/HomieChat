import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/widgets/input_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class InputView extends StatefulWidget {
  final User user;

  InputView({@required this.user});

  @override
  _InputViewState createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<InputViewModel>(
      model: InputViewModel(messageService: Provider.of(context)),
      builder: (context, model, child) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        child: _textComposer(context, model),
      ),
    );
  }

  Widget _textComposer(BuildContext context, InputViewModel model) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () => _showMediaSelectionSheet(context, model),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 8,
                decoration: InputDecoration.collapsed(hintText: "Message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  model.sendMessage(widget.user, _textController.text);
                  _textController.clear();
                }
              ),
            )
          ],
        )
      ),
    );
  }

  _showMediaSelectionSheet(BuildContext context, InputViewModel model) {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.camera_alt),
            title: new Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              print("Camera");
              model.sendImage(user: widget.user, fromCamera: true);
            }
          ),
          new ListTile(
            leading: new Icon(Icons.photo_album),
            title: new Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              print("Gallery");
              model.sendImage(user: widget.user, fromCamera: false);
            }
          ),
        ],
      );
    });
  }
}