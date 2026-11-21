import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtItemCard extends StatelessWidget {
  final Debt debt;

  const DebtItemCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final isOverdue = debt.isOverdue;
    final isPaid = debt.isPaid;
    final statusColor = isPaid
        ? AppColors.successDark
        : isOverdue
            ? AppColors.errorDark
            : AppColors.warningDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.card,
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.goldenNeon,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'مديونية #${debt.id.substring(debt.id.length - 6)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  _getStatusLabel(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Divider(color: AppColors.textSecondary, height: 1),
          const SizedBox(height: 12),

          // المبالغ
          Row(
            children: [
              Expanded(
                child: _buildAmountInfo(
                  label: 'المبلغ الأصلي',
                  amount: debt.original,
                  icon: Icons.monetization_on,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAmountInfo(
                  label: 'المتبقي',
                  amount: debt.remaining,
                  icon: Icons.trending_down,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // تاريخ الاستحقاق
          Row(
            children: [
              Icon(
                isOverdue ? Icons.error : Icons.calendar_today,
                size: 16,
                color: isOverdue ? AppColors.errorDark : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'تاريخ الاستحقاق: ${DateFormat('yyyy-MM-dd').format(debt.dueDate)}',
                style: TextStyle(
                  fontSize: 13,
                  color: isOverdue ? AppColors.errorDark : AppColors.textSecondary,
                ),
              ),
              if (isOverdue) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.errorDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'متأخر',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.errorDark,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // شريط التقدم
          if (!isPaid) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: debt.paid / debt.original,
                backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'مدفوع: ${debt.paid.toStringAsFixed(2)} ج (${((debt.paid / debt.original) * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountInfo({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(2)} ج',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon() {
    if (debt.isPaid) return Icons.check_circle;
    if (debt.isOverdue) return Icons.error;
    if (debt.isPartial) return Icons.hourglass_bottom;
    return Icons.schedule;
  }

  String _getStatusLabel() {
    if (debt.isPaid) return 'مسددة';
    if (debt.isOverdue) return 'متأخرة';
    if (debt.isPartial) return 'جزئية';
    return 'نشطة';
  }
}
