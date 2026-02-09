import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<void> saveString(String key, String value) async {
    await _preferences!.setString(key, value);
  }

  String? getString(String key) => _preferences!.getString(key);

  Future<void> saveInt(String key, int value) async {
    await _preferences!.setInt(key, value);
  }

  int? getInt(String key) => _preferences!.getInt(key);

  Future<void> saveBool(String key, bool value) async {
    await _preferences!.setBool(key, value);
  }

  bool? getBool(String key) => _preferences!.getBool(key);

  Future<void> saveJson(String key, Map<String, dynamic> value) async {
    await _preferences!.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final str = _preferences!.getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    await _preferences!.setString(key, jsonEncode(value));
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final str = _preferences!.getString(key);
    if (str == null) return null;
    try {
      return (jsonDecode(str) as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> remove(String key) async {
    await _preferences!.remove(key);
  }

  Set<String> getKeys() => _preferences!.getKeys();

  Future<void> clear() async {
    await _preferences!.clear();
  }
}
