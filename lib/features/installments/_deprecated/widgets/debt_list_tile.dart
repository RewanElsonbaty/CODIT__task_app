import 'package:codit/core/utils/money_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DebtListTile extends StatelessWidget {
  const DebtListTile({super.key, required this.debt});

  final Map<String, dynamic> debt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final originalPiastres = debt['original_piastres'] as int;
    final remainingPiastres = debt['remaining_piastres'] as int;
    final dueDate = DateTime.parse(debt['due_date'] as String);
    final status = debt['status'] as String;
    final dateFormatter = intl.DateFormat('d MMM yyyy', 'ar');
    
    final isPaid = remainingPiastres == 0;
    final isOverdue = !isPaid && dueDate.isBefore(DateTime.now());
    final paidAmount = originalPiastres - remainingPiastres;
    final progress = originalPiastres > 0 ? paidAmount / originalPiastres : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue
            ? BorderSide(color: Colors.red.shade300, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: معرف القسط + الحالة
            Row(
              children: [
                Expanded(
                  child: Text(
                    'قسط ${debt['id']}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(context, status, isPaid, isOverdue),
              ],
            ),
            const SizedBox(height: 12),

            // المبالغ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإجمالي',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Money(originalPiastres).formatEgp(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'المتبقي',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Money(remainingPiastres).formatEgp(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPaid
                            ? Colors.green.shade700
                            : isOverdue
                                ? Colors.red.shade700
                                : theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            if (!isPaid) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverdue ? Colors.red.shade400 : Colors.green.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم السداد: ${(progress * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],

            if (isPaid) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'تم السداد بالكامل',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 8),

            // تاريخ الاستحقاق
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: isOverdue ? Colors.red.shade700 : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  'تاريخ الاستحقاق: ${dateFormatter.format(dueDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverdue ? Colors.red.shade700 : Colors.grey.shade600,
                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),

            // تنبيه التأخير
            if (isOverdue) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'متأخر - يجب السداد في أقرب وقت',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    String status,
    bool isPaid,
    bool isOverdue,
  ) {
    final theme = Theme.of(context);
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    if (isPaid) {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      icon = Icons.check_circle;
      label = 'مسدد';
    } else if (isOverdue) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
      icon = Icons.error;
      label = 'متأخر';
    } else if (status == 'active') {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade900;
      icon = Icons.pending;
      label = 'نشط';
    } else {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade900;
      icon = Icons.help_outline;
      label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}