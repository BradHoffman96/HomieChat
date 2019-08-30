import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/views/%20members_view_model.dart';
import 'package:homie_chat/ui/shared/ui_helpers.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class MembersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _group = Provider.of<Group>(context);
    var keys = _group.members.keys.toList();

    return BaseWidget<MembersViewModel>(
      model: MembersViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Members"),),
        body: GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: List.generate(_group.members.length, (index) => _cardBuilder(_group.members[keys[index]])
          )
        )
      ), 
    );
  }

  _cardBuilder(User member) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        image: DecorationImage(
          image: MemoryImage(member.image),
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              member.displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 20.0, 
                color: Colors.white
              ),
            ),
            UIHelper.verticalSpaceSmall
          ],
        ),
      ),
    );
  }
}