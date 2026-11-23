import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  String _selectedFilter = 'الكل';

  // داتا تجريبية للموافقات
  final List<Map<String, dynamic>> _approvals = [
    {
      'id': 'APV-001',
      'type': 'خصم إضافي',
      'customer': 'أحمد محمد',
      'amount': 5000.0,
      'discount': 15.0,
      'status': 'قيد الانتظار',
      'date': '2024-01-15 10:30',
      'requestedBy': 'محمد أحمد',
    },
    {
      'id': 'APV-002',
      'type': 'تقسيط',
      'customer': 'فاطمة علي',
      'amount': 12000.0,
      'discount': 0.0,
      'status': 'موافق عليها',
      'date': '2024-01-15 09:15',
      'requestedBy': 'سارة حسن',
    },
    {
      'id': 'APV-003',
      'type': 'خصم إضافي',
      'customer': 'عمر خالد',
      'amount': 8500.0,
      'discount': 20.0,
      'status': 'مرفوضة',
      'date': '2024-01-14 16:45',
      'requestedBy': 'أحمد علي',
    },
    {
      'id': 'APV-004',
      'type': 'استبدال',
      'customer': 'نور حسين',
      'amount': 3200.0,
      'discount': 5.0,
      'status': 'قيد الانتظار',
      'date': '2024-01-14 14:20',
      'requestedBy': 'ليلى محمود',
    },
  ];

  List<Map<String, dynamic>> get _filteredApprovals {
    if (_selectedFilter == 'الكل') return _approvals;
    return _approvals.where((a) => a['status'] == _selectedFilter).toList();
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
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.approval,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'الموافقات',
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
                  _buildFilterChip('قيد الانتظار'),
                  const SizedBox(width: 8),
                  _buildFilterChip('موافق عليها'),
                  const SizedBox(width: 8),
                  _buildFilterChip('مرفوضة'),
                ],
              ),
            ),
          ),

          // قائمة الموافقات
          Expanded(
            child: _filteredApprovals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد موافقات',
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
                    itemCount: _filteredApprovals.length,
                    itemBuilder: (context, index) {
                      final approval = _filteredApprovals[index];
                      return _buildApprovalCard(approval);
                    },
                  ),
          ),
        ],
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
      selectedColor: AppColors.primary.withOpacity(0.3),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> approval) {
    Color statusColor;
    IconData statusIcon;

    switch (approval['status']) {
      case 'قيد الانتظار':
        statusColor = AppColors.warningDark;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'موافق عليها':
        statusColor = AppColors.successDark;
        statusIcon = Icons.check_circle;
        break;
      case 'مرفوضة':
        statusColor = AppColors.errorDark;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!, width: 1),
      ),
      child: InkWell(
        onTap: () => context.go('/approvals/${approval['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الهيدر - ID والحالة
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
                          approval['id'],
                          style: const TextStyle(
                            color: AppColors.goldenNeon,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          approval['type'],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
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
                        approval['status'],
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

              // تفاصيل العميل
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    approval['customer'],
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // المبلغ والخصم
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: AppColors.goldenNeon,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${approval['amount']} جنيه',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (approval['discount'] > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.discount,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'خصم ${approval['discount']}%',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const Divider(height: 24, color: AppColors.textSecondary),

              // التاريخ والموظف
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        approval['date'],
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'طلبها: ${approval['requestedBy']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
