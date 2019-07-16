import "package:flutter/material.dart";
import 'package:homies/scoped_models/base_model.dart';
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
                _getFeedbackUI(model),
                SizedBox(height: 35.0),
                FlatButton(
                  child: Text("LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ), onPressed: () async {
                    print(email);
                    print(password);

                    var viewState = await model.login(email: email, password: password);
                    if (viewState) {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                    }

                    this.emailTextEditingController.clear();
                    this.passwordTextEditingController.clear();
                  },
                )
              ],
            ),
          ),
        ),
        
      ),
    );
  }



  Widget _getFeedbackUI(LoginModel model) {
    switch (model.state) {
      case ViewState.Busy:
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor
            ),
          )
        );
        break;
      case ViewState.Error:
        return Text("Could not login at this moment.");
      case ViewState.Success:
        return Center(child: Text('Login Success'));
      case ViewState.WaitingForInput:
      default:
        return Container();
    }
  }
}