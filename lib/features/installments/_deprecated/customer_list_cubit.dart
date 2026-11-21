import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CustomerListState {}

class CustomerListInitial extends CustomerListState {}

class CustomerListLoading extends CustomerListState {}

enum CustomerFilter {
  all, // الكل
  overdue, // متأخرين
  active, // نشط
  paid; // مسددين

  String get displayName {
    switch (this) {
      case CustomerFilter.all:
        return 'الكل';
      case CustomerFilter.overdue:
        return 'متأخرين';
      case CustomerFilter.active:
        return 'نشط';
      case CustomerFilter.paid:
        return 'مسددين';
    }
  }
}

class CustomerListLoaded extends CustomerListState {
  CustomerListLoaded(
    this.customers, {
    this.searchQuery = '',
    this.filter = CustomerFilter.all,
  });

  final List<CustomerDebt> customers;
  final String searchQuery;
  final CustomerFilter filter;

  List<CustomerDebt> get filteredCustomers {
    var filtered = customers;

    // Filter by status
    switch (filter) {
      case CustomerFilter.overdue:
        filtered = filtered.where((c) => c.hasOverdueDebts).toList();
        break;
      case CustomerFilter.active:
        filtered = filtered.where((c) => c.remainingPiastres > 0).toList();
        break;
      case CustomerFilter.paid:
        filtered = filtered.where((c) => c.remainingPiastres == 0).toList();
        break;
      case CustomerFilter.all:
        break;
    }

    // Filter by search
    if (searchQuery.isEmpty) return filtered;
    final query = searchQuery.toLowerCase();
    return filtered
        .where(
          (c) =>
              c.customerName.toLowerCase().contains(query) ||
              c.phone.contains(query) ||
              c.customerId.toLowerCase().contains(query),
        )
        .toList();
  }
}

class CustomerListError extends CustomerListState {
  CustomerListError(this.message);
  final String message;
}

class CustomerListCubit extends Cubit<CustomerListState> {
  CustomerListCubit(this._repo) : super(CustomerListInitial());

  final InstallmentRepository _repo;
  String _currentSearch = '';
  CustomerFilter _currentFilter = CustomerFilter.all;

  Future<void> loadCustomers() async {
    emit(CustomerListLoading());
    try {
      final customers = await _repo.fetchAllCustomers();
      emit(
        CustomerListLoaded(
          customers,
          searchQuery: _currentSearch,
          filter: _currentFilter,
        ),
      );
    } catch (e) {
      emit(CustomerListError(e.toString()));
    }
  }

  void search(String query) {
    _currentSearch = query;
    final current = state;
    if (current is CustomerListLoaded) {
      emit(
        CustomerListLoaded(
          current.customers,
          searchQuery: query,
          filter: current.filter,
        ),
      );
    }
  }

  void setFilter(CustomerFilter filter) {
    _currentFilter = filter;
    final current = state;
    if (current is CustomerListLoaded) {
      emit(
        CustomerListLoaded(
          current.customers,
          searchQuery: current.searchQuery,
          filter: filter,
        ),
      );
    }
  }

  Future<void> refresh() => loadCustomers();
}
