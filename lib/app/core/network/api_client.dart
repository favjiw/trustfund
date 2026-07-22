import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../services/storage_service.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

/// Dio-based HTTP client with automatic token injection and refresh logic.
///
/// Usage: `final response = await ApiClient.instance.dio.get('/api/...');`
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  late final Dio dio;

  /// Must be called once (during app startup) after [StorageService] is ready.
  void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(_TokenInterceptor());
    dio.interceptors.add(_LoggingInterceptor());
  }
}

/// Compact request logger.
///
/// Logs one line per request/response instead of dumping full bodies, which
/// keeps frequent polling (e.g. the QRIS status poll) from flooding the
/// console. A request may opt out entirely by setting `extra['silent'] = true`.
class _LoggingInterceptor extends Interceptor {
  bool _silent(RequestOptions options) => options.extra['silent'] == true;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!_silent(response.requestOptions)) {
      printInfo(
        info: '← ${response.statusCode} '
            '${response.requestOptions.method} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Errors are always logged (including the message) — they are rare and
    // useful even for otherwise-silent requests.
    printInfo(
      info: '✗ ${err.response?.statusCode} '
          '${err.requestOptions.method} ${err.requestOptions.uri} — ${err.message}',
    );
    handler.next(err);
  }
}

/// Interceptor that:
/// 1. Attaches the stored access token to every outgoing request.
/// 2. On a 401 response, tries to refresh the token and retry the request.
/// 3. If the refresh also fails, clears storage and redirects to login.
class _TokenInterceptor extends Interceptor {
  /// Endpoints that should **not** receive an Authorization header.
  static const _publicPaths = {
    ApiConstants.donorLogin,
    ApiConstants.donorRegister,
    ApiConstants.donorRefresh,
  };

  bool _isRefreshing = false;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_publicPaths.contains(options.path)) {
      final storage = Get.find<StorageService>();
      final token = await storage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only attempt refresh on 401 for non-refresh endpoints.
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiConstants.donorRefresh &&
        err.requestOptions.path != ApiConstants.donorLogin &&
        !_isRefreshing) {
      _isRefreshing = true;
      try {
        final storage = Get.find<StorageService>();
        final refreshToken = await storage.getRefreshToken();

        if (refreshToken == null) {
          _forceLogout();
          return handler.reject(err);
        }

        // Create a separate Dio instance to avoid interceptor recursion.
        final freshDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final refreshResponse = await freshDio.post(
          ApiConstants.donorRefresh,
          data: {'refreshToken': refreshToken},
        );

        final data = refreshResponse.data as Map<String, dynamic>;
        if (data['accessToken'] != null) {
          final newAccessToken = data['accessToken'] as String;
          await storage.saveAccessToken(newAccessToken);

          // Retry the original request with the new token.
          err.requestOptions.headers['Authorization'] =
          'Bearer $newAccessToken';
          final retryResponse =
          await freshDio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } else {
          _forceLogout();
          return handler.reject(err);
        }
      } on DioException {
        _forceLogout();
        return handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    }

    // Map Dio errors to our custom exceptions for cleaner handling.
    handler.reject(_mapError(err));
  }

  DioException _mapError(DioException err) {
    ApiException mapped;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        mapped = const NetworkException();
        break;
      default:
        final statusCode = err.response?.statusCode;
        final message = ApiException.messageFromData(err.response?.data);

        if (statusCode == 401) {
          mapped = UnauthorizedException(message);
        } else if (statusCode == 400) {
          mapped = ValidationException(message);
        } else {
          mapped = ApiException(message, statusCode: statusCode);
        }
    }

    return DioException(
      requestOptions: err.requestOptions,
      error: mapped,
      response: err.response,
      type: err.type,
    );
  }

  void _forceLogout() {
    final storage = Get.find<StorageService>();
    storage.clearAll();
    // Navigate to login, clearing the entire stack.
    Get.offAllNamed('/login');
  }
}