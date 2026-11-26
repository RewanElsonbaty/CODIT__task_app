import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import '../../installments/data/mock_installments_api.dart';

/// صفحة أقساط الفرع
/// 
/// تعرض جميع أقساط الفرع بالحالات المختلفة:
/// - الكل
/// - نشط
/// - متأخر
/// - مكتمل
/// - ملغي
class BranchInstallmentsPage extends StatefulWidget {
  final String branchId;
  final String? branchName;

  const BranchInstallmentsPage({
    super.key,
    required this.branchId,
    this.branchName,
  });

  @override
  State<BranchInstallmentsPage> createState() => _BranchInstallmentsPageState();
}

class _BranchInstallmentsPageState extends State<BranchInstallmentsPage>
    with SingleTickerProviderStateMixin {
  final _api = MockInstallmentsApi();

  late TabController _tabController;
  List<Map<String, dynamic>> _allInstallments = [];
  List<Map<String, dynamic>> _activeInstallments = [];
  List<Map<String, dynamic>> _overdueInstallments = [];
  List<Map<String, dynamic>> _completedInstallments = [];
  List<Map<String, dynamic>> _cancelledInstallments = [];
  
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadInstallments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInstallments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // تحميل جميع الأقساط
      final response = await _api.getCustomersWithContracts();
      
      if (response['success'] == true) {
        final customers = (response['data'] as List).cast<Map<String, dynamic>>();
        
        // استخراج جميع العقود من العملاء
        final allContracts = <Map<String, dynamic>>[];
        for (final customer in customers) {
          final contracts = customer['contracts'] as List?;
          if (contracts != null) {
            for (final contract in contracts) {
              final contractMap = contract as Map<String, dynamic>;
              // إضافة branch_id إذا لم يكن موجوداً
              if (!contractMap.containsKey('branch_id')) {
                contractMap['branch_id'] = customer['branch_id'];
              }
              // إضافة بيانات العميل
              contractMap['customer_name'] = customer['name'];
              contractMap['customer_phone'] = customer['phone'];
              allContracts.add(contractMap);
            }
          }
        }

        // فلترة حسب الفرع
        final branchContracts = allContracts.where((contract) {
          final contractBranchId = contract['branch_id'] as String?;
          return contractBranchId == widget.branchId;
        }).toList();

        if (mounted) {
          setState(() {
            _allInstallments = branchContracts;
            
            // تقسيم حسب الحالة
            _activeInstallments = branchContracts
                .where((c) => c['status'] == 'active')
                .toList();
            
            _overdueInstallments = branchContracts.where((c) {
              if (c['status'] != 'active') return false;
              final startDate = DateTime.parse(c['start_date'] as String);
              final paidInstallments = c['paid_installments'] as int;
              final monthsSinceStart = DateTime.now().difference(startDate).inDays ~/ 30;
              return paidInstallments < monthsSinceStart;
            }).toList();
            
            _completedInstallments = branchContracts
                .where((c) => c['status'] == 'completed')
                .toList();
            
            _cancelledInstallments = branchContracts
                .where((c) => c['status'] == 'cancelled')
                .toList();
            
            _isLoading = false;
          });
        }
      } else {
        throw Exception(response['message'] ?? 'فشل تحميل الأقساط');
      }
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Column(
          children: [
            const Text(
              'أقساط الفرع',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.branchName != null)
              Text(
                widget.branchName!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.goldenNeon),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.goldenNeon,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.goldenNeon,
          isScrollable: true,
          tabs: [
            Tab(
              child: Row(
                children: [
                  const Text('الكل'),
                  const SizedBox(width: 4),
                  _buildBadge(_allInstallments.length, Colors.grey),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Text('نشط'),
                  const SizedBox(width: 4),
                  _buildBadge(_activeInstallments.length, Colors.green),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Text('متأخر'),
                  const SizedBox(width: 4),
                  _buildBadge(_overdueInstallments.length, Colors.red),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Text('مكتمل'),
                  const SizedBox(width: 4),
                  _buildBadge(_completedInstallments.length, Colors.blue),
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  const Text('ملغي'),
                  const SizedBox(width: 4),
                  _buildBadge(_cancelledInstallments.length, Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.goldenNeon),
            )
          : _errorMessage != null
              ? _buildErrorView()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInstallmentsList(_allInstallments),
                    _buildInstallmentsList(_activeInstallments),
                    _buildInstallmentsList(_overdueInstallments),
                    _buildInstallmentsList(_completedInstallments),
                    _buildInstallmentsList(_cancelledInstallments),
                  ],
                ),
    );
  }

  Widget _buildBadge(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.errorDark),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadInstallments,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenNeon,
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentsList(List<Map<String, dynamic>> installments) {
    if (installments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد أقساط',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInstallments,
      color: AppColors.goldenNeon,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
        itemCount: installments.length,
        itemBuilder: (context, index) {
          final installment = installments[index];
          return _buildInstallmentCard(installment);
        },
      ),
    );
  }

  Widget _buildInstallmentCard(Map<String, dynamic> installment) {
    final status = installment['status'] as String;
    final customerName = installment['customer_name'] ?? 'غير محدد';
    final totalAmount = (installment['total_amount'] as num?)?.toDouble() ?? 0.0;
    final remainingAmount = (installment['remaining_amount'] as num?)?.toDouble() ?? 0.0;
    final paidInstallments = installment['paid_installments'] as int? ?? 0;
    final totalInstallments = installment['installments_count'] as int? ?? 0;
    final monthlyInstallment = (installment['monthly_installment'] as num?)?.toDouble() ?? 0.0;
    
    final isOverdue = _overdueInstallments.contains(installment);
    final statusColor = _getStatusColor(status, isOverdue);
    final statusText = _getStatusText(status, isOverdue);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.person,
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
                            customerName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            installment['customer_phone'] ?? '',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          
          // المبالغ
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(
                  'المبلغ الكلي',
                  '${totalAmount.toStringAsFixed(0)} ج',
                  AppColors.textPrimary,
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  'المتبقي',
                  '${remainingAmount.toStringAsFixed(0)} ج',
                  statusColor,
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  'القسط الشهري',
                  '${monthlyInstallment.toStringAsFixed(0)} ج',
                  AppColors.goldenNeon,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // التقدم
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'التقدم',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '$paidInstallments / $totalInstallments',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: totalInstallments > 0
                            ? paidInstallments / totalInstallments
                            : 0.0,
                        backgroundColor: AppColors.border.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // معلومات إضافية
          if (installment['invoice_id'] != null)
            Row(
              children: [
                Icon(Icons.receipt, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'فاتورة: ${installment['invoice_id']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, bool isOverdue) {
    if (isOverdue) return Colors.red;
    switch (status) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status, bool isOverdue) {
    if (isOverdue) return 'متأخر';
    switch (status) {
      case 'active':
        return 'نشط';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
