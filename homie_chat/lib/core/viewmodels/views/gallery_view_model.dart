import 'package:homie_chat/core/models/image_message.dart';
import 'package:homie_chat/core/services/api.dart';
import 'package:homie_chat/core/services/gallery_service.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class GalleryViewModel extends BaseModel {
  Api _api;
  GalleryService _galleryService;

  GalleryViewModel({Api api, GalleryService galleryService}) {
    _api = api;
    _galleryService = galleryService;

    _galleryService.images.listen(_onImagesAdded);
  }

  List<ImageMessage> images;

  _onImagesAdded(List<ImageMessage> _images) {
    setBusy(true);
    images = _images;
    setBusy(false);
  }

  Future<void> getInitialImages() async {
    setBusy(true);
    await _galleryService.getInitialImages();
    setBusy(false);
  }
}