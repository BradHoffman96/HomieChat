import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homie_chat/core/models/image_message.dart';
import 'package:homie_chat/core/services/api.dart';

class GalleryService {
  Api _api;

  List<ImageMessage> _images;

  GalleryService({@required Api api}) {
    _api = api;
    _images = List<ImageMessage>();
  }

  final StreamController<List<ImageMessage>> _galleryController = StreamController<List<ImageMessage>>.broadcast();

  Stream<List<ImageMessage>> get images => _galleryController.stream;
  StreamController<List<ImageMessage>> get imagesController => _galleryController;

  Future<List<ImageMessage>> getInitialImages() async {
    var images = await _api.getGalleryImages();
    if (images != null) {
      _images = images;
    }
    
    return _images;
  }

  Future<bool> getMoreImages({@required String imageId}) async {
    //TODO: implement
  }
}