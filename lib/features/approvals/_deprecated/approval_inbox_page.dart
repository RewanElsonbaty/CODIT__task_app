import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codit/core/di/injection.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/core/widgets/app_error_view.dart';
import 'package:codit/core/widgets/app_empty_state.dart';
import 'package:codit/features/approvals/presentation/approval_inbox_cubit.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/notifications/presentation/widgets/notification_icon_button.dart';
import 'package:codit/core/utils/money_utils.dart';
import 'package:intl/intl.dart' as intl;

class ApprovalInboxPage extends StatelessWidget {
  const ApprovalInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ApprovalInboxCubit>()..loadApprovals(),
      child: const _ApprovalInboxView(),
    );
  }
}

class _ApprovalInboxView extends StatelessWidget {
  const _ApprovalInboxView();

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthenticationCubit>().session;

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
                    AppColors.goldenNeon.withOpacity(0.3),
                    AppColors.goldenNeon.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.approval,
                size: 24,
                color: AppColors.goldenNeon,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'طلبات الموافقة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  if (session.shopName != null)
                    Text(
                      session.shopName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.goldenNeon.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: const [NotificationIconButton(), SizedBox(width: 8)],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ApprovalInboxCubit, ApprovalInboxState>(
        builder: (context, state) {
          if (state is ApprovalInboxLoading) {
            return const AppLoading();
          }

          if (state is ApprovalInboxError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<ApprovalInboxCubit>().loadApprovals(),
            );
          }

          if (state is ApprovalInboxLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<ApprovalInboxCubit>().refresh(),
              backgroundColor: AppColors.card,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الإحصائيات
                    _StatsSection(stats: state.stats),

                    const SizedBox(height: 16),

                    // الفلاتر
                    _FilterSection(
                      selectedFilter: state.selectedFilter,
                      onFilterChanged: (status) {
                        context.read<ApprovalInboxCubit>().filterByStatus(
                          status,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // قائمة الطلبات
                    if (state.approvals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: AppEmptyState(
                          icon: Icons.check_circle,
                          title: 'لا توجد طلبات',
                          message: 'جميع الطلبات تمت معالجتها',
                        ),
                      )
                    else
                      ...state.approvals.map((approval) {
                        return _ApprovalCard(approval: approval);
                      }),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// قسم الإحصائيات
class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.stats});

  final ApprovalStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'الإجمالي',
            value: stats.total.toString(),
            color: AppColors.primary,
          ),
          _StatItem(
            label: 'المعلقة',
            value: stats.pending.toString(),
            color: AppColors.warningDark,
          ),
          _StatItem(
            label: 'الموافق عليها',
            value: stats.approved.toString(),
            color: AppColors.successDark,
          ),
          _StatItem(
            label: 'المرفوضة',
            value: stats.rejected.toString(),
            color: AppColors.errorDark,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// قسم الفلاتر
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final ApprovalStatus? selectedFilter;
  final Function(ApprovalStatus?) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'الكل',
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'معلقة',
            isSelected: selectedFilter == ApprovalStatus.pending,
            onTap: () => onFilterChanged(ApprovalStatus.pending),
            color: AppColors.warningDark,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'موافق عليها',
            isSelected: selectedFilter == ApprovalStatus.approved,
            onTap: () => onFilterChanged(ApprovalStatus.approved),
            color: AppColors.successDark,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'مرفوضة',
            isSelected: selectedFilter == ApprovalStatus.rejected,
            onTap: () => onFilterChanged(ApprovalStatus.rejected),
            color: AppColors.errorDark,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.primary) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// بطاقة طلب الموافقة
class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.approval});

  final ApprovalSummary approval;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: approval.status == ApprovalStatus.pending
              ? AppColors.goldenNeon
              : AppColors.border.withOpacity(0.3),
          width: approval.status == ApprovalStatus.pending ? 2 : 1,
        ),
        boxShadow: approval.status == ApprovalStatus.pending
            ? [
                BoxShadow(
                  color: AppColors.goldenGlow.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/approvals/details',
              arguments: approval.id,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصف الأول: رقم الطلب + الحالة + Priority
                Row(
                  children: [
                    // Priority Badge (لو عاجل)
                    if (_isHighPriority(approval))
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.errorDark, Colors.red.shade700],
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.errorDark.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'عاجل',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
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
                        gradient: LinearGradient(
                          colors: [
                            AppColors.goldenNeon.withOpacity(0.3),
                            AppColors.goldenNeon.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.goldenNeon,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'طلب #${approval.requestNumber}',
                        style: const TextStyle(
                          color: AppColors.goldenNeon,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _StatusBadge(status: approval.status),
                  ],
                ),

                const SizedBox(height: 12),

                // اسم الموظف
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      approval.employeeName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // الفرع
                Row(
                  children: [
                    const Icon(
                      Icons.business,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      approval.branchName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // المبلغ + السبب
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isHighPriority(approval)
                                ? [
                                    AppColors.errorDark.withOpacity(0.2),
                                    AppColors.warningDark.withOpacity(0.2),
                                  ]
                                : [
                                    AppColors.primary.withOpacity(0.1),
                                    AppColors.secondary.withOpacity(0.1),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isHighPriority(approval)
                                ? AppColors.errorDark.withOpacity(0.5)
                                : AppColors.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                  color: _isHighPriority(approval)
                                      ? AppColors.errorDark
                                      : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'المبلغ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Money(approval.amountPiastres).formatEgp(),
                              style: TextStyle(
                                color: _isHighPriority(approval)
                                    ? AppColors.errorDark
                                    : AppColors.goldenNeon,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'السبب',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            approval.reason,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // التاريخ
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(approval.createdAt),
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
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return intl.DateFormat('yyyy-MM-dd').format(date);
    }
  }

  bool _isHighPriority(ApprovalSummary approval) {
    // عاجل لو:
    // 1. المبلغ أكبر من 10,000 ج.م
    // 2. أو الطلب معلق أكثر من 24 ساعة
    final isHighAmount = approval.amount > 10000;
    final isPendingLong =
        approval.status == ApprovalStatus.pending &&
        DateTime.now().difference(approval.createdAt).inHours > 24;

    return isHighAmount || isPendingLong;
  }
}

/// شارة الحالة
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case ApprovalStatus.pending:
        backgroundColor = AppColors.warningDark.withOpacity(0.2);
        textColor = AppColors.warningDark;
        break;
      case ApprovalStatus.approved:
        backgroundColor = AppColors.successDark.withOpacity(0.2);
        textColor = AppColors.successDark;
        break;
      case ApprovalStatus.rejected:
        backgroundColor = AppColors.errorDark.withOpacity(0.2);
        textColor = AppColors.errorDark;
        break;
      case ApprovalStatus.unknown:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
