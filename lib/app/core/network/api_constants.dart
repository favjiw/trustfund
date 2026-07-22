/// Centralised API configuration constants.
class ApiConstants {
  const ApiConstants._();

  /// Base URL for the NexTrust backend.
  static const String baseUrl = 'https://nextrust.my.id';

  /// Default connect / receive timeout in milliseconds.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ── Auth (Donor) ────────────────────────────────────────────────────
  static const String donorRegister = '/api/auth/donor/register';
  static const String donorLogin = '/api/auth/donor/login';
  static const String donorRefresh = '/api/auth/donor/refresh';
  static const String donorLogout = '/api/auth/donor/logout';
  static const String donorMe = '/api/auth/donor/me';
  static const String donorDonations = '/api/auth/donor/donations';
}
