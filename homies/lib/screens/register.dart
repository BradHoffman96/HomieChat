import 'package:flutter/material.dart';
import 'package:homies/scoped_models/register_view_model.dart';

import 'base_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _emailTextFieldController = new TextEditingController();
  TextEditingController _passwordTextFieldController = new TextEditingController();
  TextEditingController _confirmTextFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                  ),
                  controller: _emailTextFieldController,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                  ),
                  controller: _emailTextFieldController,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                  ),
                  controller: _emailTextFieldController,
                ),
              ],
            ),
          ),
        ),

      )
    );
  }
}