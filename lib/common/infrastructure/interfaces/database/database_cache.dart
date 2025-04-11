// abstract class DatabaseCacheInterface {
//   Future<T?> get<T>(String key);
//   Future<void> set<T>(String key, T value);
//   Future<void> remove(String key);
//   Future<void> clear();
// }

abstract class GetCacheInterface<T> {
  Future<List<T>?> get(String key);
}

abstract class SetCacheInterface<T> {
  Future<void> set(String key, T value);
}
