import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_summary.freezed.dart';
part 'branch_summary.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// Branch summary data with sequence tracking for real-time updates
@freezed
class BranchSummary with _$BranchSummary {
  const factory BranchSummary({
    required String branchId,
    required String branchName,
    required int sequence, // For idempotent updates
    required SalesSummary sales,
    required CashSummary cash,
    required GoldPrices goldPrices,
    required List<RecentOperation> recentOperations,
    required DateTime lastUpdate,
  }) = _BranchSummary;

  factory BranchSummary.fromJson(Map<String, dynamic> json) =>
      _$BranchSummaryFromJson(json);
}

/// Sales summary
@freezed
class SalesSummary with _$SalesSummary {
  const factory SalesSummary({
    required int totalSalesPiastres, // Total sales in piastres
    required int invoicesCount,
    required int totalReturnsPiastres, // Total returns in piastres
  }) = _SalesSummary;

  factory SalesSummary.fromJson(Map<String, dynamic> json) =>
      _$SalesSummaryFromJson(json);
}

/// Cash summary
@freezed
class CashSummary with _$CashSummary {
  const factory CashSummary({
    required int availableCashPiastres, // Available cash in piastres
    required int totalCollectionsPiastres, // Total collections in piastres
  }) = _CashSummary;

  factory CashSummary.fromJson(Map<String, dynamic> json) =>
      _$CashSummaryFromJson(json);
}

/// Gold prices per karat
@freezed
class GoldPrices with _$GoldPrices {
  const factory GoldPrices({
    required int karat18PricePerGramPiastres, // Price per gram in piastres
    required int karat21PricePerGramPiastres,
    required int karat24PricePerGramPiastres,
    required DateTime lastUpdated,
  }) = _GoldPrices;

  factory GoldPrices.fromJson(Map<String, dynamic> json) =>
      _$GoldPricesFromJson(json);
}

/// Recent operation types
enum OperationType {
  @JsonValue('sale')
  sale,
  @JsonValue('installment_collection')
  installmentCollection,
  @JsonValue('approval_request')
  approvalRequest,
  @JsonValue('return')
  return_,
}

extension OperationTypeExtension on OperationType {
  String get label {
    switch (this) {
      case OperationType.sale:
        return 'بيع جديد';
      case OperationType.installmentCollection:
        return 'تحصيل قسط';
      case OperationType.approvalRequest:
        return 'طلب موافقة';
      case OperationType.return_:
        return 'عملية مرتجع';
    }
  }

  String get icon {
    switch (this) {
      case OperationType.sale:
        return '💰';
      case OperationType.installmentCollection:
        return '💵';
      case OperationType.approvalRequest:
        return '✋';
      case OperationType.return_:
        return '↩️';
    }
  }
}

/// Recent operation
@freezed
class RecentOperation with _$RecentOperation {
  const factory RecentOperation({
    required String id,
    required OperationType type,
    required String description,
    required int amountPiastres, // Amount in piastres
    required DateTime timestamp,
  }) = _RecentOperation;

  factory RecentOperation.fromJson(Map<String, dynamic> json) =>
      _$RecentOperationFromJson(json);
}

/// Branch update (incremental update with sequence)
@freezed
class BranchUpdate with _$BranchUpdate {
  const factory BranchUpdate({
    required String branchId,
    required int sequence, // Sequence number for this update
    required DateTime timestamp,
    SalesSummary? sales, // Nullable - only present if sales changed
    CashSummary? cash,
    GoldPrices? goldPrices,
    RecentOperation? newOperation, // New operation to add to list
  }) = _BranchUpdate;

  factory BranchUpdate.fromJson(Map<String, dynamic> json) =>
      _$BranchUpdateFromJson(json);
}
