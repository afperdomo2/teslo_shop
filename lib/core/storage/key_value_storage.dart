abstract class KeyValueStorage {
  Future<void> save<T>(String key, T value);
  Future<T?> read<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
