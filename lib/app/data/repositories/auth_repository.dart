import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/api_exceptions.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

/// Data-access layer for all donor authentication API calls.
///
/// Every method throws [ApiException] (or a subclass) on failure,
/// which the service/controller layer can catch for user-friendly feedback.
class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  Dio get _dio => ApiClient.instance.dio;

  /// Register a new donor account.
  ///
  /// The API does **not** return tokens on registration; the user must
  /// subsequently log in.
  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String dateOfBirth,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.donorRegister,
        data: {
          'name': name,
          'email': email,
          'dateOfBirth': dateOfBirth,
          'phoneNumber': phoneNumber,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _extractApiException(e);
    }
  }

  /// Log in with email + password. Returns access & refresh tokens.
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.donorLogin,
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _extractApiException(e);
    }
  }

  /// Exchange a refresh token for a new access token.
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.donorRefresh,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;
      return data['accessToken'] as String;
    } on DioException catch (e) {
      throw _extractApiException(e);
    }
  }

  /// Revoke the given refresh token on the server.
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(
        ApiConstants.donorLogout,
        data: {'refreshToken': refreshToken},
      );
    } on DioException {
      // Swallow logout errors – we clear local storage regardless.
    }
  }

  /// Fetch the currently authenticated donor's profile.
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.donorMe);
      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _extractApiException(e);
    }
  }

  /// Extract a typed [ApiException] from a [DioException].
  ApiException _extractApiException(DioException e) {
    if (e.error is ApiException) return e.error as ApiException;

    final message = ApiException.messageFromData(e.response?.data);

    final code = e.response?.statusCode;
    if (code == 401) return UnauthorizedException(message);
    if (code == 400) return ValidationException(message);
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
    return ApiException(message, statusCode: code);
  }
}
