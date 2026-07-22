/// Standard error envelope returned by the API.
///
/// ```json
/// { "ok": false, "error": "Pesan kesalahan" }
/// ```
class ApiError {
  final bool ok;
  final String error;

  const ApiError({
    required this.ok,
    required this.error,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      ok: json['ok'] as bool? ?? false,
      error: json['error'] as String? ?? 'Terjadi kesalahan.',
    );
  }
}
