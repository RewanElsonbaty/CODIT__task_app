import 'package:codit/core/utils/money_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardMetricsList extends StatelessWidget {
  const DashboardMetricsList({
    super.key,
    required this.payload,
    required this.lastUpdate,
  });

  final Map<String, dynamic> payload;
  final DateTime? lastUpdate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final operations = payload['operations'] as List<dynamic>? ?? [];
    final goldPrices = payload['gold_prices'] as List<dynamic>? ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // وقت آخر تحديث
        if (lastUpdate != null)
          _buildLastUpdateCard(theme),
        
        const SizedBox(height: 16),
        
        // المبيعات
        _buildMetricCard(
          theme,
          title: 'المبيعات',
          icon: Icons.shopping_cart,
          iconColor: Colors.green,
          children: [
            _buildMetricRow(
              'إجمالي المبيعات',
              Money(payload['sales_total_piastres'] as int).formatEgp(),
              bold: true,
            ),
            _buildMetricRow(
              'مبيعات اليوم',
              Money(payload['sales_today_piastres'] as int).formatEgp(),
            ),
            _buildMetricRow(
              'عدد العمليات',
              '${payload['sales_count']}',
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // النقدية
        _buildMetricCard(
          theme,
          title: 'النقدية',
          icon: Icons.account_balance_wallet,
          iconColor: Colors.blue,
          children: [
            _buildMetricRow(
              'رصيد النقد',
              Money(payload['cash_balance_piastres'] as int).formatEgp(),
              bold: true,
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // أسعار الذهب
        if (goldPrices.isNotEmpty)
          _buildMetricCard(
            theme,
            title: 'أسعار الذهب',
            icon: Icons.stars,
            iconColor: Colors.amber,
            children: [
              for (final price in goldPrices)
                _buildMetricRow(
                  'عيار ${(price as Map)['karat']}',
                  '${Money((price['piastres_per_gram'] as int)).formatEgp()} / جرام',
                ),
            ],
          ),
        
        const SizedBox(height: 12),
        
        // آخر العمليات
        _buildOperationsCard(theme, operations),
      ],
    );
  }

  Widget _buildLastUpdateCard(ThemeData theme) {
    final cairoTime = _toCairoTime(lastUpdate!);
    final formatter = DateFormat('d/M/yyyy - h:mm:ss a', 'ar');
    
    return Card(
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'آخر تحديث',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    formatter.format(cairoTime),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 17 : 15,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: bold ? Colors.black87 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsCard(ThemeData theme, List<dynamic> operations) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.history, color: Colors.purple, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'آخر العمليات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (operations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لا توجد عمليات حديثة',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              for (final op in operations) _buildOperationTile(op as Map),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationTile(Map op) {
    final cairoTime = _toCairoTime(DateTime.parse(op['timestamp'] as String));
    final timeFormatter = DateFormat('h:mm a', 'ar');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  op['type'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${op['branch']} • ${op['employee']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  timeFormatter.format(cairoTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            Money(op['amount_piastres'] as int).formatEgp(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _toCairoTime(DateTime utc) {
    // تحويل إلى توقيت القاهرة (UTC+2)
    return utc.add(const Duration(hours: 2));
  }
}