import "package:flutter/material.dart";
import 'package:homies/scoped_models/login_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'base_view.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextEditingController, passwordTextEditingController;
  String email, password;

  final client = new http.Client();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailTextEditingController = TextEditingController(text: email);
    passwordTextEditingController = TextEditingController(text: password);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
        builder: (context, child, model) => Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white),
                    icon: Icon(Icons.email, color: Colors.white,),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))),
                  controller: emailTextEditingController,
                  cursorColor: Colors.white,
                  onChanged: (value) => this.email = value,
                ),
                SizedBox(height: 25.0),
                TextField(
                  decoration: InputDecoration(hintText: "Password", 
                    hintStyle: TextStyle(color: Colors.white),
                    icon: Icon(Icons.lock, color: Colors.white,),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: passwordTextEditingController,
                  onChanged: (value) => this.password = value,
                  obscureText: true,
                ),
                SizedBox(height: 35.0),
                FlatButton(
                  child: Text("LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ), onPressed: () {
                    print(email);
                    print(password);

                    this.emailTextEditingController.clear();
                    this.passwordTextEditingController.clear();

                    _login();
                  },
                )
              ],
            ),
          ),
        ),
        
      ),
    );
  }

  _updatePreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("LOGGED_IN", value);
  }

  _storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("TOKEN", token);

  }

  _login() async {
    var body = {
      "email": this.email,
      "password": this.password
    };

    var headers = {
      "content-type": "application/json",
      "accept": "application/json"
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator()
          ],
        );
      },
    );

    var url = "http://127.0.0.1:3000/auth/login";
    var response = await this.client.post(url, body: json.encode(body), headers: headers);

    Navigator.pop(context);

    print(response.body);

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print("SUCCESFUL LOGIN");

      _updatePreferences(true);
      _storeToken(body["token"]);

      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else {
      print("LOGIN NOT SUCCESFUL");

      _updatePreferences(false);
      //Present error handling

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Username or Password"),
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
    }
  }
}