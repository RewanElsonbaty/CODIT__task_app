import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/mock_branches_api.dart';

part 'branches_cubit.freezed.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final MockBranchesApi _api = MockBranchesApi();

  BranchesCubit() : super(const BranchesState.loading()) {
    loadBranches();
  }

  Future<void> loadBranches() async {
    try {
      emit(const BranchesState.loading());
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final branches = await _api.getBranches();
      final stats = await _api.getTodayStatistics();
      
      emit(BranchesState.loaded(
        branches: branches,
        statistics: stats,
      ));
    } catch (e) {
      emit(BranchesState.error(message: e.toString()));
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
      emit(BranchesState.error(message: e.toString()));
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

@freezed
class BranchesState with _$BranchesState {
  const factory BranchesState.loading() = BranchesLoading;
  
  const factory BranchesState.loaded({
    required List<Map<String, dynamic>> branches,
    required Map<String, dynamic> statistics,
  }) = BranchesLoaded;
  
  const factory BranchesState.error({required String message}) = BranchesError;
}
