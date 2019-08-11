import 'package:homie_chat/core/services/api.dart';
import 'package:homie_chat/core/viewmodels/base_model.dart';

class GalleryViewModel extends BaseModel {
  final Api _api;

  GalleryViewModel({Api api}) : _api = api;
}