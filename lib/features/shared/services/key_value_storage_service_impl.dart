import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  Future<SharedPreferences> initSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final SharedPreferences sp = await initSharedPreferences();
    switch (T) {
      case int:
        return sp.getInt(key) as T?;
      case String:
        return sp.getString(key) as T?;
      default:
        throw UnimplementedError(
            'GET not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final SharedPreferences sp = await initSharedPreferences();
    return await sp.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final SharedPreferences sp = await initSharedPreferences();
    switch (T) {
      case int:
        await sp.setInt(key, value as int);
        break;
      case String:
        await sp.setString(key, value as String);
        break;
      default:
        throw UnimplementedError(
            'SET not implemented for type ${T.runtimeType}');
    }
  }
}
