// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchSummary _$BranchSummaryFromJson(Map<String, dynamic> json) =>
    _BranchSummary(
      branchId: json['branchId'] as String,
      branchName: json['branchName'] as String,
      sequence: (json['sequence'] as num).toInt(),
      sales: SalesSummary.fromJson(json['sales'] as Map<String, dynamic>),
      cash: CashSummary.fromJson(json['cash'] as Map<String, dynamic>),
      goldPrices: GoldPrices.fromJson(
        json['goldPrices'] as Map<String, dynamic>,
      ),
      recentOperations: (json['recentOperations'] as List<dynamic>)
          .map((e) => RecentOperation.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$BranchSummaryToJson(_BranchSummary instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'sequence': instance.sequence,
      'sales': instance.sales,
      'cash': instance.cash,
      'goldPrices': instance.goldPrices,
      'recentOperations': instance.recentOperations,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

_SalesSummary _$SalesSummaryFromJson(Map<String, dynamic> json) =>
    _SalesSummary(
      totalSalesPiastres: (json['totalSalesPiastres'] as num).toInt(),
      invoicesCount: (json['invoicesCount'] as num).toInt(),
      totalReturnsPiastres: (json['totalReturnsPiastres'] as num).toInt(),
    );

Map<String, dynamic> _$SalesSummaryToJson(_SalesSummary instance) =>
    <String, dynamic>{
      'totalSalesPiastres': instance.totalSalesPiastres,
      'invoicesCount': instance.invoicesCount,
      'totalReturnsPiastres': instance.totalReturnsPiastres,
    };

_CashSummary _$CashSummaryFromJson(Map<String, dynamic> json) => _CashSummary(
  availableCashPiastres: (json['availableCashPiastres'] as num).toInt(),
  totalCollectionsPiastres: (json['totalCollectionsPiastres'] as num).toInt(),
);

Map<String, dynamic> _$CashSummaryToJson(_CashSummary instance) =>
    <String, dynamic>{
      'availableCashPiastres': instance.availableCashPiastres,
      'totalCollectionsPiastres': instance.totalCollectionsPiastres,
    };

_GoldPrices _$GoldPricesFromJson(Map<String, dynamic> json) => _GoldPrices(
  karat18PricePerGramPiastres: (json['karat18PricePerGramPiastres'] as num)
      .toInt(),
  karat21PricePerGramPiastres: (json['karat21PricePerGramPiastres'] as num)
      .toInt(),
  karat24PricePerGramPiastres: (json['karat24PricePerGramPiastres'] as num)
      .toInt(),
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$GoldPricesToJson(_GoldPrices instance) =>
    <String, dynamic>{
      'karat18PricePerGramPiastres': instance.karat18PricePerGramPiastres,
      'karat21PricePerGramPiastres': instance.karat21PricePerGramPiastres,
      'karat24PricePerGramPiastres': instance.karat24PricePerGramPiastres,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_RecentOperation _$RecentOperationFromJson(Map<String, dynamic> json) =>
    _RecentOperation(
      id: json['id'] as String,
      type: $enumDecode(_$OperationTypeEnumMap, json['type']),
      description: json['description'] as String,
      amountPiastres: (json['amountPiastres'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$RecentOperationToJson(_RecentOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$OperationTypeEnumMap[instance.type]!,
      'description': instance.description,
      'amountPiastres': instance.amountPiastres,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$OperationTypeEnumMap = {
  OperationType.sale: 'sale',
  OperationType.installmentCollection: 'installment_collection',
  OperationType.approvalRequest: 'approval_request',
  OperationType.return_: 'return',
};

_BranchUpdate _$BranchUpdateFromJson(Map<String, dynamic> json) =>
    _BranchUpdate(
      branchId: json['branchId'] as String,
      sequence: (json['sequence'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sales: json['sales'] == null
          ? null
          : SalesSummary.fromJson(json['sales'] as Map<String, dynamic>),
      cash: json['cash'] == null
          ? null
          : CashSummary.fromJson(json['cash'] as Map<String, dynamic>),
      goldPrices: json['goldPrices'] == null
          ? null
          : GoldPrices.fromJson(json['goldPrices'] as Map<String, dynamic>),
      newOperation: json['newOperation'] == null
          ? null
          : RecentOperation.fromJson(
              json['newOperation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$BranchUpdateToJson(_BranchUpdate instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'sequence': instance.sequence,
      'timestamp': instance.timestamp.toIso8601String(),
      'sales': instance.sales,
      'cash': instance.cash,
      'goldPrices': instance.goldPrices,
      'newOperation': instance.newOperation,
    };
