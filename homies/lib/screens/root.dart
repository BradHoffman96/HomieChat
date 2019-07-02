import "package:flutter/material.dart";
import 'package:homies/screens/home.dart';
import 'package:homies/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  SharedPreferences prefs;

  _checkPreferences() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("LOGGED_IN") != null) {
      return prefs.getBool("LOGGED_IN");
    } else {
      print("LOGGED_IN does not exist.");

      prefs.setBool("LOGGED_IN", false);
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkPreferences(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return CircularProgressIndicator();
            break;
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          case ConnectionState.active:
            return CircularProgressIndicator();
            break;
          case ConnectionState.done:
            // TODO: Handle this case.
            if (snapshot.hasData) {
              if (snapshot.data) {
                return HomePage();
              } else {
                return LoginPage();
              }
            }
        }
      }, 
    );
  }
}