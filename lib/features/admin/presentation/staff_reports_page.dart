import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// صفحة تقارير الموظفين - للمدير فقط
class StaffReportsPage extends StatelessWidget {
  const StaffReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقارير الموظفين'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            color: AppColors.goldenNeon.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.people, size: 48, color: AppColors.goldenNeon),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تقارير أداء الموظفين',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'آخر تحديث: ${DateTime.now().toString().split(' ')[0]}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Staff Members
          _buildStaffCard(
            name: 'محمد أحمد',
            role: 'موظف مبيعات',
            todaySales: '45,000 ج.م',
            todayTransactions: 12,
            performance: 0.92,
            avatar: Icons.person,
            color: Colors.blue,
          ),

          _buildStaffCard(
            name: 'فاطمة حسن',
            role: 'كاشير',
            todaySales: '32,000 ج.م',
            todayTransactions: 8,
            performance: 0.88,
            avatar: Icons.person,
            color: Colors.pink,
          ),

          _buildStaffCard(
            name: 'خالد محمود',
            role: 'مسؤول موافقات',
            todaySales: '0 ج.م',
            todayTransactions: 5,
            performance: 0.95,
            avatar: Icons.person,
            color: Colors.green,
          ),

          _buildStaffCard(
            name: 'نور علي',
            role: 'مسؤول أقساط',
            todaySales: '28,000 ج.م',
            todayTransactions: 15,
            performance: 0.90,
            avatar: Icons.person,
            color: Colors.orange,
          ),

          const SizedBox(height: 20),

          // Summary Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الملخص الإجمالي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('إجمالي المبيعات اليوم', '105,000 ج.م'),
                  _buildSummaryRow('إجمالي العمليات', '40 عملية'),
                  _buildSummaryRow('متوسط الأداء', '91%'),
                  _buildSummaryRow('عدد الموظفين النشطين', '4 موظفين'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard({
    required String name,
    required String role,
    required String todaySales,
    required int todayTransactions,
    required double performance,
    required IconData avatar,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(avatar, size: 32, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getPerformanceColor(performance).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(performance * 100).toInt()}%',
                    style: TextStyle(
                      color: _getPerformanceColor(performance),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'المبيعات اليوم',
                    todaySales,
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    'العمليات',
                    '$todayTransactions',
                    Icons.shopping_cart,
                    Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Performance Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مستوى الأداء',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: performance,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getPerformanceColor(performance),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double performance) {
    if (performance >= 0.9) return Colors.green;
    if (performance >= 0.75) return Colors.orange;
    return Colors.red;
  }
}
