import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/views/home_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      model: HomeViewModel(
        authenticationService: Provider.of(context),
        groupService: Provider.of(context)),
      onModelReady: (model) => model.getInitialData(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("HOMIE CHAT")),
        //TODO: break drawer into widget
        /*endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('HOMIE CHAT'),
                decoration: BoxDecoration(
                  color: Colors.blue
                ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  print("Profile");
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              ListTile(
                title: Text("Gallery"),
                onTap: () {
                  print("Gallery");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Settings"),
                onTap: () {
                  print("Settings");
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              )
            ],
          )
        ),*/
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('${Provider.of<User>(context).email}'),
            Text('${Provider.of<Group>(context).name}'),
            ListView.builder(
              itemBuilder: (_, int index) => Text('${Provider.of<Group>(context).members[index]}'),
              itemCount: Provider.of<Group>(context).members.length,
            )
          ],
        ),

        //TODO: Replace body
        /*body: Column(
          children: <Widget>[
            //TODO: break MessageView into its own Widget
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )
            ),
            new Divider(height: 1.0),
            //TODO: break text composer into it's own widget?
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            )
          ],
        ),*/
      ),
    );
  }
}