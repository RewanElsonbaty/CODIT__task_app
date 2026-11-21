import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/widgets/app_empty_state.dart';
import 'package:codit/core/widgets/app_error_view.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/features/installments/presentation/customer_list_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/customer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:codit/features/installments/presentation/customer_list_cubit.dart'
    show CustomerFilter;

class CustomerListBody extends StatefulWidget {
  const CustomerListBody({super.key});

  @override
  State<CustomerListBody> createState() => _CustomerListBodyState();
}

class _CustomerListBodyState extends State<CustomerListBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerListCubit, CustomerListState>(
      builder: (context, state) {
        if (state is CustomerListLoading) {
          return const AppLoading();
        }

        if (state is CustomerListError) {
          return AppErrorView(
            message: state.message,
            onRetry: () => context.read<CustomerListCubit>().loadCustomers(),
          );
        }

        if (state is CustomerListLoaded) {
          return Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        context.read<CustomerListCubit>().search(value);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'ابحث بالاسم أو رقم الهاتف...',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<CustomerListCubit>().search('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: CustomerFilter.values.map((filter) {
                          final isSelected = state.filter == filter;
                          Color chipColor;

                          switch (filter) {
                            case CustomerFilter.all:
                              chipColor = AppColors.primary;
                              break;
                            case CustomerFilter.overdue:
                              chipColor = AppColors.errorDark;
                              break;
                            case CustomerFilter.active:
                              chipColor = AppColors.successDark;
                              break;
                            case CustomerFilter.paid:
                              chipColor = AppColors.infoDark;
                              break;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: isSelected,
                              label: Text(filter.displayName),
                              onSelected: (_) {
                                context.read<CustomerListCubit>().setFilter(
                                  filter,
                                );
                              },
                              backgroundColor: AppColors.background,
                              selectedColor: chipColor.withOpacity(0.2),
                              side: BorderSide(
                                color: isSelected
                                    ? chipColor
                                    : AppColors.border.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? chipColor
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              checkmarkColor: chipColor,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Results Count
              if (state.filteredCustomers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.filteredCustomers.length} عميل',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              // Customer List
              Expanded(
                child: state.filteredCustomers.isEmpty
                    ? const AppEmptyState(
                        icon: Icons.search_off,
                        title: 'لا توجد نتائج',
                        message: 'جرب تغيير كلمات البحث',
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<CustomerListCubit>().refresh(),
                        backgroundColor: AppColors.card,
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = state.filteredCustomers[index];
                            return CustomerCard(customer: customer);
                          },
                        ),
                      ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
