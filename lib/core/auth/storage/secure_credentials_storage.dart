import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart';
import 'package:to_do_list/core/auth/models/credentials_storage_base.dart';

class SecureCredentialsStorage implements CredentialsStorageBase {
  late final FlutterSecureStorage _storage;
  static const _storageKey = 'oauth2_credentials';
  Credentials? _cachedCredentials;

  SecureCredentialsStorage(this._storage);

  @override
  Future<Credentials?> read() async {
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    }

    final json = await _storage.read(key: _storageKey);
    if (json == null) {
      return null;
    }
    try {
      return _cachedCredentials = Credentials.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> write(Credentials credentials) {
    _cachedCredentials = credentials;
    return _storage.write(key: _storageKey, value: credentials.toJson());
  }

  @override
  Future<void> clear() {
    _cachedCredentials = null;
    return _storage.delete(key: _storageKey);
  }
}
