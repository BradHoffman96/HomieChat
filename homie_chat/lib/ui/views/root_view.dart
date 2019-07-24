import 'package:flutter/material.dart';
import 'package:homie_chat/core/viewmodels/views/root_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:homie_chat/ui/views/home_view.dart';
import 'package:homie_chat/ui/views/login_view.dart';
import 'package:provider/provider.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<RootViewModel>(
       model: RootViewModel(
         authenticationService: Provider.of(context),
         groupService: Provider.of(context),
         storageService: Provider.of(context)
       ),
       onModelReady: (model) => model.checkLogin(),
       builder: (context, model, child) {
         if (model.busy) {
           return Scaffold(
             body: CircularProgressIndicator()
           );
         } else {
           if (model.hasUser) {
            return HomeView();
           } else {
            return LoginView();
           }
         }
       },
    );
  }
}