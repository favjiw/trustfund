import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../models/donation_charge.dart';

/// Data-access layer for donor donations.
///
/// - [startDonation] creates a Midtrans Snap transaction and returns the
///   hosted QRIS payment page.
/// - [fetchStatus] polls the campaign's donation list to observe the status
///   the Midtrans webhook writes on the backend (the app cannot receive the
///   webhook itself).
class DonationRepository {
  DonationRepository._();

  static final DonationRepository instance = DonationRepository._();

  Dio get _dio => ApiClient.instance.dio;

  /// Starts a donation and returns the Midtrans QRIS charge.
  Future<DonationCharge> startDonation({
    required String campaignId,
    required String donorName,
    required int amount,
  }) async {
    try {
      final response = await _dio.post(
        '/api/campaigns/$campaignId/donations',
        data: {
          'donorName': donorName,
          'amount': amount,
        },
      );
      return DonationCharge.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  /// Triggers a sandbox payment for [donationId] via the backend.
  ///
  /// This calls a backend-only helper that uses the Midtrans **Server Key**
  /// (which must never live in the app) to mark the sandbox transaction paid.
  /// Expected contract:
  ///
  /// `POST /api/campaigns/{campaignId}/donations/{donationId}/simulate`
  /// → `200 {"ok": true}` and the donation status becomes `DEPOSITED`.
  ///
  /// Throws [ApiException] on failure (e.g. a 404 while the endpoint is not yet
  /// implemented on the backend).
  Future<void> simulatePayment({
    required String campaignId,
    required String donationId,
  }) async {
    try {
      await _dio.post(
        '/api/campaigns/$campaignId/donations/$donationId/simulate',
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  /// Fetches the current [DonationStatus] for [donationId] by locating it in
  /// the campaign's donation list. Returns [DonationStatus.unknown] when the
  /// donation cannot be found yet.
  Future<DonationStatus> fetchStatus({
    required String campaignId,
    required String donationId,
  }) async {
    try {
      final response = await _dio.get(
        '/api/campaigns/$campaignId/donations',
        options: Options(extra: {'silent': true}),
      );
      final data = response.data as Map<String, dynamic>;
      final donations = (data['donations'] as List? ?? const [])
          .whereType<Map<String, dynamic>>();
      for (final donation in donations) {
        if (donation['id'] == donationId) {
          return DonationStatus.fromApi(donation['status'] as String?);
        }
      }
      return DonationStatus.unknown;
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  /// Fetches the on-chain proof for a donation by its Midtrans [orderId].
  ///
  /// `GET /api/donations/{orderId}/status`
  /// → `{ok, orderId, status, txHash, explorerUrl}` (txHash/explorerUrl are
  /// null until the deposit is confirmed on chain).
  Future<DonationOnChainStatus> fetchOnChainStatus(String orderId) async {
    try {
      final response = await _dio.get('/api/donations/$orderId/status');
      return DonationOnChainStatus.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  ApiException _toApiException(DioException e) {
    if (e.error is ApiException) return e.error as ApiException;
    return ApiException(
      ApiException.messageFromData(e.response?.data),
      statusCode: e.response?.statusCode,
    );
  }
}
