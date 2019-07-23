import 'package:flutter/material.dart';
import 'package:homie_chat/ui/shared/ui_helpers.dart';

class RegisterHeader extends StatelessWidget {
  final TextEditingController displayNameController, 
    emailController, 
    passwordController,
    passwordConfirmController;
  
  RegisterHeader({
    @required this.displayNameController,
    @required this.emailController, 
    @required this.passwordController,
    @required this.passwordConfirmController
  });

  @override
  Widget build(BuildContext context) {
    return Column( children: <Widget>[
      UIHelper.verticalSpaceSmall,
      RegisterTextField(displayNameController, "Display Name", false),
      UIHelper.verticalSpaceSmall,
      RegisterTextField(emailController, "Email", false),
      UIHelper.verticalSpaceSmall,
      RegisterTextField(passwordController, "Password", true),
      UIHelper.verticalSpaceSmall,
      RegisterTextField(passwordConfirmController, "Confirm Password", true),
    ],
    );
  }
}

class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String type;
  final bool obscureText;

  RegisterTextField(this.controller, this.type, this.obscureText);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      decoration: InputDecoration(hintText: type, 
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))),
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: controller,
      obscureText: obscureText,
    );
  }
}