import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CollectionFormState {}

class CollectionFormInitial extends CollectionFormState {}

class CollectionFormLoading extends CollectionFormState {}

class CollectionFormReady extends CollectionFormState {
  CollectionFormReady(this.data);
  final Map<String, dynamic> data;
}

class CollectionFormSubmitting extends CollectionFormState {}

class CollectionFormSuccess extends CollectionFormState {
  CollectionFormSuccess(this.collectionId);
  final String collectionId;
}

class CollectionFormError extends CollectionFormState {
  CollectionFormError(this.message);
  final String message;
}

class CollectionFormCubit extends Cubit<CollectionFormState> {
  CollectionFormCubit(this._repo) : super(CollectionFormInitial());

  final InstallmentRepository _repo;

  Future<void> loadCustomerDebts(String customerId) async {
    emit(CollectionFormLoading());
    try {
      final data = await _repo.fetchCustomerDebts(customerId);
      emit(CollectionFormReady(data));
    } catch (e) {
      emit(CollectionFormError(e.toString()));
    }
  }

  Future<void> submitCollection({
    required String customerId,
    required String customerName,
    required int amountPiastres,
    required String paymentMethod,
    String? notes,
  }) async {
    emit(CollectionFormSubmitting());
    try {
      final collectionId = await _repo.collectOffline(
        customerId: customerId,
        customerName: customerName,
        amountPiastres: amountPiastres,
        paymentMethod: paymentMethod,
        notes: notes,
      );
      emit(CollectionFormSuccess(collectionId));
    } catch (e) {
      emit(CollectionFormError(e.toString()));
    }
  }
}
