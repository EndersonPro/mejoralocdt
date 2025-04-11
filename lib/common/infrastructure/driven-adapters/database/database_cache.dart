import 'package:mejoralo_cdt/common/infrastructure/interfaces/database/database_cache.dart';

class TransactionCacheService<T>
    implements GetCacheInterface<T>, SetCacheInterface<T> {
  @override
  Future<List<T>?> get(String key) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> set(String key, T value) {
    // TODO: implement set
    throw UnimplementedError();
  }
}
