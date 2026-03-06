import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Securely stores and retrieves the Claude API key.
abstract class ApiKeySecureStorage {
  Future<String?> getApiKey();
  Future<void> setApiKey(String value);
  Future<void> deleteApiKey();
}

const String _keyClaudeApiKey = 'claude_api_key';

/// [FlutterSecureStorage] implementation for Claude API key.
class ApiKeySecureStorageImpl implements ApiKeySecureStorage {
  ApiKeySecureStorageImpl({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getApiKey() => _storage.read(key: _keyClaudeApiKey);

  @override
  Future<void> setApiKey(String value) =>
      _storage.write(key: _keyClaudeApiKey, value: value);

  @override
  Future<void> deleteApiKey() => _storage.delete(key: _keyClaudeApiKey);
}
