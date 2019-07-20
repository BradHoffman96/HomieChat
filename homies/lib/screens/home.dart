import 'dart:io';

import "package:flutter/material.dart";
import 'package:homies/scoped_models/home_model.dart';
import 'package:homies/service_locator.dart';
import 'package:homies/services/group_service.dart';
import 'package:homies/services/user_service.dart';
import "package:image_picker/image_picker.dart";

import 'package:homies/screens/profile.dart';
import 'package:homies/screens/settings.dart';
import 'package:scoped_model/scoped_model.dart';

import "../items/message.dart";
import "../items/image.dart";
import 'base_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = locator<UserService>();
  final GroupService _groupService = locator<GroupService>();
  final TextEditingController _textEditingController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  File _media;

  Future<bool> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return false;
    } else {
      setState(() {
        _media = image;
      });

      return true;
    }
  }

  Future<bool> getInitialData() async {
    var result = await _userService.getUser();
    result = await _userService.getUserImage();
    result = await _groupService.getGroupDetails();
    result = await _groupService.getGroupImage();
    result = await _groupService.getGroupMembers();

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      builder: (context, child, model) => _homeView(model)
          /*builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return CircularProgressIndicator();
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return _homeView(model);
                  }
                }

                return Container();
            }
          } */
    );
  }

  Widget _homeView(HomeModel model) {
    return Scaffold(
      appBar: AppBar(title: Text("HOMIE CHAT")),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('HOMIE CHAT'),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                print("Profile");
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              title: Text("Gallery"),
              onTap: () {
                print("Gallery");
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                print("Settings");
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            )
          ],
        )
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
    ChatMessage message = new ChatMessage(text: text, media: _media);
    setState(() {
      _messages.insert(0, message);
      _media = null;
    });
  }

  Future getImageFromGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 600.0, maxWidth: 600.0);

    if (imageFile != null) {
      setState(() {
        _media = imageFile;
      });
      return true;
    } else {
      return false;
    }

  }

  Future getImageFromCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 600.0, maxWidth: 600.0);

    if (imageFile != null) {
      setState(() {
        _media = imageFile;
      });
      return true;
    } else {
      return false;
    }

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
                onPressed: () {
                  showModalBottomSheet(context: context, builder: (BuildContext context) {
                    return new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ListTile(
                          leading: new Icon(Icons.camera_alt),
                          title: new Text('Camera'),
                          onTap: () async {
                            Navigator.pop(context);
                            var result = await getImageFromCamera();
                            if (result) {
                              _handleSubmittedMessage("");
                            }
                          }
                        ),
                        new ListTile(
                          leading: new Icon(Icons.photo_album),
                          title: new Text('Gallery'),
                          onTap: () async {
                            Navigator.pop(context);
                            var result = await getImageFromGallery();
                            if (result) {
                              _handleSubmittedMessage("");
                            }
                          }
                        ),
                      ],
                    );
                  });
                  /*var result = await getImage();
                  if (result == true) {
                    /_handleSubmittedMessage("");
                  }*/
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