import 'dart:io';

import "package:flutter/material.dart";
import 'package:homies/enums/view_state.dart';
import 'package:homies/models/user.dart';
import 'package:homies/scoped_models/profile_view_model.dart';
import 'package:homies/service_locator.dart';
import 'package:homies/services/persistence_service.dart';
import 'package:homies/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'base_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserService _userService = locator<UserService>();
  PersistenceService _persistenceService = locator<PersistenceService>();
  
  TextEditingController displayNameController;
  String _tempDisplayName;
  File _tempImage;
  bool isEditing = false;

  final client = http.Client();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tempImage = _userService.currentUser.image;
    _tempDisplayName = _userService.currentUser.displayName;
    displayNameController = new TextEditingController(text: _tempDisplayName);
  }

  Future<String> _getToken() async {
    var token = await _persistenceService.getKey("TOKEN");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            isEditing ? FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),),
              onPressed: () {
                setState(() {
                  _tempDisplayName = _userService.currentUser.displayName;
                  _tempImage = _userService.currentUser.image;
                  isEditing = false;
                });
              },
            ) : Container(),
            FlatButton(
              child: this.isEditing ? Text("FINISH", style: TextStyle(color: Colors.white, fontSize: 16.0),)
                : Text("EDIT", style: TextStyle(color: Colors.white, fontSize: 16.0)),
              onPressed: () {
                setState(() {
                  if (this.isEditing) {
                    //TODO: commit changes to local and network
                    setState(() {
                      this.isEditing = false;

                      _userService.currentUser.image = _tempImage;
                      _userService.currentUser.displayName = _tempDisplayName;

                      _userService.updateProfile();
                    });

                  } else {
                    this.isEditing = true;
                  }
                });
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
                                  showMediaSlector();
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
                  decoration: InputDecoration(hintText: "Display Name"),
                  controller: displayNameController,
                  onChanged: (value) => _tempDisplayName = value,
                ),
                SizedBox(height: 25.0),
                _getFeedbackUI(model),
                Container(
                  child: MaterialButton(
                    color: Colors.red,
                    child: Text("Logout", style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      await model.logout();
                      if (model.state == ViewState.Success) {
                        print("Succesful logout");
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed("/");
                      }
                    },
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFeedbackUI(ProfileModel model) {
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

  showMediaSlector() {
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

  /*
  _getImage() async {

    if (File(prefs.getString("PROFILE_IMAGE_PATH")) != null) {
      return CircleAvatar(
        backgroundImage: FileImage(File(prefs.getString("PROFILE_IMAGE_PATH")), scale: 0.1),
        foregroundColor: this.isEditing ? Colors.white : Colors.transparent,
        child: this.isEditing ? Container(
          width: 200.0,
          height: 200.0,
          decoration: new BoxDecoration(
            color: Colors.white54,
            shape: BoxShape.circle,
          ), 
          child: FlatButton(
            //color: Colors.white54,
            child: Text("EDIT IMAGE", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0)),
            onPressed: () {
              ProfileService().storeImageFromGallery();
            }
       )) : Container(width: 0, height: 0),
      );
    } else {
      return CircleAvatar(
        backgroundImage: ExactAssetImage("assets/profile.png", scale: 0.1),
        backgroundColor: Colors.white,
        child: this.isEditing ? FlatButton(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle
            ),
            child: Text("Edit Image")),
          onPressed: () {
            ProfileService().storeImageFromGallery();
          },) : Container(width: 0, height: 0),
      );
    }
  }*/
}