import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final client = http.Client();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                child: MaterialButton(
                  color: Colors.red,
                  child: Text("Logout", style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    _logout();
                  },
                ),
              )]
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
}