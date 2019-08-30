import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/viewmodels/views/group_settings_view_model.dart';
import 'package:homie_chat/ui/shared/ui_helpers.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class GroupSettingsView extends StatefulWidget {
  @override
  _GroupSettingsViewState createState() => _GroupSettingsViewState();
}

class _GroupSettingsViewState extends State<GroupSettingsView> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final _group = Provider.of<Group>(context);

    return BaseWidget<GroupSettingsModel>(
      model: GroupSettingsModel(groupService: Provider.of(context)),
      onModelReady: (model) => model.initializeTextFields(group: _group),
      builder: (context, model, child) => Scaffold(
        appBar: _appBar(model: model, group: _group),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
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
                    onTap: () {
                      if (isEditing) {
                        model.getImage();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (model.image != null) ? MemoryImage(model.image) : AssetImage("assets/profile.png")
                    ),
                  )
                ),
                UIHelper.verticalSpaceMedium,
                _nameTextField(model: model),
                UIHelper.verticalSpaceMedium,
                _topicTextField(model: model)
              ],
            ),
          ),
        ),
      ),
      
    );
  }

  Widget _appBar({GroupSettingsModel model, Group group}) {
    return AppBar(
      title: Text("Profile"),
      actions: <Widget>[
        isEditing ? FlatButton(
          child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),),
          onPressed: () {
            setState(() {
              isEditing = false;
              model.initializeTextFields(group: group);
            });
          },
        ) : Container(),
        FlatButton(
          child: this.isEditing ? Text("FINISH", style: TextStyle(color: Colors.white, fontSize: 16.0),)
            : Text("EDIT", style: TextStyle(color: Colors.white, fontSize: 16.0)),
          onPressed: () async {
            if (this.isEditing) {
              await model.updateGroup(group: group);

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

  Widget _nameTextField({GroupSettingsModel model}) {
    return TextField(
      enabled: isEditing,
      decoration: InputDecoration(hintText: "Group Name"),
      controller: model.nameController,
    );
  }

  Widget _topicTextField({GroupSettingsModel model}) {
    return TextField(
      enabled: isEditing,
      decoration: InputDecoration(hintText: "Group Topic"),
      controller: model.topicController,
    );
  }
}