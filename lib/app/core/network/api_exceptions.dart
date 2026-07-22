/// Base class for all API-related exceptions.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  /// Extracts a human-readable error message from a NexTrust API error body.
  ///
  /// The backend returns errors as `{"status":"fail","message":"..."}`.
  /// (Older docs mention `{"error":"..."}`, so that key is kept as a
  /// fallback.) Returns [fallback] when no message can be found.
  static String messageFromData(
    dynamic data, {
    String fallback = 'Terjadi kesalahan yang tidak terduga.',
  }) {
    if (data is Map) {
      final msg = data['message'] ?? data['error'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
    return fallback;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thrown when the server returns 401 (token expired / invalid).
class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Sesi telah berakhir. Silakan masuk kembali.'])
      : super(message, statusCode: 401);
}

/// Thrown when the server returns 400 (validation errors).
class ValidationException extends ApiException {
  const ValidationException(super.message) : super(statusCode: 400);
}

/// Thrown when there is no internet or the server is unreachable.
class NetworkException extends ApiException {
  const NetworkException([String message = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.'])
      : super(message);
}
