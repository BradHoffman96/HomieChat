import 'dart:io';

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../items/message.dart";
import "../items/image.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOMIE CHAT"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.settings),
            onSelected: (result) {
              print(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: "Profile",
                child: Text("Profile")
              ),
              const PopupMenuItem(
                value: "Settings",
                child: Text("Settings")
              )
            ]
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )
          ),
          new Divider(height: 1.0),
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }

  _handleSubmittedMessage(String text) {
    _textEditingController.clear();
    ChatMessage message = new ChatMessage(text: text, image: _image);
    setState(() {
      _messages.insert(0, message);
      _image = null;
    });
  }

  Widget _buildTextComposer() {
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
                onPressed: () async {
                  await getImage();
                  _handleSubmittedMessage("");
                },
              ),
            ),
            Flexible(
              child: TextField(
                controller: _textEditingController,
                minLines: 1,
                maxLines: 8,
                decoration: InputDecoration.collapsed(hintText: "Message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmittedMessage(_textEditingController.text),
              ),
            )
          ],
        )
      ),
    );
  }
}