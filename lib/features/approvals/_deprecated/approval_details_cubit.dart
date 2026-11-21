import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:codit/features/approvals/data/approval_repository.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';

/// حالات تفاصيل الموافقة
sealed class ApprovalDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApprovalDetailsInitial extends ApprovalDetailsState {}

class ApprovalDetailsLoading extends ApprovalDetailsState {}

class ApprovalDetailsLoaded extends ApprovalDetailsState {
  ApprovalDetailsLoaded({
    required this.approval,
    this.isRefreshing = false,
    this.isSubmitting = false,
  });

  final ApprovalDetail approval;
  final bool isRefreshing;
  final bool isSubmitting;

  ApprovalDetailsLoaded copyWith({
    ApprovalDetail? approval,
    bool? isRefreshing,
    bool? isSubmitting,
  }) {
    return ApprovalDetailsLoaded(
      approval: approval ?? this.approval,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [approval, isRefreshing, isSubmitting];
}

class ApprovalDetailsDecisionSent extends ApprovalDetailsState {
  ApprovalDetailsDecisionSent({
    required this.approval,
    required this.wasApproved,
  });

  final ApprovalDetail approval;
  final bool wasApproved;

  @override
  List<Object?> get props => [approval, wasApproved];
}

class ApprovalDetailsUnknownResult extends ApprovalDetailsState {
  ApprovalDetailsUnknownResult({
    required this.requestId,
    required this.message,
  });

  final String requestId;
  final String message;

  @override
  List<Object?> get props => [requestId, message];
}

class ApprovalDetailsError extends ApprovalDetailsState {
  ApprovalDetailsError(this.message, {this.canRetry = false});
  final String message;
  final bool canRetry;

  @override
  List<Object?> get props => [message, canRetry];
}

/// Cubit لتفاصيل الموافقة
class ApprovalDetailsCubit extends Cubit<ApprovalDetailsState> {
  ApprovalDetailsCubit(this._repository) : super(ApprovalDetailsInitial());

  final ApprovalRepository _repository;
  final _uuid = const Uuid();

  // لمنع الضغط المتكرر
  bool _isProcessing = false;
  Timer? _debounceTimer;

  /// تحميل تفاصيل الموافقة مع Retry
  Future<void> loadApproval(String id, {int retryCount = 0}) async {
    emit(ApprovalDetailsLoading());

    try {
      final approval = await _repository.fetchApprovalDetail(id);
      emit(ApprovalDetailsLoaded(approval: approval));
    } catch (e) {
      // Retry Logic: نحاول 3 مرات مع تأخير متصاعد
      if (retryCount < 3) {
        await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
        return loadApproval(id, retryCount: retryCount + 1);
      }
      emit(ApprovalDetailsError(e.toString(), canRetry: true));
    }
  }

  /// Refresh (للـ Pull-to-Refresh)
  Future<void> refresh() async {
    final current = state;
    if (current is ApprovalDetailsLoaded) {
      await loadApproval(current.approval.id);
    }
  }

  /// تحديث التفاصيل قبل القرار
  Future<void> refreshBeforeDecision() async {
    final current = state;
    if (current is! ApprovalDetailsLoaded) return;

    emit(current.copyWith(isRefreshing: true));

    try {
      final updated = await _repository.refreshApprovalDetail(
        current.approval.id,
      );

      // التحقق من تغير الإصدار
      if (updated.version != current.approval.version) {
        emit(
          ApprovalDetailsError(
            'تم تحديث الطلب من جهاز آخر. الرجاء مراجعة التفاصيل الجديدة.',
          ),
        );
        emit(ApprovalDetailsLoaded(approval: updated));
        return;
      }

      emit(ApprovalDetailsLoaded(approval: updated));
    } catch (e) {
      emit(ApprovalDetailsError('فشل تحديث التفاصيل: $e'));
    }
  }

  /// الموافقة على الطلب
  Future<void> approve() async {
    await _submitDecision(approved: true);
  }

  /// رفض الطلب
  Future<void> reject(String reason) async {
    await _submitDecision(approved: false, rejectionReason: reason);
  }

  /// إرسال القرار
  Future<void> _submitDecision({
    required bool approved,
    String? rejectionReason,
  }) async {
    final current = state;
    if (current is! ApprovalDetailsLoaded) return;

    // 1️⃣ منع الضغط المتكرر
    if (_isProcessing) {
      emit(ApprovalDetailsError('جاري معالجة الطلب، الرجاء الانتظار'));
      return;
    }

    _isProcessing = true;

    // إلغاء أي debounce سابق
    _debounceTimer?.cancel();

    emit(current.copyWith(isSubmitting: true));

    try {
      // 2️⃣ تحديث التفاصيل أولاً
      final updated = await _repository.refreshApprovalDetail(
        current.approval.id,
      );

      // التحقق من الإصدار
      if (updated.version != current.approval.version) {
        _isProcessing = false;
        emit(
          ApprovalDetailsError(
            'تم تحديث الطلب. الرجاء مراجعة التفاصيل الجديدة.',
          ),
        );
        emit(ApprovalDetailsLoaded(approval: updated));
        return;
      }

      // التحقق من الحالة
      if (updated.status != ApprovalStatus.pending) {
        _isProcessing = false;
        emit(
          ApprovalDetailsError(
            'تم معالجة هذا الطلب من قبل: ${updated.status.displayName}',
          ),
        );
        emit(ApprovalDetailsLoaded(approval: updated));
        return;
      }

      // 3️⃣ إنشاء القرار مع Idempotency Key
      final decision = ApprovalDecision(
        idempotencyKey: _uuid.v4(),
        requestId: updated.id,
        requestVersion: updated.version,
        approved: approved,
        rejectionReason: rejectionReason,
        timestamp: DateTime.now(),
      );

      // 4️⃣ إرسال القرار
      final result = await _repository.sendDecision(decision);

      _isProcessing = false;

      emit(
        ApprovalDetailsDecisionSent(approval: result, wasApproved: approved),
      );
    } on UnknownDecisionException catch (e) {
      // النتيجة غير مؤكدة
      _isProcessing = false;
      emit(
        ApprovalDetailsUnknownResult(
          requestId: current.approval.id,
          message: e.message,
        ),
      );
    } catch (e) {
      _isProcessing = false;
      emit(ApprovalDetailsError(e.toString()));
      // نعيد الحالة المحملة
      emit(current.copyWith(isSubmitting: false));
    }
  }

  /// التحقق من حالة الطلب (بعد Unknown)
  Future<void> checkStatus(String requestId) async {
    emit(ApprovalDetailsLoading());

    try {
      final approval = await _repository.checkRequestStatus(requestId);
      emit(ApprovalDetailsLoaded(approval: approval));
    } catch (e) {
      emit(ApprovalDetailsError('فشل التحقق من الحالة: $e'));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
