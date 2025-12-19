import 'package:fdl_types/repo_result/repo_result.dart';

mixin CacheFallbackMixin {
  Future<RepoResult<T>> withCacheFallback<T>({
    required Future<T> Function() networkCall,
    required Future<T?> Function() getCache,
    Future<void> Function(T)? saveCache,
  }) async {
    try {
      final data = await networkCall();
      if (saveCache != null) {
        await saveCache(data);
      }
      return RepoResult(data: data);
    } catch (e) {
      final cached = await getCache();
      if (cached != null) {
        return RepoResult(data: cached);
      }
      rethrow;
    }
  }
}
