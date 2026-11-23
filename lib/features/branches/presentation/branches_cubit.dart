import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_branches_api.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final MockBranchesApi _api = MockBranchesApi();

  BranchesCubit() : super(BranchesLoading()) {
    loadBranches();
  }

  Future<void> loadBranches() async {
    try {
      emit(BranchesLoading());
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final branches = await _api.getBranches();
      final stats = await _api.getTodayStatistics();
      
      emit(BranchesLoaded(
        branches: branches,
        statistics: stats,
      ));
    } catch (e) {
      emit(BranchesError(
        message: e.toString(),
        onRetry: loadBranches,
      ));
    }
  }

  Future<void> refreshBranches() async {
    final currentState = state;
    if (currentState is! BranchesLoaded) return;

    try {
      // تحديث كل الفروع
      for (var branch in currentState.branches) {
        await _api.refreshBranchData(branch['id']);
      }
      
      await loadBranches();
    } catch (e) {
      emit(BranchesError(
        message: e.toString(),
        onRetry: refreshBranches,
      ));
    }
  }

  int getActiveBranchesCount() {
    final currentState = state;
    if (currentState is! BranchesLoaded) return 0;
    
    return currentState.branches.where((b) => b['status'] == 'نشط').length;
  }

  double getTotalSales() {
    final currentState = state;
    if (currentState is! BranchesLoaded) return 0.0;
    
    return currentState.branches.fold<double>(
      0.0,
      (sum, b) => sum + (b['today_sales'] as double),
    );
  }

  int getTotalTransactions() {
    final currentState = state;
    if (currentState is! BranchesLoaded) return 0;
    
    return currentState.branches.fold<int>(
      0,
      (sum, b) => sum + (b['today_transactions'] as int),
    );
  }
}

// States without Freezed
abstract class BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesLoaded extends BranchesState {
  final List<Map<String, dynamic>> branches;
  final Map<String, dynamic> statistics;

  BranchesLoaded({
    required this.branches,
    required this.statistics,
  });
}

class BranchesError extends BranchesState {
  final String message;
  final VoidCallback? onRetry;

  BranchesError({
    required this.message,
    this.onRetry,
  });
}
