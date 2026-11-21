import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class InstallmentsState {}

class InstallmentsInitial extends InstallmentsState {}

class InstallmentsLoading extends InstallmentsState {}

class InstallmentsReady extends InstallmentsState {
  InstallmentsReady(this.data);
  final Map<String, dynamic> data;
}

class InstallmentsError extends InstallmentsState {
  InstallmentsError(this.message);
  final String message;
}

class InstallmentsCubit extends Cubit<InstallmentsState> {
  InstallmentsCubit(this._repo) : super(InstallmentsInitial());

  final InstallmentRepository _repo;

  Future<void> load(String customerId) async {
    emit(InstallmentsLoading());
    try {
      final data = await _repo.fetchCustomerDebts(customerId);
      emit(InstallmentsReady(data));
    } catch (e) {
      emit(InstallmentsError(e.toString()));
    }
  }

  Future<void> collect({
    required String customerId,
    required String customerName,
    required int piastres,
    required String method,
  }) async {
    try {
      await _repo.collectOffline(
        customerId: customerId,
        customerName: customerName,
        amountPiastres: piastres,
        paymentMethod: method,
      );
      await load(customerId);
    } catch (e) {
      emit(InstallmentsError(e.toString()));
    }
  }
}