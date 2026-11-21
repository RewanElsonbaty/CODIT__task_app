import 'package:flutter/material.dart';
import 'package:codit/core/utils/number_formatters.dart';

/// عرض تفصيلي للرصيد (مؤكد + معلق)
class BalanceBreakdownCard extends StatelessWidget {
  const BalanceBreakdownCard({
    super.key,
    required this.serverOutstandingPiastres,
    required this.localPendingPiastres,
    required this.lastSyncTime,
  });

  final int serverOutstandingPiastres;
  final int localPendingPiastres;
  final DateTime? lastSyncTime;

  @override
  Widget build(BuildContext context) {
    final maxCollectible = serverOutstandingPiastres - localPendingPiastres;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD700), // goldenNeon
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA500).withOpacity(0.3), // goldenGlow
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'تفاصيل الرصيد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // الرصيد المؤكد من السيرفر
            _BalanceRow(
              label: 'الرصيد المؤكد',
              amount: serverOutstandingPiastres,
              icon: Icons.check_circle,
              iconColor: Colors.green,
              amountStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            // التحصيلات المعلقة (إن وجدت)
            if (localPendingPiastres > 0) ...[
              const SizedBox(height: 12),
              _BalanceRow(
                label: 'تحصيلات معلقة',
                amount: -localPendingPiastres,
                icon: Icons.pending,
                iconColor: Colors.orange,
                amountStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'محفوظة محلياً - في انتظار المزامنة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // الرصيد المتوقع (المتاح للتحصيل)
            _BalanceRow(
              label: 'المتاح للتحصيل',
              amount: maxCollectible,
              icon: Icons.attach_money,
              iconColor: maxCollectible > 0 ? Colors.blue : Colors.grey,
              amountStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: maxCollectible > 0 ? Colors.blue : Colors.grey,
              ),
            ),

            // تحذير إذا لا يوجد متاح
            if (maxCollectible <= 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.block,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'لا يمكن تحصيل مبالغ إضافية حالياً',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // وقت آخر تحديث
            if (lastSyncTime != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sync,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'آخر تحديث: ${_formatTime(lastSyncTime!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inHours < 1) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inDays < 1) {
      return 'منذ ${diff.inHours} ساعة';
    } else {
      return 'منذ ${diff.inDays} يوم';
    }
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.amountStyle,
  });

  final String label;
  final int amount;
  final IconData icon;
  final Color iconColor;
  final TextStyle amountStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          NumberFormatters.formatCurrency(amount.abs() / 100),
          style: amountStyle,
        ),
      ],
    );
  }
}
