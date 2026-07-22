import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Thin wrapper around [FlutterSecureStorage] that provides typed
/// convenience methods for auth-related data.
class StorageService extends GetxService {
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUser = 'user_data';

  late final FlutterSecureStorage _storage;

  @override
  void onInit() {
    super.onInit();
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // ── Access Token ──────────────────────────────────────────────────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: _keyAccessToken);

  Future<void> deleteAccessToken() =>
      _storage.delete(key: _keyAccessToken);

  // ── Refresh Token ─────────────────────────────────────────────────
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  Future<void> deleteRefreshToken() =>
      _storage.delete(key: _keyRefreshToken);

  // ── User Data (JSON string) ───────────────────────────────────────
  Future<void> saveUser(Map<String, dynamic> userJson) =>
      _storage.write(key: _keyUser, value: jsonEncode(userJson));

  Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: _keyUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> deleteUser() =>
      _storage.delete(key: _keyUser);

  // ── Clear All ─────────────────────────────────────────────────────
  Future<void> clearAll() => _storage.deleteAll();
}
