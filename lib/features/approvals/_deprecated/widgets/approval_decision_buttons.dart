import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/approvals/presentation/approval_details_cubit.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';

/// أزرار القرار (موافقة/رفض)
class ApprovalDecisionButtons extends StatelessWidget {
  const ApprovalDecisionButtons({
    super.key,
    required this.approval,
    required this.isSubmitting,
  });

  final ApprovalDetail approval;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    if (approval.status != ApprovalStatus.pending) {
      return _CompletedStatusBanner(status: approval.status);
    }

    final cubit = context.read<ApprovalDetailsCubit>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: isSubmitting
                    ? null
                    : () => _showApproveConfirmation(context, cubit),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'موافقة',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: isSubmitting
                    ? null
                    : () => _showRejectConfirmation(context, cubit),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'رفض',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showApproveConfirmation(
    BuildContext context,
    ApprovalDetailsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green.shade600),
            const SizedBox(width: 12),
            const Text('تأكيد الموافقة'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من الموافقة على هذا الطلب؟',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.shade600,
            ),
            child: const Text('موافقة'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await cubit.approve();
    }
  }

  Future<void> _showRejectConfirmation(
    BuildContext context,
    ApprovalDetailsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red.shade600),
            const SizedBox(width: 12),
            const Text('تأكيد الرفض'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من رفض هذا الطلب؟',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text('رفض'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await cubit.reject('تم الرفض من قبل المدير');
    }
  }
}

class _CompletedStatusBanner extends StatelessWidget {
  const _CompletedStatusBanner({required this.status});

  final ApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    final isApproved = status == ApprovalStatus.approved;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isApproved
              ? [
                  AppColors.successSurface,
                  AppColors.successDark.withValues(alpha: 0.3),
                ]
              : [
                  AppColors.errorSurface,
                  AppColors.errorDark.withValues(alpha: 0.3),
                ],
        ),
        border: Border(
          top: BorderSide(
            color: isApproved ? AppColors.success : AppColors.error,
            width: 3,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isApproved
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.error.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isApproved ? Icons.check_circle : Icons.cancel,
                color: isApproved ? AppColors.success : AppColors.error,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              isApproved ? 'تمت الموافقة على الطلب' : 'تم رفض الطلب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isApproved ? AppColors.success : AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
