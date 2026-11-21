import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SyncStatusState {}

class SyncStatusInitial extends SyncStatusState {}

class SyncStatusLoading extends SyncStatusState {}

class SyncStatusLoaded extends SyncStatusState {
  SyncStatusLoaded(this.collections);
  final List<Collection> collections;

  int get totalPending => collections.length;
  int get needsReview => collections.where((c) => c.needsReview).length;
  int get failed => collections.where((c) => c.hasFailed).length;
}

class SyncStatusSyncing extends SyncStatusState {
  SyncStatusSyncing(this.collections);
  final List<Collection> collections;
}

class SyncStatusError extends SyncStatusState {
  SyncStatusError(this.message);
  final String message;
}

class SyncStatusCubit extends Cubit<SyncStatusState> {
  SyncStatusCubit(this._repo) : super(SyncStatusInitial());

  final InstallmentRepository _repo;

  Future<void> loadPending() async {
    emit(SyncStatusLoading());
    try {
      final collections = await _repo.pendingCollections();
      emit(SyncStatusLoaded(collections));
    } catch (e) {
      emit(SyncStatusError(e.toString()));
    }
  }

  Future<void> syncAll() async {
    final current = state;
    if (current is! SyncStatusLoaded) return;
    
    emit(SyncStatusSyncing(current.collections));
    try {
      await _repo.syncPending();
      await loadPending();
    } catch (e) {
      emit(SyncStatusError(e.toString()));
    }
  }

  Future<void> resolveConflict(String collectionId, ConflictResolutionAction action) async {
    try {
      await _repo.resolveConflict(collectionId, action);
      await loadPending();
    } catch (e) {
      emit(SyncStatusError(e.toString()));
    }
  }

  Future<void> refresh() => loadPending();
}
