import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  SharedPreferences prefs;

  storeImageFromGallery() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String path = appDocDir.path;
    final File profileImage = await image.copy('$path/profile.image');

    prefs = await SharedPreferences.getInstance();
    prefs.setString("PROFILE_IMAGE_PATH", profileImage.path);
  }

  storeImageFromNetwork() async {

  }
}