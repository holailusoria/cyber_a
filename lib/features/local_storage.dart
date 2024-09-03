import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage{
  static const _storage = FlutterSecureStorage();
  
  static Future<void> saveCurrentLanguage(String language) async {
    await _storage.write(key: 'currentLanguage', value: language);
  }

  static Future<String?> getCurrentLanguage() async {
    return await _storage.read(key: 'currentLanguage');
  }
}