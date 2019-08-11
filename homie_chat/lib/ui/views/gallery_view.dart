import 'package:flutter/material.dart';
import 'package:homie_chat/core/viewmodels/views/gallery_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class GalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<GalleryViewModel>(
      model: GalleryViewModel(api: Provider.of(context)),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Gallery"),),
        body: Column(
          children: <Widget>[
            Text("Test")
          ],
        ),
      ),
      
    );
  }
}