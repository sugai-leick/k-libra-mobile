import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ITokenService {
  Future<void> saveToken(String token, {bool rememberMe = true});
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    bool rememberMe = true,
  });
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> deleteToken();
  Future<void> clearTokens();
  Future<bool> hasToken();
}

class TokenService implements ITokenService {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  String? _sessionToken;
  String? _sessionRefreshToken;

  TokenService(this._storage);

  @override
  Future<void> saveToken(String token, {bool rememberMe = true}) async {
    _sessionToken = token;
    if (rememberMe) {
      await _storage.write(key: _tokenKey, value: token);
    } else {
      await _storage.delete(key: _tokenKey); // não persiste o token
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    bool rememberMe = true,
  }) async {
    _sessionToken = accessToken;
    _sessionRefreshToken = refreshToken;

    if (rememberMe) {
      await _storage.write(key: _tokenKey, value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: _refreshTokenKey, value: refreshToken);
      }
    } else {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
    }
  }

  @override
  Future<String?> getToken() async {
    return _sessionToken ?? await _storage.read(key: _tokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _sessionRefreshToken ?? await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> deleteToken() async {
    _sessionToken = null;
    _sessionRefreshToken = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await deleteToken();
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
