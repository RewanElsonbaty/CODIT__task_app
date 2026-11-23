import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shimmer_loading.dart';
import 'approvals_cubit.dart';
import 'approval_details_screen.dart';

class ApprovalsPage extends StatelessWidget {
  const ApprovalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApprovalsCubit(),
      child: const _ApprovalsPageContent(),
    );
  }
}

class _ApprovalsPageContent extends StatelessWidget {
  const _ApprovalsPageContent();

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
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.approval,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'الموافقات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          // مؤشر الكاش
          BlocBuilder<ApprovalsCubit, ApprovalsState>(
            builder: (context, state) {
              if (state is ApprovalsLoaded && state.isFromCache) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Tooltip(
                    message: 'البيانات من الذاكرة المؤقتة',
                    child: Icon(
                      Icons.cloud_off,
                      color: Colors.orange[300],
                      size: 20,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // زر الرجوع للصفحة الرئيسية
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.goldenNeon),
            onPressed: () => context.go('/home'),
            tooltip: 'الصفحة الرئيسية',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ApprovalsCubit, ApprovalsState>(
        builder: (context, state) {
          if (state is ApprovalsLoading) {
            return const ShimmerApprovalsList();
          }
          
          if (state is ApprovalsError) {
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
                    onPressed: state.onRetry ?? () => context.read<ApprovalsCubit>().loadApprovals(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldenNeon,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (state is ApprovalsLoaded) {
            final cubit = context.read<ApprovalsCubit>();
            final filteredApprovals = cubit.getFilteredApprovals();

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
                          _buildFilterChip(context, 'قيد الانتظار', state.selectedFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'موافق عليها', state.selectedFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip(context, 'مرفوضة', state.selectedFilter),
                        ],
                      ),
                    ),
                  ),

                  // قائمة الموافقات
                  Expanded(
                    child: filteredApprovals.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد موافقات',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => cubit.loadApprovals(),
                            color: AppColors.primary,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredApprovals.length,
                              itemBuilder: (context, index) {
                                final approval = filteredApprovals[index];
                                return _buildApprovalCard(context, approval);
                              },
                            ),
                          ),
                  ),
                ],
              );
            }
          
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String selectedFilter) {
    final isSelected = selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        context.read<ApprovalsCubit>().filterApprovals(label);
      },
      selectedColor: AppColors.primary.withOpacity(0.3),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildApprovalCard(BuildContext context, Map<String, dynamic> approval) {
    // تحويل الحالة
    String displayStatus;
    switch (approval['status']) {
      case 'pending':
        displayStatus = 'قيد الانتظار';
        break;
      case 'approved':
        displayStatus = 'موافق عليها';
        break;
      case 'rejected':
        displayStatus = 'مرفوضة';
        break;
      default:
        displayStatus = approval['status'];
    }

    Color statusColor;
    IconData statusIcon;

    switch (approval['status']) {
      case 'pending':
        statusColor = AppColors.warningDark;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'approved':
        statusColor = AppColors.successDark;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = AppColors.errorDark;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    // استخراج البيانات من metadata
    final metadata = approval['metadata'] as Map<String, dynamic>?;
    final amount = metadata?['original_price'] ?? metadata?['amount'] ?? 0.0;
    final discount = metadata?['discount_percentage'] ?? 0.0;

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!, width: 1),
      ),
      child: InkWell(
        onTap: () async {
          // Navigate with full approval data
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ApprovalDetailsScreen(request: approval),
            ),
          );
          
          // Reload if approval was updated
          if (result == true && context.mounted) {
            context.read<ApprovalsCubit>().loadApprovals();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الهيدر - ID والحالة
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
                          approval['id'],
                          style: const TextStyle(
                            color: AppColors.goldenNeon,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          approval['type'],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
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
                        displayStatus,
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

              // العنوان
              Text(
                approval['title'],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // الوصف
              Text(
                approval['description'],
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // المبلغ والخصم
              if (amount > 0)
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: AppColors.goldenNeon,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${amount.toStringAsFixed(0)} جنيه',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (discount > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.discount,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'خصم ${discount.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

              const Divider(height: 24, color: AppColors.textSecondary),

              // التاريخ والموظف
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(approval['created_at']),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'طلبها: ${approval['requester_name']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
