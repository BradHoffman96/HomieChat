import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService _instance;
  static SharedPreferences _preferences;

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  dynamic getKey(String key) async {
    var value = _preferences.get(key);
    return value;
  }

  void storeKey<T>(String key, T value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    }
  }

  Future<bool> deleteKey(String key) async {
    var result = await _preferences.remove(key);
    return result;
  }
}