import 'user_model.dart';

/// Response from `POST /api/auth/donor/login`.
class LoginResponse {
  final bool ok;
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const LoginResponse({
    required this.ok,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      ok: json['ok'] as bool? ?? false,
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// Response from `POST /api/auth/donor/register`.
class RegisterResponse {
  final bool ok;
  final UserModel user;

  const RegisterResponse({
    required this.ok,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      ok: json['ok'] as bool? ?? false,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
