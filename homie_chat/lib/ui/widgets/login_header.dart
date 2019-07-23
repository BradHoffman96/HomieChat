import 'package:flutter/material.dart';
import 'package:homie_chat/ui/shared/ui_helpers.dart';

class LoginHeader extends StatelessWidget {
  final TextEditingController emailController, passwordController;
  
  LoginHeader({@required this.emailController, @required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column( children: <Widget>[
      _imageHeader(),
      UIHelper.verticalSpaceMedium,
      LoginTextField(emailController, "Login", false, Icons.email),
      UIHelper.verticalSpaceSmall,
      LoginTextField(passwordController, "Password", true, Icons.lock)
    ],
      
    );
  }
}

Widget _imageHeader() {
  return SizedBox(
    height: 200.0,
    child: Image.asset(
      "assets/homie_logo.png",
      fit: BoxFit.contain,
    ),
  );
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String type;
  final bool obscureText;
  final IconData icon;

  LoginTextField(this.controller, this.type, this.obscureText, this.icon);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      decoration: InputDecoration(hintText: type, 
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(icon, color: Colors.white,),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))),
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: controller,
      obscureText: obscureText,
    );
  }
}