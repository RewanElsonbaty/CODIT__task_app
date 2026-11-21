import 'package:codit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double totalDebt;
  final double paid;
  final double remaining;
  final double maxCollectible;

  const BalanceSummaryCard({
    super.key,
    required this.totalDebt,
    required this.paid,
    required this.remaining,
    required this.maxCollectible,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalDebt > 0 ? paid / totalDebt : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.infoDark,
            AppColors.infoLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
          BoxShadow(
            color: AppColors.infoDark.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'ملخص الرصيد',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // صف الأرقام
          Row(
            children: [
              Expanded(
                child: _buildAmountBox(
                  label: 'إجمالي المديونية',
                  amount: totalDebt,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAmountBox(
                  label: 'المدفوع',
                  amount: paid,
                  icon: Icons.check_circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildAmountBox(
                  label: 'المتبقي',
                  amount: remaining,
                  icon: Icons.pending_actions,
                  highlight: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAmountBox(
                  label: 'متاح للتحصيل',
                  amount: maxCollectible,
                  icon: Icons.payments,
                  highlight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // شريط التقدم
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'نسبة السداد',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountBox({
    required String label,
    required double amount,
    required IconData icon,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.white.withOpacity(0.25)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: highlight
            ? Border.all(color: Colors.white.withOpacity(0.5), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(2)} ج',
            style: TextStyle(
              fontSize: highlight ? 16 : 15,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
