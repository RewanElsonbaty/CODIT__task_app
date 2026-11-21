import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/branch_summary.dart';
import '../models/branch_selection.dart';

/// Repository for branch dashboard data with real-time updates
abstract class BranchDashboardRepository {
  /// Get initial snapshot of branch data
  /// 
  /// Returns full data with current sequence number
  Future<Either<Failure, BranchSummary>> getBranchSnapshot({
    String? branchId, // null = all branches
  });

  /// Stream of incremental updates for a branch
  /// 
  /// Each update contains a sequence number to prevent duplicates
  /// If a sequence gap is detected, client should request a new snapshot
  Stream<Either<Failure, BranchUpdate>> watchBranchUpdates({
    String? branchId, // null = all branches
  });

  /// Get list of available branches
  Future<Either<Failure, List<BranchInfo>>> getAvailableBranches();

  /// Save snapshot to local cache for offline access
  Future<void> cacheSnapshot(BranchSummary summary);

  /// Get cached snapshot (for offline mode)
  Future<BranchSummary?> getCachedSnapshot({String? branchId});
}
