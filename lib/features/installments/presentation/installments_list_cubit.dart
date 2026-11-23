import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/mock_installments_api.dart';

part 'installments_list_cubit.freezed.dart';

class InstallmentsListCubit extends Cubit<InstallmentsListState> {
  final MockInstallmentsApi _api = MockInstallmentsApi();

  InstallmentsListCubit() : super(const InstallmentsListState.loading()) {
    loadInstallments();
  }

  Future<void> loadInstallments() async {
    try {
      emit(const InstallmentsListState.loading());
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final installments = await _api.getCustomers();
      
      emit(InstallmentsListState.loaded(
        installments: installments,
        selectedFilter: 'الكل',
      ));
    } catch (e) {
      emit(InstallmentsListState.error(message: e.toString()));
    }
  }

  void filterInstallments(String filter) {
    final currentState = state;
    if (currentState is! InstallmentsListLoaded) return;

    emit(currentState.copyWith(selectedFilter: filter));
  }

  List<Map<String, dynamic>> getFilteredInstallments() {
    final currentState = state;
    if (currentState is! InstallmentsListLoaded) return [];

    final filter = currentState.selectedFilter;
    final installments = currentState.installments;

    if (filter == 'الكل') return installments;

    // فلترة حسب الحالة
    return installments.where((inst) {
      final overdueDebt = inst['overdue_debt'] ?? 0.0;
      final totalDebt = inst['total_debt'] ?? 0.0;

      switch (filter) {
        case 'نشط':
          return totalDebt > 0 && overdueDebt == 0;
        case 'متأخر':
          return overdueDebt > 0;
        case 'مكتمل':
          return totalDebt == 0;
        default:
          return true;
      }
    }).toList();
  }

  int getActiveCount() {
    final currentState = state;
    if (currentState is! InstallmentsListLoaded) return 0;
    
    return currentState.installments.where((inst) {
      final overdueDebt = inst['overdue_debt'] ?? 0.0;
      final totalDebt = inst['total_debt'] ?? 0.0;
      return totalDebt > 0 && overdueDebt == 0;
    }).length;
  }

  int getOverdueCount() {
    final currentState = state;
    if (currentState is! InstallmentsListLoaded) return 0;
    
    return currentState.installments.where((inst) {
      final overdueDebt = inst['overdue_debt'] ?? 0.0;
      return overdueDebt > 0;
    }).length;
  }

  double getTotalRemaining() {
    final currentState = state;
    if (currentState is! InstallmentsListLoaded) return 0.0;
    
    return currentState.installments.fold<double>(
      0.0,
      (sum, inst) => sum + (inst['total_debt'] ?? 0.0),
    );
  }
}

@freezed
class InstallmentsListState with _$InstallmentsListState {
  const factory InstallmentsListState.loading() = InstallmentsListLoading;
  
  const factory InstallmentsListState.loaded({
    required List<Map<String, dynamic>> installments,
    required String selectedFilter,
  }) = InstallmentsListLoaded;
  
  const factory InstallmentsListState.error({required String message}) = InstallmentsListError;
}
