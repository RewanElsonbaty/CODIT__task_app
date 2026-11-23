import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  // داتا تجريبية للفروع
  final List<Map<String, dynamic>> _branches = [
    {
      'id': 'BR-001',
      'name': 'فرع المعادي',
      'address': 'شارع 9، المعادي، القاهرة',
      'manager': 'أحمد محمود',
      'phone': '0225123456',
      'todaySales': 125000.0,
      'todayTransactions': 42,
      'activeEmployees': 8,
      'totalEmployees': 10,
      'status': 'نشط',
      'openTime': '09:00',
      'closeTime': '21:00',
      'avgRating': 4.5,
    },
    {
      'id': 'BR-002',
      'name': 'فرع مدينة نصر',
      'address': 'شارع عباس العقاد، مدينة نصر',
      'manager': 'سارة علي',
      'phone': '0222345678',
      'todaySales': 98000.0,
      'todayTransactions': 35,
      'activeEmployees': 6,
      'totalEmployees': 8,
      'status': 'نشط',
      'openTime': '10:00',
      'closeTime': '22:00',
      'avgRating': 4.8,
    },
    {
      'id': 'BR-003',
      'name': 'فرع الإسكندرية',
      'address': 'شارع فؤاد، الإسكندرية',
      'manager': 'محمد حسن',
      'phone': '0334567890',
      'todaySales': 156000.0,
      'todayTransactions': 58,
      'activeEmployees': 12,
      'totalEmployees': 12,
      'status': 'نشط',
      'openTime': '09:00',
      'closeTime': '23:00',
      'avgRating': 4.7,
    },
    {
      'id': 'BR-004',
      'name': 'فرع الزمالك',
      'address': 'شارع 26 يوليو، الزمالك',
      'manager': 'نور فتحي',
      'phone': '0227654321',
      'todaySales': 0.0,
      'todayTransactions': 0,
      'activeEmployees': 0,
      'totalEmployees': 6,
      'status': 'مغلق',
      'openTime': '10:00',
      'closeTime': '20:00',
      'avgRating': 4.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeBranches =
        _branches.where((b) => b['status'] == 'نشط').length;
    final totalSales = _branches.fold<double>(
        0.0, (sum, b) => sum + (b['todaySales'] as double));
    final totalTransactions =
        _branches.fold<int>(0, (sum, b) => sum + (b['todayTransactions'] as int));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.3),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.store,
                size: 24,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'مراقبة الفروع',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          // زر الرجوع للصفحة الرئيسية
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.goldenNeon),
            onPressed: () => context.go('/home'),
            tooltip: 'الصفحة الرئيسية',
          ),
          // زر التحديث
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.goldenNeon),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تحديث البيانات'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'تحديث',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ملخص عام
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.card,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'الفروع النشطة',
                        '$activeBranches / ${_branches.length}',
                        Colors.green,
                        Icons.store,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSummaryCard(
                        'مبيعات اليوم',
                        '${totalSales.toInt()} ج',
                        AppColors.goldenNeon,
                        Icons.attach_money,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSummaryCard(
                  'معاملات اليوم',
                  '$totalTransactions معاملة',
                  Colors.blue,
                  Icons.receipt,
                ),
              ],
            ),
          ),

          // قائمة الفروع
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _branches.length,
              itemBuilder: (context, index) {
                final branch = _branches[index];
                return _buildBranchCard(branch);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    final isOpen = branch['status'] == 'نشط';
    final statusColor = isOpen ? Colors.green : Colors.red;
    final employeePercentage = branch['activeEmployees'] / branch['totalEmployees'];

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOpen
              ? Colors.green.withOpacity(0.3)
              : Colors.grey[800]!,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.store,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch['name'],
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              branch['id'],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
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
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        branch['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العنوان والمدير
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    branch['address'],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'المدير: ${branch['manager']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.phone,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  branch['phone'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: AppColors.textSecondary),

            // الإحصائيات
            if (isOpen) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      'المبيعات',
                      '${branch['todaySales'].toInt()} ج',
                      AppColors.goldenNeon,
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox(
                      'المعاملات',
                      '${branch['todayTransactions']}',
                      Colors.blue,
                      Icons.receipt,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatBox(
                      'التقييم',
                      '${branch['avgRating']} ★',
                      Colors.orange,
                      Icons.star,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // الموظفين
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الموظفين الحاليين',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${branch['activeEmployees']} / ${branch['totalEmployees']}',
                        style: TextStyle(
                          color: employeePercentage >= 0.75
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: employeePercentage,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        employeePercentage >= 0.75
                            ? Colors.green
                            : Colors.orange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'مواعيد العمل: ${branch['openTime']} - ${branch['closeTime']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
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

  Widget _buildStatBox(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
