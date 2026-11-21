import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codit/core/di/injection.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/features/approvals/presentation/approval_details_cubit.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';
import 'package:codit/core/utils/money_utils.dart';
import 'package:intl/intl.dart' as intl;

class ApprovalDetailsPage extends StatelessWidget {
  const ApprovalDetailsPage({super.key, required this.approvalId});

  final String approvalId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ApprovalDetailsCubit>()..loadApproval(approvalId),
      child: const _ApprovalDetailsView(),
    );
  }
}

class _ApprovalDetailsView extends StatelessWidget {
  const _ApprovalDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApprovalDetailsCubit, ApprovalDetailsState>(
      listener: (context, state) {
        if (state is ApprovalDetailsDecisionSent) {
          // نجح القرار
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    state.wasApproved
                        ? 'تمت الموافقة على الطلب بنجاح'
                        : 'تم رفض الطلب بنجاح',
                  ),
                ],
              ),
              backgroundColor: state.wasApproved
                  ? AppColors.successDark
                  : AppColors.errorDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          // العودة للقائمة
          Navigator.pop(context, true);
        } else if (state is ApprovalDetailsUnknownResult) {
          // النتيجة غير مؤكدة
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => _UnknownResultDialog(
              requestId: state.requestId,
              message: state.message,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.card,
          title: const Text(
            'تفاصيل طلب الموافقة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<ApprovalDetailsCubit, ApprovalDetailsState>(
          builder: (context, state) {
            if (state is ApprovalDetailsLoading) {
              return const AppLoading();
            }

            if (state is ApprovalDetailsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (state.canRetry) ...[
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () {
                            context.read<ApprovalDetailsCubit>().refresh();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            if (state is ApprovalDetailsLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<ApprovalDetailsCubit>().refresh(),
                child: _DetailsContent(
                  approval: state.approval,
                  isRefreshing: state.isRefreshing,
                  isSubmitting: state.isSubmitting,
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// محتوى التفاصيل
class _DetailsContent extends StatelessWidget {
  const _DetailsContent({
    required this.approval,
    required this.isRefreshing,
    required this.isSubmitting,
  });

  final ApprovalDetail approval;
  final bool isRefreshing;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final isPending = approval.status == ApprovalStatus.pending;

    return Column(
      children: [
        // المحتوى القابل للتمرير
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رقم الطلب والإصدار
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.numbers,
                      label: 'رقم الطلب',
                      value: approval.requestNumber,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.published_with_changes,
                      label: 'رقم النسخة',
                      value: 'v${approval.version}',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'تاريخ الطلب',
                      value: _formatDateTime(approval.createdAt),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // بيانات الموظف والفرع
                _InfoCard(
                  title: 'بيانات مقدم الطلب',
                  children: [
                    _InfoRow(
                      icon: Icons.person,
                      label: 'اسم الموظف',
                      value: approval.employeeName,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.business,
                      label: 'الفرع',
                      value: approval.branchName,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // المبلغ والسبب
                _InfoCard(
                  title: 'تفاصيل الطلب',
                  children: [
                    _InfoRow(
                      icon: Icons.attach_money,
                      label: 'المبلغ',
                      value: Money(approval.amountPiastres).formatEgp(),
                      valueColor: AppColors.primary,
                      valueFontSize: 20,
                      valueFontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.description,
                      label: 'السبب',
                      value: approval.reason,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // معاينة الخصم (Discount Breakdown)
                _buildDiscountBreakdown(approval),

                const SizedBox(height: 16),

                // تفاصيل العملية
                if (approval.operationDetails.isNotEmpty) ...[
                  _InfoCard(
                    title: 'تفاصيل العملية',
                    children: [
                      ...approval.operationDetails.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}:',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // تحذيرات
                if (approval.warningMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warningDark.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.warningDark,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning,
                          color: AppColors.warningDark,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'تحذير - يحتاج انتباه',
                                style: TextStyle(
                                  color: AppColors.warningDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                approval.warningMessage!,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // الحالة الحالية
                _InfoCard(
                  title: 'الحالة',
                  children: [
                    Row(children: [_StatusBadge(status: approval.status)]),
                  ],
                ),
              ],
            ),
          ),
        ),

        // أزرار القرار (فقط للطلبات المعلقة)
        if (isPending)
          _DecisionButtons(
            isSubmitting: isSubmitting,
            isRefreshing: isRefreshing,
            onApprove: () {
              _showApproveDialog(context);
            },
            onReject: () {
              _showRejectDialog(context);
            },
            onRefresh: () {
              context.read<ApprovalDetailsCubit>().refreshBeforeDecision();
            },
          ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    return intl.DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  Widget _buildDiscountBreakdown(ApprovalDetail approval) {
    // نستخرج تفاصيل الخصم من operationDetails
    final originalAmount = approval.operationDetails['original_amount'];
    final discountPercent = approval.operationDetails['discount_percent'];
    final discountAmount = approval.operationDetails['discount_amount'];
    final finalAmount = approval.operationDetails['final_amount'];

    // لو مفيش تفاصيل خصم، نخفي الكارد
    if (originalAmount == null) {
      return const SizedBox.shrink();
    }

    // حساب القيم
    final original = (originalAmount is int)
        ? (originalAmount / 100.0) // تحويل من قروش لجنيه
        : double.tryParse(originalAmount.toString()) ?? 0.0;

    final discount = (discountAmount is int)
        ? (discountAmount / 100.0) // تحويل من قروش لجنيه
        : double.tryParse(discountAmount.toString()) ?? 0.0;

    final final_ = (finalAmount is int)
        ? (finalAmount / 100.0) // تحويل من قروش لجنيه
        : double.tryParse(finalAmount.toString()) ?? 0.0;

    final percent = discountPercent?.toString() ?? '0';

    // نحدد لو الخصم عالي (أكتر من 10%)
    final isHighDiscount = (double.tryParse(percent) ?? 0) > 10;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.discount,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'تفاصيل الخصم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isHighDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.errorDark, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.priority_high,
                        color: AppColors.errorDark,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'خصم عالي',
                        style: const TextStyle(
                          color: AppColors.errorDark,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // السعر الأصلي
          _buildPriceRow(
            label: 'السعر الأصلي',
            amount: original,
            icon: Icons.monetization_on,
            color: AppColors.textSecondary,
            isStrikethrough: true,
          ),

          const SizedBox(height: 16),

          // الخصم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorDark.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove_circle,
                  color: AppColors.errorDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'قيمة الخصم',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '- ${discount.toStringAsFixed(2)} ج.م',
                          style: const TextStyle(
                            color: AppColors.errorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warningDark.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$percent%',
                            style: const TextStyle(
                              color: AppColors.warningDark,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // خط فاصل
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.goldenNeon.withOpacity(0.1),
                  AppColors.goldenNeon,
                  AppColors.goldenNeon.withOpacity(0.1),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // السعر النهائي
          _buildPriceRow(
            label: 'السعر بعد الخصم',
            amount: final_,
            icon: Icons.check_circle,
            color: AppColors.successLight,
            isFinal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
    bool isStrikethrough = false,
    bool isFinal = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFinal
            ? AppColors.successDark.withOpacity(0.1)
            : AppColors.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: isFinal
            ? Border.all(color: AppColors.successLight, width: 2)
            : null,
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
                  style: TextStyle(
                    color: isFinal
                        ? AppColors.successLight
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isFinal ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${amount.toStringAsFixed(2)} ج.م',
                  style: TextStyle(
                    color: color,
                    fontSize: isFinal ? 24 : 18,
                    fontWeight: FontWeight.bold,
                    decoration: isStrikethrough
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.textSecondary,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),
          if (isFinal)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.successDark, AppColors.successLight],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.successLight.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  void _showApproveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'تأكيد الموافقة',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'هل أنت متأكد من الموافقة على هذا الطلب؟',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ApprovalDetailsCubit>().approve();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successDark,
            ),
            child: const Text('موافقة'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'تأكيد الرفض',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'هل أنت متأكد من رفض هذا الطلب؟',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'سبب الرفض (اختياري)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ApprovalDetailsCubit>().reject(
                reasonController.text.trim(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorDark,
            ),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }
}

/// حوار النتيجة غير المؤكدة
class _UnknownResultDialog extends StatelessWidget {
  const _UnknownResultDialog({required this.requestId, required this.message});

  final String requestId;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Row(
        children: [
          Icon(Icons.help_outline, color: AppColors.warningDark),
          SizedBox(width: 8),
          Text(
            'نتيجة غير مؤكدة',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          const Text(
            'يرجى التحقق من حالة الطلب قبل إعادة المحاولة.',
            style: TextStyle(
              color: AppColors.warningDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق الحوار
            Navigator.pop(context); // العودة للقائمة
          },
          child: const Text('العودة'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<ApprovalDetailsCubit>().checkStatus(requestId);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('التحقق من الحالة'),
        ),
      ],
    );
  }
}

/// بطاقة معلومات
class _InfoCard extends StatelessWidget {
  const _InfoCard({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }
}

/// صف معلومة
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueFontSize,
    this.valueFontWeight,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final double? valueFontSize;
  final FontWeight? valueFontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: valueFontSize ?? 16,
                  fontWeight: valueFontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// أزرار القرار
class _DecisionButtons extends StatelessWidget {
  const _DecisionButtons({
    required this.isSubmitting,
    required this.isRefreshing,
    required this.onApprove,
    required this.onReject,
    required this.onRefresh,
  });

  final bool isSubmitting;
  final bool isRefreshing;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // زر تحديث
          if (!isSubmitting)
            TextButton.icon(
              onPressed: isRefreshing ? null : onRefresh,
              icon: isRefreshing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(isRefreshing ? 'جاري التحديث...' : 'تحديث التفاصيل'),
            ),

          const SizedBox(height: 8),

          // أزرار الموافقة والرفض
          Row(
            children: [
              // زر الموافقة
              Expanded(
                child: ElevatedButton(
                  onPressed: isSubmitting || isRefreshing ? null : onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle),
                            SizedBox(width: 8),
                            Text(
                              'موافقة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // زر الرفض
              Expanded(
                child: ElevatedButton(
                  onPressed: isSubmitting || isRefreshing ? null : onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel),
                      SizedBox(width: 8),
                      Text(
                        'رفض',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
    IconData icon;

    switch (status) {
      case ApprovalStatus.pending:
        backgroundColor = AppColors.warningDark.withOpacity(0.2);
        textColor = AppColors.warningDark;
        icon = Icons.schedule;
        break;
      case ApprovalStatus.approved:
        backgroundColor = AppColors.successDark.withOpacity(0.2);
        textColor = AppColors.successDark;
        icon = Icons.check_circle;
        break;
      case ApprovalStatus.rejected:
        backgroundColor = AppColors.errorDark.withOpacity(0.2);
        textColor = AppColors.errorDark;
        icon = Icons.cancel;
        break;
      case ApprovalStatus.unknown:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
        icon = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            status.displayName,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
