import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/mock_approvals_api.dart';

part 'approvals_cubit.freezed.dart';

class ApprovalsCubit extends Cubit<ApprovalsState> {
  final MockApprovalsApi _api = MockApprovalsApi();

  ApprovalsCubit() : super(const ApprovalsState.loading()) {
    loadApprovals();
  }

  Future<void> loadApprovals() async {
    try {
      emit(const ApprovalsState.loading());
      
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(milliseconds: 500));
      
      final approvals = await _api.getApprovals();
      
      emit(ApprovalsState.loaded(
        approvals: approvals,
        selectedFilter: 'الكل',
      ));
    } catch (e) {
      emit(ApprovalsState.error(message: e.toString()));
    }
  }

  void filterApprovals(String filter) {
    final currentState = state;
    if (currentState is! ApprovalsLoaded) return;

    emit(currentState.copyWith(selectedFilter: filter));
  }

  List<Map<String, dynamic>> getFilteredApprovals() {
    final currentState = state;
    if (currentState is! ApprovalsLoaded) return [];

    final filter = currentState.selectedFilter;
    final approvals = currentState.approvals;

    if (filter == 'الكل') return approvals;

    String statusFilter;
    switch (filter) {
      case 'قيد الانتظار':
        statusFilter = 'pending';
        break;
      case 'موافق عليها':
        statusFilter = 'approved';
        break;
      case 'مرفوضة':
        statusFilter = 'rejected';
        break;
      default:
        return approvals;
    }

    return approvals.where((a) => a['status'] == statusFilter).toList();
  }

  Future<void> approveRequest(String requestId) async {
    try {
      await _api.approveRequest(requestId);
      await loadApprovals();
    } catch (e) {
      emit(ApprovalsState.error(message: e.toString()));
    }
  }

  Future<void> rejectRequest(String requestId, String reason) async {
    try {
      await _api.rejectRequest(requestId, reason);
      await loadApprovals();
    } catch (e) {
      emit(ApprovalsState.error(message: e.toString()));
    }
  }
}

@freezed
class ApprovalsState with _$ApprovalsState {
  const factory ApprovalsState.loading() = ApprovalsLoading;
  
  const factory ApprovalsState.loaded({
    required List<Map<String, dynamic>> approvals,
    required String selectedFilter,
  }) = ApprovalsLoaded;
  
  const factory ApprovalsState.error({required String message}) = ApprovalsError;
}
