import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/views/home_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    final _group = Provider.of<Group>(context);

    return BaseWidget<HomeViewModel>(
      model: HomeViewModel(
        authenticationService: Provider.of(context),
        groupService: Provider.of(context)),
      onModelReady: (model) async {
        await model.getGroupDetails(_user);
        //await model.getGroupMembers(_group);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("HOMIE CHAT")),
        body: Column(
          children: <Widget>[
            model.busy
              ? Center(child: CircularProgressIndicator(),)
              : _mainPage(_user, _group)
          ]
        ),
      ),
    );
  }

  _mainPage(User user, Group group) {
    return Flexible(
      child: ListView(
        children: <Widget>[
          Text('${user.displayName}'),
          Text('${group.name}'),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (_, int index) => Text('${group.members[index].displayName}'),
            itemCount: group.members.length,
          )
        ],
      ),
    );
  }
}