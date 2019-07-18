import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homies/enums/view_state.dart';
import 'package:homies/models/user.dart';
import 'package:homies/scoped_models/register_view_model.dart';
import 'package:homies/services/user_service.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../service_locator.dart';
import 'base_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  UserService _userService = locator<UserService>();

  TextEditingController _displayNameController = new TextEditingController();
  TextEditingController _emailTextFieldController = new TextEditingController();
  TextEditingController _passwordTextFieldController = new TextEditingController();
  TextEditingController _confirmTextFieldController = new TextEditingController();

  File _image;
  bool _passwordVisible = false, _confirmVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return BaseView<RegisterModel>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          actions: <Widget>[
            FlatButton(
              child: Text("SUBMIT", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                print("Register User");
                //TODO: Check for Empty fields
                // Confirm Passwords

                var viewState = await model.register(
                  email: _emailTextFieldController.text,
                  password: _passwordTextFieldController.text,
                  displayName: _displayNameController.text,
                  image: _image);

                if (viewState) {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
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
                  child: GestureDetector(
                    onTap: () async {
                      _getImage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (_image != null) ? FileImage(_image) : AssetImage("assets/profile.png")
                    ),
                  )
                ),
                SizedBox(height: 30.0),
                _getFeedbackUI(model),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Display Name",
                  ),
                  controller: _displayNameController,
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                  ),
                  controller: _emailTextFieldController,
                ),
                SizedBox(height: 20.0,),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                  ),
                  obscureText: !_passwordVisible,
                  controller: _passwordTextFieldController,
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(_confirmVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        _confirmVisible = !_confirmVisible;
                      },
                    )
                  ),
                  obscureText: !_confirmVisible,
                  controller: _confirmTextFieldController,
                ),
              ],
            ),
          ),
        ),

      )
    );
  }

  Widget _getFeedbackUI(RegisterModel model) {
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