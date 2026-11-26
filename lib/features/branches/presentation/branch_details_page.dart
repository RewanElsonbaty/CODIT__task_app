import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_branches_api.dart';

/// صفحة تفاصيل الفرع
/// 
/// تعرض:
/// - اسم الفرع والعنوان
/// - اسم مدير الفرع
/// - الموظفين
/// - التقارير
/// - الأقساط (قابلة للنقر)
class BranchDetailsPage extends StatefulWidget {
  final String branchId;

  const BranchDetailsPage({
    super.key,
    required this.branchId,
  });

  @override
  State<BranchDetailsPage> createState() => _BranchDetailsPageState();
}

class _BranchDetailsPageState extends State<BranchDetailsPage> {
  final _api = MockBranchesApi();
  
  Map<String, dynamic>? _branchData;
  List<Map<String, dynamic>> _employees = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBranchDetails();
  }

  Future<void> _loadBranchDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // تحميل بيانات الفرع
      final branchResponse = await _api.getBranchDetails(widget.branchId);
      
      if (branchResponse['success'] == true) {
        final branch = branchResponse['data'] as Map<String, dynamic>;
        
        // تحميل الموظفين
        final employeesResponse = await _api.getBranchEmployees(widget.branchId);
        final employees = employeesResponse['success'] == true
            ? (employeesResponse['data'] as List).cast<Map<String, dynamic>>()
            : <Map<String, dynamic>>[];
        
        // تحميل الإحصائيات
        final statsResponse = await _api.getBranchStatistics(widget.branchId);
        final stats = statsResponse['success'] == true
            ? (statsResponse['data'] as Map<String, dynamic>)
            : <String, dynamic>{};

        if (mounted) {
          setState(() {
            _branchData = branch;
            _employees = employees;
            _stats = stats;
            _isLoading = false;
          });
        }
      } else {
        throw Exception(branchResponse['message'] ?? 'فشل تحميل بيانات الفرع');
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
        title: Text(
          _branchData != null ? _branchData!['name'] : 'تفاصيل الفرع',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.goldenNeon),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.goldenNeon),
            )
          : _errorMessage != null
              ? _buildErrorView()
              : _buildContent(),
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
            Text(
              'حدث خطأ',
              style: const TextStyle(
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
              onPressed: _loadBranchDetails,
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

  Widget _buildContent() {
    if (_branchData == null) return const SizedBox.shrink();

    return ListView(
      padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
      children: [
        // معلومات الفرع الأساسية
        _buildInfoCard(),
        
        const SizedBox(height: 16),
        
        // إحصائيات سريعة
        _buildStatsCards(),
        
        const SizedBox(height: 16),
        
        // مدير الفرع
        _buildManagerCard(),
        
        const SizedBox(height: 16),
        
        // الموظفين
        _buildEmployeesCard(),
        
        const SizedBox(height: 16),
        
        // الأقساط (قابلة للنقر)
        _buildInstallmentsCard(),
        
        const SizedBox(height: 16),
        
        // التقارير
        _buildReportsCard(),
        
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildInfoCard() {
    final branch = _branchData!;
    final isActive = branch['status'] == 'active';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.purple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.store,
                  color: Colors.purple,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch['name'] ?? 'غير محدد',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive ? Icons.check_circle : Icons.cancel,
                                color: isActive ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isActive ? 'نشط' : 'غير نشط',
                                style: TextStyle(
                                  color: isActive ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.location_on,
            'العنوان',
            branch['address'] ?? 'غير محدد',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.phone,
            'رقم الهاتف',
            branch['phone'] ?? 'غير محدد',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.alternate_email,
            'البريد الإلكتروني',
            branch['email'] ?? 'غير محدد',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    if (_stats == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'الموظفين',
            '${_stats!['employees_count'] ?? 0}',
            Icons.people,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'الأقساط',
            '${_stats!['active_installments'] ?? 0}',
            Icons.payment,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'المبيعات',
            '${(_stats!['total_sales'] ?? 0.0).toStringAsFixed(0)} ج',
            Icons.attach_money,
            AppColors.goldenNeon,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerCard() {
    final managerName = _branchData!['manager_name'] ?? 'غير محدد';
    final managerId = _branchData!['manager_id'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'مدير الفرع',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.2),
                child: Icon(Icons.person, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      managerName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (managerId != null)
                      Text(
                        'ID: $managerId',
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
        ],
      ),
    );
  }

  Widget _buildEmployeesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'الموظفين',
                    style: TextStyle(
                      color: AppColors.goldenNeon,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_employees.length}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_employees.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'لا يوجد موظفين',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ),
            )
          else
            ...List.generate(
              _employees.length.clamp(0, 5), // عرض أول 5 موظفين فقط
              (index) {
                final employee = _employees[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee['name'] ?? 'غير محدد',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              employee['role'] ?? 'غير محدد',
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
                );
              },
            ),
          if (_employees.length > 5)
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: عرض جميع الموظفين
                },
                child: Text(
                  'عرض الكل (${_employees.length})',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstallmentsCard() {
    final activeInstallments = _stats?['active_installments'] ?? 0;
    final overdueInstallments = _stats?['overdue_installments'] ?? 0;

    return InkWell(
      onTap: () {
        // الانتقال لصفحة أقساط الفرع
        context.push('/branch-installments/${widget.branchId}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.1),
              Colors.green.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.payment, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'الأقساط',
                      style: TextStyle(
                        color: AppColors.goldenNeon,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat('نشط', '$activeInstallments', Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat('متأخر', '$overdueInstallments', Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'اضغط لعرض جميع أقساط الفرع',
                style: TextStyle(
                  color: Colors.green.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assessment, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'التقارير',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReportItem(
            Icons.trending_up,
            'تقرير المبيعات',
            'عرض مبيعات الفرع',
            () {
              // TODO: Navigate to sales report
            },
          ),
          _buildReportItem(
            Icons.payment,
            'تقرير الأقساط',
            'عرض أقساط الفرع',
            () {
              context.push('/branch-installments/${widget.branchId}');
            },
          ),
          _buildReportItem(
            Icons.people,
            'تقرير الموظفين',
            'عرض أداء الموظفين',
            () {
              // TODO: Navigate to employees report
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}
