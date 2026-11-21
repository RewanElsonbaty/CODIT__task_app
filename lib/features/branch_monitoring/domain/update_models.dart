import 'package:equatable/equatable.dart';

/// تحديث تدريجي للداشبورد
class DashboardUpdate extends Equatable {
  const DashboardUpdate({
    required this.sequenceNumber,
    required this.branchId,
    required this.timestamp,
    this.salesDeltaPiastres,
    this.cashDeltaPiastres,
    this.goldPricePiastres,
  });

  final int sequenceNumber;
  final String branchId;
  final DateTime timestamp;
  final int? salesDeltaPiastres;
  final int? cashDeltaPiastres;
  final int? goldPricePiastres;

  factory DashboardUpdate.fromJson(Map<String, dynamic> json) {
    return DashboardUpdate(
      sequenceNumber: json['sequence'] as int,
      branchId: json['branch_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      salesDeltaPiastres: json['sales_delta_piastres'] as int?,
      cashDeltaPiastres: json['cash_delta_piastres'] as int?,
      goldPricePiastres: json['gold_price_piastres'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        sequenceNumber,
        branchId,
        timestamp,
        salesDeltaPiastres,
        cashDeltaPiastres,
        goldPricePiastres,
      ];
}

/// Tracker لآخر sequence لكل فرع
class SequenceTracker {
  final Map<String, int> _lastSequence = {};

  int? getLastSequence(String branchId) => _lastSequence[branchId];

  void updateSequence(String branchId, int sequence) {
    _lastSequence[branchId] = sequence;
  }

  void clearSequence(String branchId) {
    _lastSequence.remove(branchId);
  }

  void clearAll() {
    _lastSequence.clear();
  }

  bool hasGap(String branchId, int newSequence) {
    final last = _lastSequence[branchId];
    if (last == null) return false;
    return newSequence != last + 1;
  }
}

/// Response من السيرفر مع تحديثات أو بيانات كاملة
class DashboardResponse {
  const DashboardResponse({
    this.fullData,
    this.updates = const [],
  });

  final DashboardData? fullData;
  final List<DashboardUpdate> updates;

  bool get isFullRefresh => fullData != null;
  bool get hasUpdates => updates.isNotEmpty;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    final fullDataJson = json['full_data'] as Map<String, dynamic>?;
    final updatesJson = json['updates'] as List<dynamic>? ?? [];

    return DashboardResponse(
      fullData: fullDataJson != null
          ? DashboardData.fromJson(fullDataJson)
          : null,
      updates: updatesJson
          .map((u) => DashboardUpdate.fromJson(u as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// بيانات داشبورد كاملة مع sequence
class DashboardData extends Equatable {
  const DashboardData({
    required this.branchId,
    required this.branchName,
    required this.salesPiastres,
    required this.cashPiastres,
    required this.goldPricePiastres,
    required this.recentOperations,
    required this.lastUpdated,
    required this.sequenceNumber,
  });

  final String branchId;
  final String branchName;
  final int salesPiastres;
  final int cashPiastres;
  final int goldPricePiastres;
  final List<RecentOperation> recentOperations;
  final DateTime lastUpdated;
  final int sequenceNumber;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final opsJson = json['recent_operations'] as List<dynamic>? ?? [];
    return DashboardData(
      branchId: json['branch_id'] as String,
      branchName: json['branch_name'] as String,
      salesPiastres: json['sales_piastres'] as int,
      cashPiastres: json['cash_piastres'] as int,
      goldPricePiastres: json['gold_price_piastres'] as int,
      recentOperations: opsJson
          .map((o) => RecentOperation.fromJson(o as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      sequenceNumber: json['sequence'] as int,
    );
  }

  DashboardData applyUpdate(DashboardUpdate update) {
    return DashboardData(
      branchId: branchId,
      branchName: branchName,
      salesPiastres: update.salesDeltaPiastres != null
          ? salesPiastres + update.salesDeltaPiastres!
          : salesPiastres,
      cashPiastres: update.cashDeltaPiastres != null
          ? cashPiastres + update.cashDeltaPiastres!
          : cashPiastres,
      goldPricePiastres: update.goldPricePiastres ?? goldPricePiastres,
      recentOperations: recentOperations,
      lastUpdated: update.timestamp,
      sequenceNumber: update.sequenceNumber,
    );
  }

  @override
  List<Object?> get props => [
        branchId,
        branchName,
        salesPiastres,
        cashPiastres,
        goldPricePiastres,
        recentOperations,
        lastUpdated,
        sequenceNumber,
      ];
}

class RecentOperation extends Equatable {
  const RecentOperation({
    required this.id,
    required this.type,
    required this.amountPiastres,
    required this.timestamp,
  });

  final String id;
  final String type;
  final int amountPiastres;
  final DateTime timestamp;

  factory RecentOperation.fromJson(Map<String, dynamic> json) {
    return RecentOperation(
      id: json['id'] as String,
      type: json['type'] as String,
      amountPiastres: json['amount_piastres'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  List<Object?> get props => [id, type, amountPiastres, timestamp];
}
