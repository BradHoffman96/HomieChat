import 'package:flutter/material.dart';
import 'package:homie_chat/core/viewmodels/views/gallery_view_model.dart';
import 'package:homie_chat/ui/views/base_widget.dart';
import 'package:provider/provider.dart';

class GalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<GalleryViewModel>(
      model: GalleryViewModel(galleryService: Provider.of(context)),
      onModelReady: (model) => model.getInitialImages(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Gallery"),),
        body: Column(
          children: <Widget>[
            model.busy
              ? Column(children: <Widget>[Center(child: Text("No images avaialable"))],) 
              : GridView.count(
                crossAxisCount: 3,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: List.generate(model.images.length, (index) =>_imageBuilder(model, index))
            )
          ],
        ),
      ),
      
    );
  }

  Widget _imageBuilder(GalleryViewModel model, int index) {
    return Card(
      margin: EdgeInsets.all(3.0),
      child: Image.memory(model.images[index].image),
    );
  }
}