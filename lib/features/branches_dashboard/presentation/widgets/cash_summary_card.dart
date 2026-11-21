import 'package:flutter/material.dart';
import '../../domain/models/branch_summary.dart';

/// Cash summary card showing available cash and collections
class CashSummaryCard extends StatelessWidget {
  final CashSummary cash;

  const CashSummaryCard({
    super.key,
    required this.cash,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFFFD700), // goldenNeon
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFA500).withOpacity(0.3), // goldenGlow
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'النقدية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Available cash
          _buildMetric(
            icon: Icons.attach_money,
            label: 'النقدية المتاحة',
            value: _formatCurrency(cash.availableCashPiastres),
            valueColor: Color(0xFF4CAF50),
          ),
          SizedBox(height: 12),

          // Total collections
          _buildMetric(
            icon: Icons.payments,
            label: 'إجمالي التحصيلات',
            value: _formatCurrency(cash.totalCollectionsPiastres),
            valueColor: Color(0xFFD4AF37),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(int piastres) {
    final egp = piastres / 100;
    return '${egp.toStringAsFixed(2)} ج.م';
  }
}
