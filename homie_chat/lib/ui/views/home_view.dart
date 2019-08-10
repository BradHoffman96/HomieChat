import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/views/home_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:homie_chat/ui/widgets/input_view.dart';
import 'package:homie_chat/ui/widgets/menu_drawer.dart';
import 'package:homie_chat/ui/widgets/message_view.dart';
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
        appBar: AppBar(title: Text(model.busy ? "HOMIE CHAT" : _group.name)),
        endDrawer: MenuDrawer(),
        body: Column(
          children: <Widget>[
            model.busy
              ? Center(child: CircularProgressIndicator(),)
              : _mainPage()
          ]
        ),
      ),
    );
  }

  _mainPage() {
    return Flexible(
      child: ListView(
        children: <Widget>[
          MessageView(),
          InputView()
        ],
      ),
    );
  }
}