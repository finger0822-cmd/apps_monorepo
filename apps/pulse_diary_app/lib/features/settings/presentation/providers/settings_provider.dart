import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/secure_storage/api_key_secure_storage.dart';

final apiKeyNotifierProvider =
    AsyncNotifierProvider<ApiKeyNotifier, String?>(() => ApiKeyNotifier());

class ApiKeyNotifier extends AsyncNotifier<String?> {
  late ApiKeySecureStorage _storage;

  @override
  Future<String?> build() async {
    _storage = ApiKeySecureStorageImpl();
    return _storage.getApiKey();
  }

  Future<void> save(String key) async {
    await _storage.setApiKey(key.trim());
    state = AsyncData(key.trim());
  }

  Future<void> delete() async {
    await _storage.deleteApiKey();
    state = const AsyncData(null);
  }
}
