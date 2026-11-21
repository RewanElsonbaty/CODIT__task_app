import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:codit/features/approvals/data/approval_repository.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';

/// حالات قائمة الموافقات
sealed class ApprovalInboxState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApprovalInboxInitial extends ApprovalInboxState {}

class ApprovalInboxLoading extends ApprovalInboxState {}

class ApprovalInboxLoaded extends ApprovalInboxState {
  ApprovalInboxLoaded({
    required this.approvals,
    required this.stats,
    required this.selectedFilter,
  });

  final List<ApprovalSummary> approvals;
  final ApprovalStats stats;
  final ApprovalStatus? selectedFilter;

  @override
  List<Object?> get props => [approvals, stats, selectedFilter];
}

class ApprovalInboxError extends ApprovalInboxState {
  ApprovalInboxError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Cubit لقائمة الموافقات
class ApprovalInboxCubit extends Cubit<ApprovalInboxState> {
  ApprovalInboxCubit(this._repository) : super(ApprovalInboxInitial());

  final ApprovalRepository _repository;
  ApprovalStatus? _currentFilter;

  /// تحميل قائمة الموافقات
  Future<void> loadApprovals() async {
    emit(ApprovalInboxLoading());

    try {
      // جلب الموافقات والإحصائيات بالتوازي
      final results = await Future.wait([
        _repository.fetchApprovals(status: _currentFilter),
        _repository.fetchStats(),
      ]);

      final approvals = results[0] as List<ApprovalSummary>;
      final stats = results[1] as ApprovalStats;

      emit(
        ApprovalInboxLoaded(
          approvals: approvals,
          stats: stats,
          selectedFilter: _currentFilter,
        ),
      );
    } catch (e) {
      emit(ApprovalInboxError(e.toString()));
    }
  }

  /// تصفية حسب الحالة
  Future<void> filterByStatus(ApprovalStatus? status) async {
    _currentFilter = status;
    await loadApprovals();
  }

  /// تحديث
  Future<void> refresh() => loadApprovals();
}
