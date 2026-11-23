import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shimmer_loading.dart';
import 'installments_list_cubit.dart';

class InstallmentsSimplePage extends StatelessWidget {
  const InstallmentsSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InstallmentsListCubit(),
      child: const _InstallmentsPageContent(),
    );
  }
}

class _InstallmentsPageContent extends StatelessWidget {
  const _InstallmentsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.3),
                    Colors.green.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.payment,
                size: 24,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'الأقساط',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.goldenNeon),
            onPressed: () => context.go('/home'),
            tooltip: 'الصفحة الرئيسية',
          ),
          BlocBuilder<InstallmentsListCubit, InstallmentsListState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.bar_chart, color: AppColors.goldenNeon),
                onPressed: () {
                  if (state is InstallmentsListLoaded) {
                    _showStatistics(context, state.installments);
                  }
                },
                tooltip: 'الإحصائيات',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<InstallmentsListCubit, InstallmentsListState>(
        builder: (context, state) {
          if (state is InstallmentsListLoading) {
            return const ShimmerInstallmentsList();
          } else if (state is InstallmentsListLoaded) {
            final cubit = context.read<InstallmentsListCubit>();
            final filteredInstallments = cubit.getFilteredInstallments();

            return Column(
              children: [
                // فلاتر
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.card,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(context, 'الكل', state.selectedFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip(context, 'نشط', state.selectedFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip(context, 'متأخر', state.selectedFilter),
                        const SizedBox(width: 8),
                        _buildFilterChip(context, 'مكتمل', state.selectedFilter),
                      ],
                    ),
                  ),
                ),

                // ملخص سريع
                _buildSummaryCards(context, cubit),

                // قائمة الأقساط
                Expanded(
                  child: filteredInstallments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد أقساط',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => cubit.loadInstallments(),
                          color: Colors.green,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredInstallments.length,
                            itemBuilder: (context, index) {
                              final customer = filteredInstallments[index];
                              return _buildCustomerCard(customer);
                            },
                          ),
                        ),
                ),
              ],
            );
          } else if (state is InstallmentsListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: AppColors.errorLight),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ: ${state.message}',
                    style: const TextStyle(color: AppColors.errorLight),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: state.onRetry ?? () => context.read<InstallmentsListCubit>().loadInstallments(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إضافة قسط جديد')),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('قسط جديد'),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String selectedFilter) {
    final isSelected = selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        context.read<InstallmentsListCubit>().filterInstallments(label);
      },
      selectedColor: Colors.green.withOpacity(0.3),
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, InstallmentsListCubit cubit) {
    final activeCount = cubit.getActiveCount();
    final overdueCount = cubit.getOverdueCount();
    final totalAmount = cubit.getTotalRemaining();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'نشط',
              activeCount.toString(),
              Colors.green,
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'متأخر',
              overdueCount.toString(),
              Colors.red,
              Icons.warning,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'المتبقي',
              '${totalAmount.toInt()} ج',
              AppColors.goldenNeon,
              Icons.attach_money,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    final totalDebt = customer['total_debt'] ?? 0.0;
    final overdueDebt = customer['overdue_debt'] ?? 0.0;
    final contractsCount = customer['contracts_count'] ?? 0;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (totalDebt == 0) {
      statusColor = Colors.blue;
      statusIcon = Icons.done_all;
      statusText = 'مكتمل';
    } else if (overdueDebt > 0) {
      statusColor = Colors.red;
      statusIcon = Icons.warning;
      statusText = 'متأخر';
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'نشط';
    }

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldenNeon.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        customer['id'],
                        style: const TextStyle(
                          color: AppColors.goldenNeon,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العميل
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  customer['name'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  customer['phone'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العقود
            Row(
              children: [
                const Icon(
                  Icons.description,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'عدد العقود: $contractsCount',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // المبالغ
            Row(
              children: [
                Expanded(
                  child: _buildAmountInfo(
                    'الإجمالي',
                    totalDebt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAmountInfo(
                    'المتأخر',
                    overdueDebt,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInfo(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${amount.toInt()} ج',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatistics(BuildContext context, List<Map<String, dynamic>> installments) {
    final activeCount = installments.where((inst) {
      final overdueDebt = inst['overdue_debt'] ?? 0.0;
      final totalDebt = inst['total_debt'] ?? 0.0;
      return totalDebt > 0 && overdueDebt == 0;
    }).length;

    final overdueCount = installments.where((inst) {
      final overdueDebt = inst['overdue_debt'] ?? 0.0;
      return overdueDebt > 0;
    }).length;

    final completedCount = installments.where((inst) {
      final totalDebt = inst['total_debt'] ?? 0.0;
      return totalDebt == 0;
    }).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'إحصائيات الأقساط',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('إجمالي العملاء', '${installments.length}', Colors.blue),
            _buildStatRow('الأقساط النشطة', '$activeCount', Colors.green),
            _buildStatRow('الأقساط المتأخرة', '$overdueCount', Colors.red),
            _buildStatRow('الأقساط المكتملة', '$completedCount', Colors.purple),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
