import 'dart:io';

import "package:flutter/material.dart";
import 'package:homies/enums/view_state.dart';
import 'package:homies/scoped_models/profile_view_model.dart';
import "package:homies/services/profile.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'base_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileService = ProfileService();
  TextEditingController displayNameController;
  SharedPreferences prefs;
  File image;
  bool isEditing = false;

  final client = http.Client();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    displayNameController = new TextEditingController(text: profileService.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: <Widget>[
            FlatButton(
              child: this.isEditing ? Text("FINISH", style: TextStyle(color: Colors.white, fontSize: 16.0),)
                : Text("EDIT", style: TextStyle(color: Colors.white, fontSize: 16.0)),
              onPressed: () {
                setState(() {
                  if (this.isEditing) {
                    this.isEditing = false;
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
                    future: _getImage(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          // TODO: Handle this case.
                          return CircularProgressIndicator();
                          break;
                        case ConnectionState.waiting:
                          // TODO: Handle this case.
                          return CircularProgressIndicator();
                          break;
                        case ConnectionState.active:
                          // TODO: Handle this case.
                          return CircularProgressIndicator();
                          break;
                        case ConnectionState.done:
                          // TODO: Handle this case.
                          if (snapshot.hasData) {
                            return snapshot.data;
                          }
                          break;
                      }
                    },
                  ),
                ),
                SizedBox(height: 25.0),
                TextField(
                  decoration: InputDecoration(hintText: "Display Name"),
                  controller: displayNameController,
                  onChanged: (value) => profileService.displayName = value,
                ),
                SizedBox(height: 25.0),
                _getFeedbackUI(model),
                Container(
                  child: MaterialButton(
                    color: Colors.red,
                    child: Text("Logout", style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      var viewState = await model.logout();
                      if (viewState) {
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

  _getImage() async {
    prefs = await SharedPreferences.getInstance();

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
  }
}