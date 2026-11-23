import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../domain/models/branch_summary.dart';
import '../domain/models/branch_selection.dart';
import '../domain/repositories/branch_dashboard_repository.dart';

/// Cubit for branch dashboard with real-time updates and sequence tracking
class BranchDashboardCubit extends Cubit<BranchDashboardState> {
  final BranchDashboardRepository _repository;
  
  StreamSubscription<Either<Failure, BranchUpdate>>? _updatesSubscription;
  
  // Track current sequence to prevent duplicates and detect gaps
  int? _currentSequence;
  
  // Track current branch to ignore stale responses
  String? _currentBranchId;

  BranchDashboardCubit(this._repository)
      : super(BranchDashboardLoading());

  /// Initialize dashboard with selected branch
  Future<void> initialize({String? branchId}) async {
    emit(BranchDashboardLoading());
    
    _currentBranchId = branchId;
    await _cancelCurrentSubscription();
    
    await _loadSnapshot(branchId);
  }

  /// Change selected branch
  Future<void> changeBranch(BranchSelection selection) async {
    final newBranchId = selection.branchId;
    
    // Ignore if already on this branch
    if (newBranchId == _currentBranchId) return;
    
    emit(BranchDashboardLoading());
    
    _currentBranchId = newBranchId;
    await _cancelCurrentSubscription();
    
    await _loadSnapshot(newBranchId);
  }

  /// Refresh current branch data
  Future<void> refresh() async {
    final currentBranchId = _currentBranchId;
    
    emit(BranchDashboardLoading());
    await _cancelCurrentSubscription();
    
    await _loadSnapshot(currentBranchId);
  }

  /// Load full snapshot and start listening to updates
  Future<void> _loadSnapshot(String? branchId) async {
    final result = await _repository.getBranchSnapshot(branchId: branchId);
    
    result.fold(
      (failure) async {
        // Try to load from cache on failure
        final cached = await _repository.getCachedSnapshot(branchId: branchId);
        
        if (cached != null) {
          emit(BranchDashboardOffline(
            summary: cached,
            lastUpdate: cached.lastUpdate,
          ));
        } else {
          emit(BranchDashboardError(message: failure.message));
        }
      },
      (summary) {
        // Check if this response is for the current branch
        // If branch changed during request, ignore this response
        if (_shouldIgnoreResponse(summary.branchId, branchId)) {
          return;
        }
        
        _currentSequence = summary.sequence;
        
        // Cache for offline access
        _repository.cacheSnapshot(summary);
        
        emit(BranchDashboardLoaded(summary: summary));
        
        // Start listening to updates
        _startListeningToUpdates(branchId);
      },
    );
  }

  /// Start listening to real-time updates
  void _startListeningToUpdates(String? branchId) {
    _updatesSubscription = _repository
        .watchBranchUpdates(branchId: branchId)
        .listen(
          (result) => result.fold(
            (failure) {
              // Log error but don't change state
              // Dashboard remains functional with last known data
            },
            (update) => _handleUpdate(update, branchId),
          ),
        );
  }

  /// Handle incoming update with sequence validation
  void _handleUpdate(BranchUpdate update, String? expectedBranchId) {
    // Ignore updates for different branch
    if (_shouldIgnoreResponse(update.branchId, expectedBranchId)) {
      return;
    }
    
    final currentState = state;
    if (currentState is! BranchDashboardLoaded) return;
    
    final currentSummary = currentState.summary;
    
    // Sequence validation
    if (_currentSequence == null) {
      // First update, accept it
      _currentSequence = update.sequence;
    } else if (update.sequence <= _currentSequence!) {
      // Duplicate or old update, ignore
      return;
    } else if (update.sequence > _currentSequence! + 1) {
      // Sequence gap detected! Request new snapshot
      _handleSequenceGap(expectedBranchId);
      return;
    } else {
      // Expected next sequence
      _currentSequence = update.sequence;
    }
    
    // Apply update
    final updatedSummary = _applyUpdate(currentSummary, update);
    
    // Cache updated data
    _repository.cacheSnapshot(updatedSummary);
    
    emit(BranchDashboardLoaded(summary: updatedSummary));
  }

  /// Apply incremental update to current summary
  BranchSummary _applyUpdate(BranchSummary current, BranchUpdate update) {
    return current.copyWith(
      sequence: update.sequence,
      sales: update.sales ?? current.sales,
      cash: update.cash ?? current.cash,
      goldPrices: update.goldPrices ?? current.goldPrices,
      recentOperations: update.newOperation != null
          ? [update.newOperation!, ...current.recentOperations].take(10).toList()
          : current.recentOperations,
      lastUpdate: update.timestamp,
    );
  }

  /// Handle sequence gap by requesting new snapshot
  void _handleSequenceGap(String? branchId) {
    // Request new snapshot in background
    _loadSnapshot(branchId);
  }

  /// Check if response should be ignored (branch changed)
  bool _shouldIgnoreResponse(String responseBranchId, String? expectedBranchId) {
    // If expected is null (all branches), response should also be for all branches
    // In real implementation, you'd have a special ID for "all branches"
    if (expectedBranchId == null) {
      return responseBranchId != 'all_branches'; // Convention
    }
    
    return responseBranchId != expectedBranchId;
  }

  /// Cancel current updates subscription
  Future<void> _cancelCurrentSubscription() async {
    await _updatesSubscription?.cancel();
    _updatesSubscription = null;
    _currentSequence = null;
  }

  @override
  Future<void> close() {
    _cancelCurrentSubscription();
    return super.close();
  }
}

/// Branch dashboard state
abstract class BranchDashboardState {}

/// Loading initial data
class BranchDashboardLoading extends BranchDashboardState {}

/// Data loaded and actively receiving updates
class BranchDashboardLoaded extends BranchDashboardState {
  final BranchSummary summary;
  BranchDashboardLoaded({required this.summary});
}

/// Offline mode - showing cached data
class BranchDashboardOffline extends BranchDashboardState {
  final BranchSummary summary;
  final DateTime lastUpdate;
  BranchDashboardOffline({required this.summary, required this.lastUpdate});
}

/// Error loading data
class BranchDashboardError extends BranchDashboardState {
  final String message;
  BranchDashboardError({required this.message});
}

/// No data available
class BranchDashboardEmpty extends BranchDashboardState {}
