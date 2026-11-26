import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shimmer_loading.dart';
import 'branches_cubit.dart';

class BranchesSimplePage extends StatelessWidget {
  const BranchesSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BranchesCubit(),
      child: const _BranchesPageContent(),
    );
  }
}

class _BranchesPageContent extends StatelessWidget {
  const _BranchesPageContent();

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
                    Colors.purple.withOpacity(0.3),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.store,
                size: 24,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'مراقبة الفروع',
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
          BlocBuilder<BranchesCubit, BranchesState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.goldenNeon),
                onPressed: () {
                  context.read<BranchesCubit>().refreshBranches();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تحديث البيانات'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                tooltip: 'تحديث',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<BranchesCubit, BranchesState>(
        builder: (context, state) {
          if (state is BranchesLoading) {
            return const ShimmerBranchesList();
          } else if (state is BranchesLoaded) {
            return Column(
              children: [
                // ملخص عام
                _buildSummarySection(state.statistics),

                // قائمة الفروع
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<BranchesCubit>().loadBranches(),
                    color: Colors.purple,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.branches.length,
                      itemBuilder: (ctx, index) {
                        final branch = state.branches[index];
                        return _buildBranchCard(ctx, branch);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is BranchesError) {
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
                    onPressed: state.onRetry ?? () => context.read<BranchesCubit>().loadBranches(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
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
    );
  }

  Widget _buildSummarySection(Map<String, dynamic> stats) {
    final activeBranches = stats['active_branches'] ?? 0;
    final totalBranches = stats['total_branches'] ?? 0;
    final totalSales = stats['total_sales'] ?? 0.0;
    final totalTransactions = stats['total_transactions'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.card,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'الفروع النشطة',
                  '$activeBranches / $totalBranches',
                  Colors.green,
                  Icons.store,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'مبيعات اليوم',
                  '${totalSales.toInt()} ج',
                  AppColors.goldenNeon,
                  Icons.attach_money,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSummaryCard(
            'معاملات اليوم',
            '$totalTransactions معاملة',
            Colors.blue,
            Icons.receipt,
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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(BuildContext context, Map<String, dynamic> branch) {
    final isOpen = branch['status'] == 'نشط';
    final statusColor = isOpen ? Colors.green : Colors.red;
    final employeePercentage = (branch['active_employees'] as int) / 
                               (branch['total_employees'] as int);

    return InkWell(
      onTap: () {
        // الانتقال لصفحة تفاصيل الفرع
        context.push('/branch-details/${branch['id']}', extra: {
          'branchName': branch['name'],
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: AppColors.card,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isOpen
                ? Colors.green.withOpacity(0.3)
                : Colors.grey[800]!,
            width: 1.5,
          ),
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
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.store,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch['name'],
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              branch['id'],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        branch['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العنوان والمدير
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    branch['address'],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'المدير: ${branch['manager']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.phone,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  branch['phone'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: AppColors.textSecondary),

            // الإحصائيات
            if (isOpen) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      'المبيعات',
                      '${branch['today_sales'].toInt()} ج',
                      AppColors.goldenNeon,
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox(
                      'المعاملات',
                      '${branch['today_transactions']}',
                      Colors.blue,
                      Icons.receipt,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox(
                      'التقييم',
                      '${branch['avg_rating']} ★',
                      Colors.orange,
                      Icons.star,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // الموظفين
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الموظفين الحاليين',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${branch['active_employees']} / ${branch['total_employees']}',
                        style: TextStyle(
                          color: employeePercentage >= 0.75
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: employeePercentage,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        employeePercentage >= 0.75
                            ? Colors.green
                            : Colors.orange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'مواعيد العمل: ${branch['open_time']} - ${branch['close_time']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ));
  }

  Widget _buildStatBox(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
