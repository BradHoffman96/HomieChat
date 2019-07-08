import 'dart:io';

import "package:flutter/material.dart";
import "package:homies/services/profile.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileService = ProfileService();
  TextEditingController displayNameController, birthNameController;
  SharedPreferences prefs;
  File image;
  bool isEditing = false;

  final client = http.Client();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    displayNameController = new TextEditingController(text: profileService.displayName);
    birthNameController = new TextEditingController(text: profileService.birthName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              TextField(
                decoration: InputDecoration(hintText: "Display Name"),
                controller: displayNameController,
                onChanged: (value) => profileService.displayName = value,
              ),
              SizedBox(height: 25.0),
              TextField(
                decoration: InputDecoration(hintText: "Birth Name"),
                controller: birthNameController,
                onChanged: (value) => profileService.displayName = value,
              ),
              Container(
                child: MaterialButton(
                  color: Colors.red,
                  child: Text("Logout", style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    _logout();
                  },
                ),
              )
            ]
          ),
        ),
      ),
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString("TOKEN");
    
    var headers = {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": token
    };

    var url = "http://127.0.0.1:3000/auth/signout";
    var response = await this.client.get(url, headers: headers);

    if (response.statusCode != 200) {
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Cannot communicate with servers at this instance."),
            //content: Center(child: Text("Please try again.")),
            actions: <Widget>[
              FlatButton(
                child: Text("DONE"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    } else {
      prefs.setBool("LOGGED_IN", false);

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("/");
    }

    print(response.body);
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