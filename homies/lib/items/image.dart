import 'dart:io';

import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  ImageMessage({this.image});
  final File image;

  String _name = "Brad Hoffman";

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0]))
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_name, style: Theme.of(context).textTheme.subhead),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                width: c_width,
                child: Image.file(image)
              )
            ],
          )
        ],
      ),
      
    );
  }
}