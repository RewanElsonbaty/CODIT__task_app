import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_approvals_api.dart';
import '../../../core/cache/cache_manager.dart';
import '../../../core/di/injection.dart';

class ApprovalsCubit extends Cubit<ApprovalsState> {
  final MockApprovalsApi _api = MockApprovalsApi();
  final CacheManager _cache = getIt<CacheManager>();

  ApprovalsCubit() : super(ApprovalsLoading()) {
    loadApprovals();
  }

  Future<void> loadApprovals() async {
    try {
      emit(ApprovalsLoading());
      
      // محاولة جلب من الكاش أولاً
      final cachedApprovals = await _cache.getCachedApprovals();
      if (cachedApprovals != null && cachedApprovals.isNotEmpty) {
        emit(ApprovalsLoaded(
          approvals: cachedApprovals,
          selectedFilter: 'الكل',
          isFromCache: true,
        ));
      }
      
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(milliseconds: 500));
      
      final approvals = await _api.getApprovals();
      
      // حفظ في الكاش
      await _cache.cacheApprovals(approvals);
      
      emit(ApprovalsLoaded(
        approvals: approvals,
        selectedFilter: 'الكل',
        isFromCache: false,
      ));
    } catch (e) {
      // في حالة الخطأ، نحاول جلب من الكاش
      final cachedApprovals = await _cache.getCachedApprovals();
      if (cachedApprovals != null && cachedApprovals.isNotEmpty) {
        emit(ApprovalsLoaded(
          approvals: cachedApprovals,
          selectedFilter: 'الكل',
          isFromCache: true,
        ));
      } else {
        emit(ApprovalsError(
          message: e.toString(),
          onRetry: loadApprovals,
        ));
      }
    }
  }

  void filterApprovals(String filter) {
    final currentState = state;
    if (currentState is! ApprovalsLoaded) return;

    emit(ApprovalsLoaded(
      approvals: currentState.approvals,
      selectedFilter: filter,
      isFromCache: currentState.isFromCache,
    ));
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
      emit(ApprovalsError(
        message: e.toString(),
        onRetry: loadApprovals,
      ));
    }
  }

  Future<void> rejectRequest(String requestId, String reason) async {
    try {
      await _api.rejectRequest(requestId, reason);
      await loadApprovals();
    } catch (e) {
      emit(ApprovalsError(
        message: e.toString(),
        onRetry: loadApprovals,
      ));
    }
  }
}

// States without Freezed
abstract class ApprovalsState {}

class ApprovalsLoading extends ApprovalsState {}

class ApprovalsLoaded extends ApprovalsState {
  final List<Map<String, dynamic>> approvals;
  final String selectedFilter;
  final bool isFromCache;

  ApprovalsLoaded({
    required this.approvals,
    required this.selectedFilter,
    this.isFromCache = false,
  });
}

class ApprovalsError extends ApprovalsState {
  final String message;
  final VoidCallback? onRetry;

  ApprovalsError({
    required this.message,
    this.onRetry,
  });
}
