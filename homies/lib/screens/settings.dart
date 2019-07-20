import 'dart:io';

import "package:flutter/material.dart";
import 'package:homies/scoped_models/base_model.dart';
import 'package:homies/scoped_models/group_model.dart';
import 'package:homies/service_locator.dart';
import 'package:homies/services/group_service.dart';
import 'package:homies/services/persistence_service.dart';
import 'package:image_picker/image_picker.dart';

import 'base_view.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GroupService _groupService = locator<GroupService>();
  PersistenceService _persistenceService = locator<PersistenceService>();
  TextEditingController _tempNameController, _tempTopicController;

  File _tempImage;
  String _tempName;
  String _tempTopic;
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tempName = _groupService.currentGroup.name;
    _tempTopic = _groupService.currentGroup.topic;
    _tempImage = _groupService.currentGroup.image;

    _tempNameController = new TextEditingController(text: _tempName);
    _tempTopicController = new TextEditingController(text: _tempTopic);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GroupModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text("Group Settings"),
          actions: <Widget>[
            isEditing ? FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),),
              onPressed: () {
                setState(() {
                  _tempName = _groupService.currentGroup.name;
                  _tempTopic = _groupService.currentGroup.topic;
                  _tempImage = _groupService.currentGroup.image;
                  isEditing = false;
                });
              },
            ) : Container(),
            FlatButton(
              child: this.isEditing ? Text("FINISH", style: TextStyle(color: Colors.white, fontSize: 16.0),)
                : Text("EDIT", style: TextStyle(color: Colors.white, fontSize: 16.0)),
              onPressed: () async {
                if (this.isEditing) {
                  _groupService.currentGroup.name = _tempName;
                  _groupService.currentGroup.topic = _tempTopic;
                  _groupService.currentGroup.image = _tempImage;

                  await model.updateGroup();

                  if (model.state == ViewState.Success) {
                    setState(() => this.isEditing = false);
                  }
                } else {
                  setState(() => this.isEditing = true);
                }
              },
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(2.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(spreadRadius: .1,
                        blurRadius: 5.0,
                        offset: Offset(2.0, 2.0))
                    ]
                  ),
                  child: FutureBuilder(
                    future: _getToken(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          // TODO: Handle this case.
                          return CircularProgressIndicator();
                          break;
                        case ConnectionState.done:
                          // TODO: Handle this case.
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              /*backgroundImage: NetworkImage("http://127.0.0.1:3000/profile/image", headers: {
                                                    'Authorization': snapshot.data
                                                  }),*/
                              backgroundImage: FileImage(_tempImage),
                              backgroundColor: Colors.white,
                              child: this.isEditing ? GestureDetector(
                                child: Container(
                                  height: 200.0,
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white54,
                                    shape: BoxShape.circle
                                  ),
                                  child: Center(
                                    child: Text(
                                      "EDIT IMAGE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black),
                                    ),
                                  )                            
                                ),
                                onTap: () async {
                                  showMediaSelector();
                                },
                              ) : Container(width: 0, height: 0),
                            );
                          }
                          break;
                      }
                    },
                  )
                ),
                SizedBox(height: 25.0),
                TextField(
                  enabled: isEditing,
                  decoration: InputDecoration(hintText: "Group Name"),
                  controller: _tempNameController,
                  onChanged: (value) => _tempName = value,
                ),
                SizedBox(height: 25.0),
                TextField(
                  enabled: isEditing,
                  decoration: InputDecoration(hintText: "Display Name"),
                  controller: _tempTopicController,
                  onChanged: (value) => _tempTopic = value,
                ),
                SizedBox(height: 25.0),
                _getFeedbackUI(model),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _getToken() async {
    var token = await _persistenceService.getKey("TOKEN");
    return token;
  }

  Widget _getFeedbackUI(GroupModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor)),
        );
        break;
      case ViewState.Error:
        return Text('Could not log in at this moment');
      case ViewState.Success:
        return Center(child: Text('Login Success'));
      case ViewState.WaitingForInput:
      default:
        return Container();
    }
  }

  showMediaSelector() {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.camera_alt),
            title: new Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              await getImageFromCamera();
            }
          ),
          new ListTile(
            leading: new Icon(Icons.photo_album),
            title: new Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await getImageFromGallery();
            }
          ),
        ],
      );
    });
  }

  Future getImageFromGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 600.0, maxWidth: 600.0);

    if (imageFile != null) {
      setState(() {
        _tempImage = imageFile;
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
        _tempImage = imageFile;
      });
      return true;
    } else {
      return false;
    }

  }

}