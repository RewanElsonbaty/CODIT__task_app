import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/money_utils.dart';
import 'package:flutter/material.dart';

class CustomerBalanceHeader extends StatelessWidget {
  const CustomerBalanceHeader({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final maxCollectible = data['max_collectible_piastres'] as int;
    final localPending = data['local_pending_piastres'] as int;
    final serverOutstanding = data['server_outstanding_piastres'] as int? ?? 0;
    final hasPending = localPending > 0;
    
    return Container(
      margin: const EdgeInsets.all(16),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data['customer_name'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Balance Cards
          Row(
            children: [
              Expanded(
                child: _BalanceCard(
                  icon: Icons.account_balance_wallet,
                  label: 'المتاح للتحصيل',
                  amount: Money(maxCollectible).formatEgp(),
                  color: maxCollectible > 0 
                      ? AppColors.successLight 
                      : AppColors.textSecondary,
                  isHighlight: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BalanceCard(
                  icon: Icons.sync,
                  label: 'معلق محلياً',
                  amount: Money(localPending).formatEgp(),
                  color: hasPending 
                      ? AppColors.warningLight 
                      : AppColors.successLight,
                  isHighlight: hasPending,
                ),
              ),
            ],
          ),
          
          if (hasPending) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warningLight.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.warningLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'يوجد تحصيلات معلقة في انتظار المزامنة',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          if (maxCollectible <= 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.errorLight.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.block,
                    color: AppColors.errorLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'لا يمكن تحصيل مبالغ إضافية حالياً',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
    required this.isHighlight,
  });

  final IconData icon;
  final String label;
  final String amount;
  final Color color;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: isHighlight
            ? Border.all(color: Colors.white.withOpacity(0.4))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.9),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: isHighlight ? 16 : 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}