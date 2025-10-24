import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_app/core/storage/key_value_storage.dart';

class SharedPrefsAdapter implements KeyValueStorage {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<void> clear() {
    final prefs = getSharedPrefs();
    return prefs.then((p) => p.clear());
  }

  @override
  Future<T?> read<T>(String key) {
    final prefs = getSharedPrefs();
    if (T == String) {
      return prefs.then((p) => p.getString(key) as T?);
    } else if (T == int) {
      return prefs.then((p) => p.getInt(key) as T?);
    } else if (T == bool) {
      return prefs.then((p) => p.getBool(key) as T?);
    } else if (T == double) {
      return prefs.then((p) => p.getDouble(key) as T?);
    } else if (T == List<String>) {
      return prefs.then((p) => p.getStringList(key) as T?);
    } else {
      throw Exception('Tipo de dato no soportado');
    }
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await getSharedPrefs();
    await prefs.remove(key);
  }

  @override
  Future<void> save<T>(String key, T value) {
    final prefs = getSharedPrefs();
    if (value is String) {
      return prefs.then((p) => p.setString(key, value));
    } else if (value is int) {
      return prefs.then((p) => p.setInt(key, value));
    } else if (value is bool) {
      return prefs.then((p) => p.setBool(key, value));
    } else if (value is double) {
      return prefs.then((p) => p.setDouble(key, value));
    } else if (value is List<String>) {
      return prefs.then((p) => p.setStringList(key, value));
    } else {
      throw Exception('Tipo de dato no soportado');
    }
  }
}
