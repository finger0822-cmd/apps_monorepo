import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Claude API キーを安全に保存・取得する抽象クラス
abstract class ApiKeyStorage {
  Future<String?> getApiKey();
  Future<void> setApiKey(String value);
  Future<void> deleteApiKey();
}

const String _keyClaudeApiKey = 'mind_capsule_claude_api_key';

/// FlutterSecureStorage を用いた API キー保存の実装
class ApiKeyStorageImpl implements ApiKeyStorage {
  ApiKeyStorageImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getApiKey() => _storage.read(key: _keyClaudeApiKey);

  @override
  Future<void> setApiKey(String value) =>
      _storage.write(key: _keyClaudeApiKey, value: value);

  @override
  Future<void> deleteApiKey() => _storage.delete(key: _keyClaudeApiKey);
}
