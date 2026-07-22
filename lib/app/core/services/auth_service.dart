import 'package:get/get.dart';

import '../../data/models/auth_response.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../network/api_exceptions.dart';
import 'storage_service.dart';

/// Application-wide authentication state manager.
///
/// Registered as a permanent `GetxService` during app startup so that it
/// outlives any individual page or controller.
///
/// Other layers call methods here (not the repository directly) because
/// this service coordinates token persistence, reactive state, and
/// navigation side-effects.
class AuthService extends GetxService {
  final _repo = AuthRepository.instance;

  StorageService get _storage => Get.find<StorageService>();

  // ── Reactive state ──────────────────────────────────────────────────
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  bool get isLoggedIn => currentUser.value != null;

  // ── Lifecycle ───────────────────────────────────────────────────────

  /// Called once during startup. Tries to restore a previous session from
  /// stored tokens.
  Future<AuthService> initAuth() async {
    await _tryRestoreSession();
    return this;
  }

  // ── Public API ──────────────────────────────────────────────────────

  /// Register a new donor.  On success the user must still log in
  /// (the API does not return tokens on registration).
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String dateOfBirth,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) {
    return _repo.register(
      name: name,
      email: email,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  /// Log in and persist tokens + user data.
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _repo.login(email: email, password: password);

    // Persist tokens & user.
    await _storage.saveAccessToken(response.accessToken);
    await _storage.saveRefreshToken(response.refreshToken);
    await _storage.saveUser(response.user.toJson());

    currentUser.value = response.user;
    return response;
  }

  /// Log out: revoke on the server, then clear local state.
  Future<void> logout() async {
    final refresh = await _storage.getRefreshToken();
    if (refresh != null) {
      await _repo.logout(refresh);
    }
    await _storage.clearAll();
    currentUser.value = null;
  }

  // ── Internals ───────────────────────────────────────────────────────

  /// Attempt to restore a session from stored tokens by fetching the
  /// user profile.  If the tokens are expired and cannot be refreshed
  /// the storage is silently cleared.
  Future<void> _tryRestoreSession() async {
    final accessToken = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();

    if (accessToken == null && refreshToken == null) return;

    try {
      // First try to load user from cached data for instant startup.
      final cachedUser = await _storage.getUser();
      if (cachedUser != null) {
        currentUser.value = UserModel.fromJson(cachedUser);
      }

      // Then verify the session is still valid in the background.
      final freshUser = await _repo.getProfile();
      currentUser.value = freshUser;
      await _storage.saveUser(freshUser.toJson());
    } on ApiException {
      // Token is invalid and could not be refreshed (the interceptor
      // already attempted a refresh).  Clean up silently.
      await _storage.clearAll();
      currentUser.value = null;
    } catch (_) {
      // Network error during restore – keep cached user if available
      // so the app can start in offline mode.
    }
  }
}
