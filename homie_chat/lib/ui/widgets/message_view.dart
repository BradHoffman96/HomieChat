import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/group.dart';
import 'package:homie_chat/core/models/message.dart';
import 'package:homie_chat/core/models/user.dart';
import 'package:homie_chat/core/viewmodels/widgets/message_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

//TODO: I think ChatView might need to contain a widget for the TextInput and MessageView

class MessageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Group _group = Provider.of<Group>(context);
    
    // TODO: implement build
    return BaseWidget<MessageViewModel>(
      model: MessageViewModel(
        groupService: Provider.of(context),
        authenticationService: Provider.of(context),
        messageService: Provider.of(context)),
      onModelReady: (model) => model.connectToSocket(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("HOMIE CHAT"),),
        body: model.busy
          ? Column(
            children: <Widget>[CircularProgressIndicator()],
          ) : _messageView(context, model, _group)
      ),
    );
  }

  Widget _messageView(BuildContext context, MessageViewModel model, Group group) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    List<Message> _messages = Provider.of<List<Message>>(context);

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      reverse: true,
      itemBuilder: (_, int index) {
        Message message = _messages[index];
        User author = group.members[message.senderId];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text(author.displayName[0]))
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(author.displayName, style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    width: c_width,
                    child: Text(message.text, textAlign: TextAlign.left,)
                  )
                ],
              )
            ],
          ),
        );
      },
      itemCount: _messages.length,
    );
  }
}