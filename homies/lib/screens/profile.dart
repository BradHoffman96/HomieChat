import 'dart:io';

import "package:flutter/material.dart";
import "package:homies/services/profile.dart" as profileService;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences prefs;
  File image;

  _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          FlatButton(
            child: Text("Edit", style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                padding: EdgeInsets.all(2.0),
                decoration: new BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle
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
              )
            ],
          ),
        ),
      ),
    );
  }

  _getImage() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString("IMAGE_PROFILE_PATH") != null) {
      return CircleAvatar(
        backgroundImage: FileImage(File(prefs.getString("IMAGE_PROFILE_PATH")))
      );
    } else {
      return CircleAvatar(
        backgroundImage: ExactAssetImage("assets/profile.png"),
        backgroundColor: Colors.white,
      );
    }
  }
}