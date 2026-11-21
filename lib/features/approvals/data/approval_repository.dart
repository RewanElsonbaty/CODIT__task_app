import 'package:codit/core/network/api_client.dart';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';

/// Repository للموافقات
class ApprovalRepository {
  ApprovalRepository(this._api, this._network);

  final ApiClient _api;
  final NetworkInfo _network;
  
  // Cache للقرارات المرسلة (في الذاكرة)
  // TODO: حفظ في Database بعد انتهاء build_runner
  final Map<String, ApprovalDecision> _sentDecisions = {};

  /// جلب قائمة الموافقات
  Future<List<ApprovalSummary>> fetchApprovals({
    ApprovalStatus? status,
  }) async {
    final response = await _api.dio.get(
      '/approvals',
      queryParameters: status != null ? {'status': status.name} : null,
    );

    final data = response.data as Map<String, dynamic>;
    final approvals = (data['approvals'] as List)
        .map((json) => ApprovalSummary.fromJson(json))
        .toList();

    return approvals;
  }

  /// جلب الإحصائيات
  Future<ApprovalStats> fetchStats() async {
    final response = await _api.dio.get('/approvals/stats');
    final data = response.data as Map<String, dynamic>;
    return ApprovalStats.fromJson(data);
  }

  /// جلب تفاصيل طلب موافقة
  Future<ApprovalDetail> fetchApprovalDetail(String id) async {
    final response = await _api.dio.get('/approvals/$id');
    final data = response.data as Map<String, dynamic>;
    return ApprovalDetail.fromJson(data);
  }

  /// تحديث تفاصيل الطلب قبل القرار
  /// (للتأكد من عدم تغير البيانات)
  Future<ApprovalDetail> refreshApprovalDetail(String id) async {
    return await fetchApprovalDetail(id);
  }

  /// إرسال قرار (موافقة أو رفض)
  Future<ApprovalDetail> sendDecision(ApprovalDecision decision) async {
    // 1️⃣ التحقق من الاتصال
    if (!await _network.isConnected) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    }

    // 2️⃣ التحقق من عدم إرسال نفس القرار مرتين
    if (_sentDecisions.containsKey(decision.idempotencyKey)) {
      throw Exception('تم إرسال هذا القرار من قبل');
    }

    try {
      // 3️⃣ إرسال القرار
      final endpoint = decision.approved
          ? '/approvals/${decision.requestId}/approve'
          : '/approvals/${decision.requestId}/reject';

      final response = await _api.dio.post(
        endpoint,
        data: decision.toJson(),
      );

      // 4️⃣ حفظ القرار في الكاش
      _sentDecisions[decision.idempotencyKey] = decision;

      // 5️⃣ إرجاع التفاصيل المحدثة
      final data = response.data as Map<String, dynamic>;
      return ApprovalDetail.fromJson(data);
      
    } catch (e) {
      // إذا كان خطأ شبكة، نرمي exception خاص
      // ونحفظ القرار في الكاش (ربما وصل للسيرفر)
      _sentDecisions[decision.idempotencyKey] = decision;
      
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw UnknownDecisionException(
          'الاتصال انقطع - النتيجة غير مؤكدة. '
          'يرجى التحقق من حالة الطلب قبل إعادة المحاولة.',
        );
      }
      rethrow;
    }
  }

  /// التحقق من حالة الطلب (بعد Unknown)
  Future<ApprovalDetail> checkRequestStatus(String id) async {
    return await fetchApprovalDetail(id);
  }

  /// مسح الكاش
  void clearCache() {
    _sentDecisions.clear();
  }
}

/// Exception خاص للنتائج غير المؤكدة
class UnknownDecisionException implements Exception {
  UnknownDecisionException(this.message);
  final String message;

  @override
  String toString() => message;
}
