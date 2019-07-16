import 'package:flutter/material.dart';
import 'package:homies/scoped_models/register_view_model.dart';

import 'base_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterModel>(
      builder: (context, child, model) => Scaffold(

      )
    );
  }
}