import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class SecureStorage {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> deleteString(String key);
  Future<void> saveJson(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getJson(String key);
}

@LazySingleton(as: SecureStorage)
class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _secureStorage;

  SecureStorageImpl(this._secureStorage);

  @override
  Future<void> saveString(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> deleteString(String key) {
    return _secureStorage.delete(key: key);
  }

  @override
  Future<String?> getString(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  @override
  Future<void> saveJson(String key, Map<String, dynamic> value) {
    return saveString(key, jsonEncode(value));
  }
}

