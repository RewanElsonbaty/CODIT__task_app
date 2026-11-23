import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class InstallmentsPage extends StatefulWidget {
  const InstallmentsPage({super.key});

  @override
  State<InstallmentsPage> createState() => _InstallmentsPageState();
}

class _InstallmentsPageState extends State<InstallmentsPage> {
  String _selectedFilter = 'الكل';

  // داتا تجريبية للأقساط
  final List<Map<String, dynamic>> _installments = [
    {
      'id': 'INST-001',
      'customer': 'سارة محمود',
      'phone': '01012345678',
      'totalAmount': 15000.0,
      'paidAmount': 9000.0,
      'remainingAmount': 6000.0,
      'monthlyPayment': 1500.0,
      'nextPaymentDate': '2024-02-01',
      'status': 'نشط',
      'installmentsCount': 10,
      'paidInstallments': 6,
    },
    {
      'id': 'INST-002',
      'customer': 'خالد أحمد',
      'phone': '01098765432',
      'totalAmount': 20000.0,
      'paidAmount': 20000.0,
      'remainingAmount': 0.0,
      'monthlyPayment': 2000.0,
      'nextPaymentDate': '-',
      'status': 'مكتمل',
      'installmentsCount': 10,
      'paidInstallments': 10,
    },
    {
      'id': 'INST-003',
      'customer': 'مريم حسن',
      'phone': '01123456789',
      'totalAmount': 12000.0,
      'paidAmount': 4000.0,
      'remainingAmount': 8000.0,
      'monthlyPayment': 1000.0,
      'nextPaymentDate': '2024-01-20',
      'status': 'متأخر',
      'installmentsCount': 12,
      'paidInstallments': 4,
    },
    {
      'id': 'INST-004',
      'customer': 'عمر فتحي',
      'phone': '01156781234',
      'totalAmount': 25000.0,
      'paidAmount': 12500.0,
      'remainingAmount': 12500.0,
      'monthlyPayment': 2500.0,
      'nextPaymentDate': '2024-02-05',
      'status': 'نشط',
      'installmentsCount': 10,
      'paidInstallments': 5,
    },
  ];

  List<Map<String, dynamic>> get _filteredInstallments {
    if (_selectedFilter == 'الكل') return _installments;
    return _installments
        .where((i) => i['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
                    Colors.green.withOpacity(0.3),
                    Colors.green.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.payment,
                size: 24,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'الأقساط',
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
          // زر الإحصائيات
          IconButton(
            icon: const Icon(Icons.bar_chart, color: AppColors.goldenNeon),
            onPressed: () {
              _showStatistics(context);
            },
            tooltip: 'الإحصائيات',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // فلاتر
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.card,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل'),
                  const SizedBox(width: 8),
                  _buildFilterChip('نشط'),
                  const SizedBox(width: 8),
                  _buildFilterChip('متأخر'),
                  const SizedBox(width: 8),
                  _buildFilterChip('مكتمل'),
                ],
              ),
            ),
          ),

          // ملخص سريع
          _buildSummaryCards(),

          // قائمة الأقساط
          Expanded(
            child: _filteredInstallments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد أقساط',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredInstallments.length,
                    itemBuilder: (context, index) {
                      final installment = _filteredInstallments[index];
                      return _buildInstallmentCard(installment);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new installment
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إضافة قسط جديد')),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('قسط جديد'),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: Colors.green.withOpacity(0.3),
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildSummaryCards() {
    final activeCount =
        _installments.where((i) => i['status'] == 'نشط').length;
    final overdueCount =
        _installments.where((i) => i['status'] == 'متأخر').length;
    final totalAmount = _installments.fold<double>(
        0.0, (sum, i) => sum + (i['remainingAmount'] as double));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'نشط',
              activeCount.toString(),
              Colors.green,
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'متأخر',
              overdueCount.toString(),
              Colors.red,
              Icons.warning,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'المتبقي',
              '${totalAmount.toInt()} ج',
              AppColors.goldenNeon,
              Icons.attach_money,
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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentCard(Map<String, dynamic> installment) {
    Color statusColor;
    IconData statusIcon;

    switch (installment['status']) {
      case 'نشط':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'متأخر':
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
      case 'مكتمل':
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    final progress = installment['paidInstallments'] /
        installment['installmentsCount'];

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!, width: 1),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldenNeon.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        installment['id'],
                        style: const TextStyle(
                          color: AppColors.goldenNeon,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      installment['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العميل
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  installment['customer'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  installment['phone'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تم دفع ${installment['paidInstallments']} من ${installment['installmentsCount']}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: statusColor,
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
                    value: progress,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // المبالغ
            Row(
              children: [
                Expanded(
                  child: _buildAmountInfo(
                    'الإجمالي',
                    installment['totalAmount'],
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAmountInfo(
                    'المدفوع',
                    installment['paidAmount'],
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildAmountInfo(
                    'المتبقي',
                    installment['remainingAmount'],
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: AppColors.textSecondary),

            // القسط القادم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.goldenNeon,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'القسط القادم: ${installment['nextPaymentDate']}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${installment['monthlyPayment']} ج',
                  style: const TextStyle(
                    color: AppColors.goldenNeon,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInfo(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${amount.toInt()} ج',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatistics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          'إحصائيات الأقساط',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow(
                'إجمالي الأقساط', '${_installments.length}', Colors.blue),
            _buildStatRow(
              'الأقساط النشطة',
              '${_installments.where((i) => i['status'] == 'نشط').length}',
              Colors.green,
            ),
            _buildStatRow(
              'الأقساط المتأخرة',
              '${_installments.where((i) => i['status'] == 'متأخر').length}',
              Colors.red,
            ),
            _buildStatRow(
              'الأقساط المكتملة',
              '${_installments.where((i) => i['status'] == 'مكتمل').length}',
              Colors.purple,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
