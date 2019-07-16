import "package:flutter/material.dart";
import 'package:homies/screens/home.dart';
import 'package:homies/screens/login.dart';
import 'package:homies/services/persistence_service.dart';

import '../service_locator.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  PersistenceService _persistenceService = locator<PersistenceService>();

  Future<bool> _checkPreferences() async {
    bool loggedIn = await _persistenceService.getKey("LOGGED_IN");

    if (loggedIn != null) {
      return loggedIn;
    } else {
      print("LOGGED_IN does not exist.");

      _persistenceService.storeKey("LOGGED_IN", false);
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