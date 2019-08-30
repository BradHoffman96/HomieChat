import 'package:flutter/material.dart';
import 'package:homie_chat/core/constants/app_constants.dart';
import 'package:homie_chat/core/viewmodels/views/register_view_model.dart';
import 'package:homie_chat/ui/shared/app_colors.dart' ;
import 'package:homie_chat/ui/shared/ui_helpers.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:homie_chat/ui/widgets/register_header.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget<RegisterViewModel>(
      model: RegisterViewModel(authenticationService: Provider.of(context)),
      child: RegisterHeader(
        displayNameController: _displayNameController,
        emailController: _emailController,
        passwordController: _passwordController,
        passwordConfirmController: _passwordConfirmController,
      ),
      builder: (context, model, child) => Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Text("Register",),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                    onTap: () => model.getImage(),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (model.image != null) ? FileImage(model.image) : AssetImage("assets/profile.png")
                    ),
                  )
                ),
                UIHelper.verticalSpaceMedium,
                child,
                UIHelper.verticalSpaceMedium,
                model.busy
                  ? CircularProgressIndicator()
                  : Container(),
                FlatButton(
                  child: Text(
                    "REGISTER",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    var registerSuccess = await model.register(
                      displayName: _displayNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text
                    );

                    if (registerSuccess) {
                      Navigator.pushNamedAndRemoveUntil(context, RoutePaths.Root, (_) => false);
                    }
                  },
                )
              ],

            ),
          ),
        )
      ),
    );
  }
}