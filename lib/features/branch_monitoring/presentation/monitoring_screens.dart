// ignore_for_file: unused_import, unused_field, unused_local_variable, unused_element
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../data/mock_monitoring_api.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 1. Monitoring Dashboard Screen
// ═══════════════════════════════════════════════════════════════════════════

class MonitoringDashboardScreen extends StatefulWidget {
  const MonitoringDashboardScreen({super.key});

  @override
  State<MonitoringDashboardScreen> createState() =>
      _MonitoringDashboardScreenState();
}

class _MonitoringDashboardScreenState extends State<MonitoringDashboardScreen> {
  final _api = MockMonitoringApi();
  String _selectedBranchId = 'branch_main';
  Map<String, dynamic>? _liveMetrics;
  List<Map<String, dynamic>> _branches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Simulate real-time updates
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final branchesResult = await _api.getAllBranches();
      final metricsResult = await _api.getLiveMetrics(_selectedBranchId);

      if (mounted) {
        setState(() {
          _branches = List<Map<String, dynamic>>.from(
            branchesResult['data']['branches'],
          );
          _liveMetrics = metricsResult['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.monitor, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text(
              'لوحة المراقبة',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlertsPanelScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isMobile
          ? _buildMobileLayout()
          : _buildTabletLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBranchSelector(),
          const SizedBox(height: 16),
          _buildMetricsGrid(),
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: Column(
              children: [
                _buildBranchSelector(),
                const SizedBox(height: 16),
                _buildMetricsGrid(),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: _buildQuickActions(),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: DropdownButton<String>(
        value: _selectedBranchId,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
        dropdownColor: AppColors.card,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.goldenNeon),
        items: _branches.map((branch) {
          return DropdownMenuItem<String>(
            value: branch['id'] as String,
            child: Text(branch['name'] as String),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedBranchId = value);
            _loadData();
          }
        },
      ),
    );
  }

  Widget _buildMetricsGrid() {
    if (_liveMetrics == null) return const SizedBox.shrink();

    final metrics = [
      _MetricData(
        'مبيعات اليوم',
        '${_liveMetrics!['today_sales_total'].toStringAsFixed(0)} ج.م',
        Icons.attach_money,
        AppColors.successDark,
      ),
      _MetricData(
        'عدد المبيعات',
        '${_liveMetrics!['today_sales_count']}',
        Icons.shopping_cart,
        AppColors.infoDark,
      ),
      _MetricData(
        'المستخدمين النشطين',
        '${_liveMetrics!['active_users']}',
        Icons.people,
        AppColors.warningDark,
      ),
      _MetricData(
        'قيمة المخزون',
        '${(_liveMetrics!['inventory_value'] / 1000000).toStringAsFixed(1)}M ج.م',
        Icons.inventory,
        AppColors.primary,
      ),
      _MetricData(
        'موافقات معلقة',
        '${_liveMetrics!['pending_approvals']}',
        Icons.pending_actions,
        AppColors.warningDark,
      ),
      _MetricData(
        'أقساط متأخرة',
        '${_liveMetrics!['overdue_installments']}',
        Icons.warning,
        AppColors.errorDark,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        return _buildMetricCard(metrics[index]);
      },
    );
  }

  Widget _buildMetricCard(_MetricData metric) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [metric.color.withOpacity(0.2), AppColors.card],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: metric.color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(metric.icon, color: metric.color, size: 32),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: TextStyle(
              color: metric.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            metric.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'إجراءات سريعة',
            style: TextStyle(
              color: AppColors.goldenNeon,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton('المخزون', Icons.inventory, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    InventoryTrackingScreen(branchId: _selectedBranchId),
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildActionButton('المستخدمين النشطين', Icons.people, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ActiveUsersScreen(branchId: _selectedBranchId),
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildActionButton('مقارنة الفروع', Icons.compare_arrows, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BranchComparisonScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _MetricData(this.label, this.value, this.icon, this.color);
}

// ═══════════════════════════════════════════════════════════════════════════
// 2. Branch Comparison Screen
// ═══════════════════════════════════════════════════════════════════════════

class BranchComparisonScreen extends StatefulWidget {
  const BranchComparisonScreen({super.key});

  @override
  State<BranchComparisonScreen> createState() => _BranchComparisonScreenState();
}

class _BranchComparisonScreenState extends State<BranchComparisonScreen> {
  final _api = MockMonitoringApi();
  List<Map<String, dynamic>> _performance = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final result = await _api.getBranchesPerformance(
        from: DateTime.now().subtract(const Duration(days: 7)),
        to: DateTime.now(),
      );

      if (result['success'] && mounted) {
        setState(() {
          _performance = List<Map<String, dynamic>>.from(
            result['data']['performance'],
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'مقارنة الفروع',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _performance.isEmpty
          ? const Center(
              child: Text(
                'لا توجد بيانات',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
              itemCount: _performance.length,
              itemBuilder: (context, index) {
                final branch = _performance[index];
                return _buildBranchCard(branch, index + 1);
              },
            ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.card, AppColors.background],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rank == 1
              ? AppColors.goldenNeon
              : AppColors.border.withOpacity(0.3),
          width: rank == 1 ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: rank == 1
                      ? AppColors.goldenNeon.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rank == 1 ? AppColors.goldenNeon : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  branch['branch_name'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  'المبيعات',
                  '${(branch['total_sales'] / 1000).toStringAsFixed(1)}K ج.م',
                  AppColors.successDark,
                ),
              ),
              Expanded(
                child: _buildStat(
                  'العمليات',
                  '${branch['total_transactions']}',
                  AppColors.infoDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 3. Inventory Tracking Screen
// ═══════════════════════════════════════════════════════════════════════════

class InventoryTrackingScreen extends StatefulWidget {
  final String branchId;

  const InventoryTrackingScreen({super.key, required this.branchId});

  @override
  State<InventoryTrackingScreen> createState() =>
      _InventoryTrackingScreenState();
}

class _InventoryTrackingScreenState extends State<InventoryTrackingScreen> {
  final _api = MockMonitoringApi();
  Map<String, dynamic>? _inventory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final result = await _api.getBranchInventory(widget.branchId);
      if (result['success'] && mounted) {
        setState(() {
          _inventory = result['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'المخزون',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildInventoryList(),
    );
  }

  Widget _buildInventoryList() {
    if (_inventory == null) return const SizedBox.shrink();

    final items = List<Map<String, dynamic>>.from(_inventory!['inventory']);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.card,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTotalStat(
                'الإجمالي',
                '${(_inventory!['total_value'] / 1000000).toStringAsFixed(1)}M ج.م',
                AppColors.primary,
              ),
              _buildTotalStat(
                'الوزن',
                '${(_inventory!['total_weight'] / 1000).toStringAsFixed(1)}kg',
                AppColors.warningDark,
              ),
              _buildTotalStat(
                'القطع',
                '${_inventory!['total_items']}',
                AppColors.infoDark,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildInventoryCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${item['category']} - عيار ${item['karat']}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItemStat('القطع', '${item['items_count']}'),
              _buildItemStat(
                'الوزن',
                '${item['total_weight_grams'].toStringAsFixed(0)}g',
              ),
              _buildItemStat(
                'القيمة',
                '${(item['total_value'] / 1000).toStringAsFixed(0)}K ج.م',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 4. Active Users Screen
// ═══════════════════════════════════════════════════════════════════════════

class ActiveUsersScreen extends StatefulWidget {
  final String branchId;

  const ActiveUsersScreen({super.key, required this.branchId});

  @override
  State<ActiveUsersScreen> createState() => _ActiveUsersScreenState();
}

class _ActiveUsersScreenState extends State<ActiveUsersScreen> {
  final _api = MockMonitoringApi();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final result = await _api.getActiveUsers(widget.branchId);
      if (result['success'] && mounted) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(
            result['data']['active_users'],
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'المستخدمين النشطين',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(
              child: Text(
                'لا يوجد مستخدمين نشطين',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return _buildUserCard(user);
              },
            ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.successDark.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successDark.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.successLight),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['role'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'العمليات: ${user['transactions_count']}',
                  style: const TextStyle(
                    color: AppColors.infoDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.successDark.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'نشط',
              style: TextStyle(
                color: AppColors.successLight,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 5. Alerts Panel Screen
// ═══════════════════════════════════════════════════════════════════════════

class AlertsPanelScreen extends StatefulWidget {
  const AlertsPanelScreen({super.key});

  @override
  State<AlertsPanelScreen> createState() => _AlertsPanelScreenState();
}

class _AlertsPanelScreenState extends State<AlertsPanelScreen> {
  final _api = MockMonitoringApi();
  List<Map<String, dynamic>> _alerts = [];
  bool _isLoading = true;
  String _filterSeverity = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final result = await _api.getAlerts(
        severity: _filterSeverity == 'all' ? null : _filterSeverity,
      );

      if (result['success'] && mounted) {
        setState(() {
          _alerts = List<Map<String, dynamic>>.from(result['data']['alerts']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'التنبيهات',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onSelected: (value) {
              setState(() => _filterSeverity = value);
              _loadData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('الكل')),
              const PopupMenuItem(value: 'high', child: Text('عالي')),
              const PopupMenuItem(value: 'medium', child: Text('متوسط')),
              const PopupMenuItem(value: 'low', child: Text('منخفض')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
          ? const Center(
              child: Text(
                'لا توجد تنبيهات',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                final alert = _alerts[index];
                return _buildAlertCard(alert);
              },
            ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final severity = alert['severity'] as String;
    Color severityColor;

    switch (severity) {
      case 'high':
        severityColor = AppColors.errorDark;
        break;
      case 'medium':
        severityColor = AppColors.warningDark;
        break;
      case 'low':
        severityColor = AppColors.infoDark;
        break;
      default:
        severityColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [severityColor.withOpacity(0.1), AppColors.card],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: severityColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert['title'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  severity,
                  style: TextStyle(
                    color: severityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert['message'],
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(alert['created_at']),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Acknowledge alert
                  _api.acknowledgeAlert(
                    alertId: alert['id'],
                    userId: 'user_001',
                  );
                },
                child: const Text('تأكيد القراءة'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return 'منذ ${diff.inMinutes} دقيقة';
    return 'الآن';
  }
}
