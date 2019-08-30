import 'package:flutter/material.dart';
import 'package:homie_chat/core/constants/app_constants.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/views/profile_view_model.dart';
import 'package:homie_chat/ui/shared/ui_helpers.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);

    return BaseWidget<ProfileModel>(
      model: ProfileModel(
        authenticationService: Provider.of(context),
        messageService: Provider.of(context)),
      onModelReady: (model) => model.initializeTextField(user: _user),
      builder: (context, model, child) => Scaffold(
        appBar: _appBar(model: model, user: _user),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                _displayNameTextField(model: model),
                UIHelper.verticalSpaceMedium,
                _logoutButton(model: model, context: context)
              ],
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _appBar({ProfileModel model, User user}) {
    return AppBar(
      title: Text("Profile"),
      actions: <Widget>[
        isEditing ? FlatButton(
          child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),),
          onPressed: () {
            setState(() {
              isEditing = false;
              model.initializeTextField(user: user);
            });
          },
        ) : Container(),
        FlatButton(
          child: this.isEditing ? Text("FINISH", style: TextStyle(color: Colors.white, fontSize: 16.0),)
            : Text("EDIT", style: TextStyle(color: Colors.white, fontSize: 16.0)),
          onPressed: () async {
            if (this.isEditing) {
              await model.updateUser(user: user);

              //This might redraw the widget twice, since setBusy() calls notifyListeners()
              setState(() {
                this.isEditing = false;
              });
            } else {
              setState(() {
                this.isEditing = true;
              });
            }
          },
        )
      ],
    );
  }

  Widget _displayNameTextField({ProfileModel model}) {
    return TextField(
      enabled: isEditing,
      decoration: InputDecoration(hintText: "Display Name"),
      controller: model.controller,
    );
  }

  Widget _logoutButton({ProfileModel model, BuildContext context}) {
    return MaterialButton(
      color: Colors.red,
      child: Text("Logout", style: TextStyle(color: Colors.white),),
      onPressed: () async {
        var success = await model.logout();
        if (success) {
          Navigator.pushNamedAndRemoveUntil(context, RoutePaths.Root, (_) => false);
        } else {
          //TODO: Display logout error
        }
      },
    );
  }
}