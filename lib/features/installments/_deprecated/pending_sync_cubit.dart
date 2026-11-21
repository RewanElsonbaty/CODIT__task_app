
import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class PendingSyncState {}

class PendingSyncInitial extends PendingSyncState {}

class PendingSyncLoading extends PendingSyncState {}

class PendingSyncReady extends PendingSyncState {
  PendingSyncReady(this.items, {this.conflictItems = const []});
  final List<Collection> items;
  final List<Collection> conflictItems;
  
  int get totalCount => items.length;
  int get conflictCount => conflictItems.length;
  bool get hasConflicts => conflictItems.isNotEmpty;
}

class PendingSyncError extends PendingSyncState {
  PendingSyncError(this.message);
  final String message;
}

class PendingSyncCubit extends Cubit<PendingSyncState> {
  PendingSyncCubit(this._repo) : super(PendingSyncInitial());

  final InstallmentRepository _repo;

  Future<void> load() async {
    emit(PendingSyncLoading());
    try {
      final items = await _repo.pendingCollections();
      
      // فصل العمليات المتعارضة
      final conflictItems = items.where((c) => c.syncStatus == 'conflict_review').toList();
      final regularItems = items.where((c) => c.syncStatus != 'conflict_review').toList();
      
      emit(PendingSyncReady(regularItems, conflictItems: conflictItems));
    } catch (e) {
      emit(PendingSyncError(e.toString()));
    }
  }

  Future<void> retrySync() async {
    try {
      await _repo.syncPending();
      await load();
    } catch (e) {
      emit(PendingSyncError('فشلت المزامنة: ${e.toString()}'));
      // Reload even on error to show current state
      await load();
    }
  }

  /// حل التعارض لعملية محددة
  Future<void> resolveConflict(String collectionId, ConflictResolutionAction action) async {
    try {
      await _repo.resolveConflict(collectionId, action);
      await load();
    } catch (e) {
      emit(PendingSyncError('فشل حل التعارض: ${e.toString()}'));
      await load();
    }
  }
}