import 'dart:async';
import 'dart:math';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/models/branch_summary.dart';
import '../../domain/models/branch_selection.dart';
import '../../domain/repositories/branch_dashboard_repository.dart';

/// Mock implementation of branch dashboard repository
/// 
/// Simulates real-time updates with sequence tracking
class BranchDashboardRepositoryImpl implements BranchDashboardRepository {
  final Map<String, BranchSummary> _cache = {};
  final Map<String, int> _currentSequences = {};
  final _random = Random();

  @override
  Future<Either<Failure, BranchSummary>> getBranchSnapshot({
    String? branchId,
  }) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final effectiveBranchId = branchId ?? 'all_branches';
      final summary = _generateSnapshot(effectiveBranchId);
      
      _currentSequences[effectiveBranchId] = summary.sequence;
      
      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(message: 'فشل تحميل البيانات'));
    }
  }

  @override
  Stream<Either<Failure, BranchUpdate>> watchBranchUpdates({
    String? branchId,
  }) {
    final effectiveBranchId = branchId ?? 'all_branches';
    
    // Generate updates every 5-10 seconds
    return Stream.periodic(
      Duration(seconds: 5 + _random.nextInt(5)),
      (count) {
        final currentSeq = _currentSequences[effectiveBranchId] ?? 0;
        final newSeq = currentSeq + 1;
        _currentSequences[effectiveBranchId] = newSeq;
        
        return Right(_generateUpdate(effectiveBranchId, newSeq));
      },
    );
  }

  @override
  Future<Either<Failure, List<BranchInfo>>> getAvailableBranches() async {
    await Future.delayed(Duration(milliseconds: 300));
    
    return Right([
      BranchInfo(
        id: 'cairo',
        name: 'فرع القاهرة',
        isActive: true,
      ),
      BranchInfo(
        id: 'alexandria',
        name: 'فرع الإسكندرية',
        isActive: true,
      ),
      BranchInfo(
        id: 'giza',
        name: 'فرع الجيزة',
        isActive: true,
      ),
    ]);
  }

  @override
  Future<void> cacheSnapshot(BranchSummary summary) async {
    _cache[summary.branchId] = summary;
  }

  @override
  Future<BranchSummary?> getCachedSnapshot({String? branchId}) async {
    final effectiveBranchId = branchId ?? 'all_branches';
    return _cache[effectiveBranchId];
  }

  // Helper: Generate initial snapshot
  BranchSummary _generateSnapshot(String branchId) {
    return BranchSummary(
      branchId: branchId,
      branchName: _getBranchName(branchId),
      sequence: 0,
      sales: SalesSummary(
        totalSalesPiastres: 10000000 + _random.nextInt(5000000), // 100k-150k EGP
        invoicesCount: 50 + _random.nextInt(50),
        totalReturnsPiastres: 500000 + _random.nextInt(500000), // 5k-10k EGP
      ),
      cash: CashSummary(
        availableCashPiastres: 5000000 + _random.nextInt(3000000), // 50k-80k EGP
        totalCollectionsPiastres: 8000000 + _random.nextInt(2000000), // 80k-100k EGP
      ),
      goldPrices: GoldPrices(
        karat18PricePerGramPiastres: 380000 + _random.nextInt(20000), // 3800-4000 EGP
        karat21PricePerGramPiastres: 420000 + _random.nextInt(20000), // 4200-4400 EGP
        karat24PricePerGramPiastres: 480000 + _random.nextInt(20000), // 4800-5000 EGP
        lastUpdated: DateTime.now().subtract(Duration(minutes: _random.nextInt(60))),
      ),
      recentOperations: _generateRecentOperations(5),
      lastUpdate: DateTime.now(),
    );
  }

  // Helper: Generate incremental update
  BranchUpdate _generateUpdate(String branchId, int sequence) {
    final updateType = _random.nextInt(4);

    switch (updateType) {
      case 0:
        // New sale
        return BranchUpdate(
          branchId: branchId,
          sequence: sequence,
          timestamp: DateTime.now(),
          sales: SalesSummary(
            totalSalesPiastres: 10000000 + _random.nextInt(1000000),
            invoicesCount: 50 + _random.nextInt(10),
            totalReturnsPiastres: 500000,
          ),
          newOperation: RecentOperation(
            id: 'op_$sequence',
            type: OperationType.sale,
            description: 'بيع ذهب عيار 21',
            amountPiastres: 50000 + _random.nextInt(100000),
            timestamp: DateTime.now(),
          ),
        );

      case 1:
        // Installment collection
        return BranchUpdate(
          branchId: branchId,
          sequence: sequence,
          timestamp: DateTime.now(),
          cash: CashSummary(
            availableCashPiastres: 5000000 + _random.nextInt(1000000),
            totalCollectionsPiastres: 8000000 + _random.nextInt(500000),
          ),
          newOperation: RecentOperation(
            id: 'op_$sequence',
            type: OperationType.installmentCollection,
            description: 'تحصيل قسط من عميل',
            amountPiastres: 20000 + _random.nextInt(50000),
            timestamp: DateTime.now(),
          ),
        );

      case 2:
        // Approval request
        return BranchUpdate(
          branchId: branchId,
          sequence: sequence,
          timestamp: DateTime.now(),
          newOperation: RecentOperation(
            id: 'op_$sequence',
            type: OperationType.approvalRequest,
            description: 'طلب موافقة على خصم',
            amountPiastres: 10000 + _random.nextInt(30000),
            timestamp: DateTime.now(),
          ),
        );

      default:
        // Gold price update
        return BranchUpdate(
          branchId: branchId,
          sequence: sequence,
          timestamp: DateTime.now(),
          goldPrices: GoldPrices(
            karat18PricePerGramPiastres: 380000 + _random.nextInt(20000),
            karat21PricePerGramPiastres: 420000 + _random.nextInt(20000),
            karat24PricePerGramPiastres: 480000 + _random.nextInt(20000),
            lastUpdated: DateTime.now(),
          ),
        );
    }
  }

  // Helper: Generate recent operations
  List<RecentOperation> _generateRecentOperations(int count) {
    return List.generate(count, (index) {
      final type = OperationType.values[_random.nextInt(4)];
      return RecentOperation(
        id: 'op_$index',
        type: type,
        description: _getOperationDescription(type),
        amountPiastres: 10000 + _random.nextInt(100000),
        timestamp: DateTime.now().subtract(Duration(minutes: index * 10)),
      );
    });
  }

  String _getBranchName(String branchId) {
    switch (branchId) {
      case 'all_branches':
        return 'كل الفروع';
      case 'cairo':
        return 'فرع القاهرة';
      case 'alexandria':
        return 'فرع الإسكندرية';
      case 'giza':
        return 'فرع الجيزة';
      default:
        return 'فرع غير معروف';
    }
  }

  String _getOperationDescription(OperationType type) {
    switch (type) {
      case OperationType.sale:
        return 'بيع ذهب عيار ${[18, 21, 24][_random.nextInt(3)]}';
      case OperationType.installmentCollection:
        return 'تحصيل قسط من عميل';
      case OperationType.approvalRequest:
        return 'طلب موافقة على خصم ${[10, 15, 20][_random.nextInt(3)]}%';
      case OperationType.return_:
        return 'إرجاع ذهب عيار 21';
    }
  }
}
