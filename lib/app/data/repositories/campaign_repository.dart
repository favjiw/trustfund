import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../models/campaign.dart';
import '../models/campaign_detail.dart';
import '../models/campaign_item.dart';
import '../models/campaign_record.dart';
import '../models/donor_graph.dart';
import '../models/saved_campaign.dart';

/// Data-access layer for donor-facing campaign browsing.
///
/// Backed by the NexTrust API (`/api/campaigns`). Every list/detail view-model
/// is projected from the [Campaign] record built via [Campaign.fromApi], so a
/// tapped card resolves to matching detail content. Fetched records are cached
/// so the saved list can resolve ids without a re-fetch.
class CampaignRepository {
  CampaignRepository._();

  static final CampaignRepository instance = CampaignRepository._();

  Dio get _dio => ApiClient.instance.dio;

  static const String _campaignsPath = '/api/campaigns';

  /// Reactive set of saved campaign ids shared across the app. Persists across
  /// navigation but not restart (server-side saves are not yet implemented).
  final RxList<String> savedIds = <String>[].obs;

  /// In-memory cache of records fetched from the API, keyed by id.
  final Map<String, Campaign> _cache = {};

  /// Dedupes concurrent list fetches. The home screen requests the urgent and
  /// popular projections back-to-back; sharing one in-flight request avoids
  /// downloading the (image-heavy) list twice.
  Future<List<Campaign>>? _inFlight;

  /// Short-lived cache of the full list. The backend list endpoint is very
  /// slow (legacy campaigns embed base64 PDFs, ~1.2 MB / 15-25 s), so
  /// navigating Home -> Kampanye within the TTL reuses the last download
  /// instead of re-fetching. Pass `force: true` (pull-to-refresh / retry)
  /// to bypass.
  static const Duration _listCacheTtl = Duration(minutes: 2);
  List<Campaign>? _lastList;
  DateTime? _lastFetchedAt;

  bool isSaved(String id) => savedIds.contains(id);

  void toggleSaved(String id) {
    if (savedIds.contains(id)) {
      savedIds.remove(id);
    } else {
      savedIds.add(id);
    }
  }

  /// Saved campaigns projected from cached records, in saved order.
  List<SavedCampaign> savedCampaignList() {
    return [
      for (final id in savedIds)
        if (_cache[id] != null) _cache[id]!.toSaved(),
    ];
  }

  /// Fetches the full campaign list, reusing the recent cache when fresh and
  /// sharing any request already in flight.
  Future<List<Campaign>> _fetchAll({bool force = false}) {
    final cached = _lastList;
    final fetchedAt = _lastFetchedAt;
    if (!force &&
        cached != null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < _listCacheTtl) {
      return Future.value(cached);
    }
    return _inFlight ??= _fetchAllUncached().whenComplete(() {
      _inFlight = null;
    });
  }

  Future<List<Campaign>> _fetchAllUncached() async {
    try {
      final response = await _dio.get(_campaignsPath);
      final data = response.data as Map<String, dynamic>;
      // Donor-facing lists only surface live campaigns.
      final list = (data['campaigns'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(Campaign.fromApi)
          .where((campaign) => campaign.isActive)
          .toList();
      for (final campaign in list) {
        _cache[campaign.id] = campaign;
      }
      _lastList = list;
      _lastFetchedAt = DateTime.now();
      return list;
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<List<UrgentCampaign>> fetchUrgent({bool force = false}) async {
    final all = await _fetchAll(force: force);
    return all.map((c) => c.toUrgent()).toList();
  }

  Future<List<PopularCampaign>> fetchPopular({bool force = false}) async {
    final all = await _fetchAll(force: force);
    return all.map((c) => c.toPopular()).toList();
  }

  Future<List<CampaignItem>> fetchCampaignItems({bool force = false}) async {
    final all = await _fetchAll(force: force);
    return all.map((c) => c.toItem()).toList();
  }

  Future<CampaignDetail> fetchDetailById(String id) async {
    try {
      final response = await _dio.get('$_campaignsPath/$id');
      final data = response.data as Map<String, dynamic>;
      final campaign = Campaign.fromApi(data['campaign'] as Map<String, dynamic>);
      _cache[campaign.id] = campaign;
      return campaign.toDetail();
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  /// Fetches the pre-indexed donor network for one campaign
  /// (`GET /api/campaigns/{id}/donor-graph`).
  Future<DonorGraph> fetchDonorGraph(String id) async {
    try {
      final response = await _dio.get('$_campaignsPath/$id/donor-graph');
      return DonorGraph.fromJson(response.data as Map<String, dynamic>);
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
