import 'package:flutter/material.dart';
import '../../domain/models/branch_summary.dart';

/// Sales summary card showing total sales, invoices count, and returns
class SalesSummaryCard extends StatelessWidget {
  final SalesSummary sales;

  const SalesSummaryCard({
    super.key,
    required this.sales,
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
                  color: Color(0xFFD4AF37).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.diamond,
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'ملخص المبيعات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Total sales
          _buildMetric(
            icon: Icons.monetization_on,
            label: 'إجمالي المبيعات',
            value: _formatCurrency(sales.totalSalesPiastres),
            valueColor: Color(0xFF4CAF50),
          ),
          SizedBox(height: 12),

          // Invoices count
          _buildMetric(
            icon: Icons.receipt_long,
            label: 'عدد الفواتير',
            value: '${sales.invoicesCount}',
            valueColor: Color(0xFFD4AF37),
          ),
          
          // Returns (if available)
          if (sales.totalReturnsPiastres > 0) ...[
            SizedBox(height: 12),
            _buildMetric(
              icon: Icons.undo,
              label: 'إجمالي المرتجعات',
              value: _formatCurrency(sales.totalReturnsPiastres),
              valueColor: Color(0xFFFF5252),
            ),
          ],
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
