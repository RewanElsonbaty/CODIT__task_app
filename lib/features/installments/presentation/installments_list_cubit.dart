import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_installments_api.dart';

class InstallmentsListCubit extends Cubit<InstallmentsListState> {
  final MockInstallmentsApi _api = MockInstallmentsApi();

  InstallmentsListCubit() : super(InstallmentsListLoading()) {
    loadInstallments();
  }

  Future<void> loadInstallments() async {
    try {
      emit(InstallmentsListLoading());
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final installments = await _api.getCustomers();
      
      emit(InstallmentsListLoaded(
        installments: installments,
        selectedFilter: 'الكل',
      ));
    } catch (e) {
      emit(InstallmentsListError(
        message: e.toString(),
        onRetry: loadInstallments,
      ));
    }
  }

  void filterInstallments(String filter) {
    final currentState = state;
    if (currentState is! InstallmentsListLoaded) return;

    emit(InstallmentsListLoaded(
      installments: currentState.installments,
      selectedFilter: filter,
    ));
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

// States without Freezed
abstract class InstallmentsListState {}

class InstallmentsListLoading extends InstallmentsListState {}

class InstallmentsListLoaded extends InstallmentsListState {
  final List<Map<String, dynamic>> installments;
  final String selectedFilter;

  InstallmentsListLoaded({
    required this.installments,
    required this.selectedFilter,
  });
}

class InstallmentsListError extends InstallmentsListState {
  final String message;
  final VoidCallback? onRetry;

  InstallmentsListError({
    required this.message,
    this.onRetry,
  });
}
