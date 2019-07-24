import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homie_chat/core/constants/app_constants.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/viewmodels/widgets/menu_drawer_model.dart';
import 'package:homie_chat/ui/shared/app_colors.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseWidget<MenuDrawerModel>(
      model: MenuDrawerModel(groupService: Provider.of(context)),
      builder: (context, model, child) => Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  Text('${Provider.of<Group>(context).name}', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('${Provider.of<Group>(context).topic}')
                ],
              ),
              decoration: BoxDecoration(
                color: primaryColor
              ),
            ),
            _listTile(title: "Profile", path: RoutePaths.Profile, context: context),
            _listTile(title: "Gallery", path: RoutePaths.Gallery, context: context),
            _listTile(title: "Group Settings", path: RoutePaths.GroupSettings, context: context)
          ]
        ),
      ),
    );
  }

  _listTile({String title, String path, BuildContext context}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, path);
      },
    );
  }
}