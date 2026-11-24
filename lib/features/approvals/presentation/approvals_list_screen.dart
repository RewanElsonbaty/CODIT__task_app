import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/features/approvals/data/mock_approvals_api.dart';

/// شاشة قائمة الموافقات
class ApprovalsListScreen extends StatefulWidget {
  final String userId;
  final String userRole;

  const ApprovalsListScreen({
    super.key,
    required this.userId,
    required this.userRole,
  });

  @override
  State<ApprovalsListScreen> createState() => _ApprovalsListScreenState();
}

class _ApprovalsListScreenState extends State<ApprovalsListScreen>
    with SingleTickerProviderStateMixin {
  final _api = MockApprovalsApi();
  late TabController _tabController;

  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _allRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Get pending requests for this user
      final pendingResult = await _api.getPendingRequests(
        userId: widget.userId,
      );

      // Get all requests history
      final historyResult = await _api.getApprovalHistory(
        from: DateTime.now().subtract(const Duration(days: 30)),
        to: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _pendingRequests = List<Map<String, dynamic>>.from(
            pendingResult['data']['requests'] as List,
          );
          _allRequests = List<Map<String, dynamic>>.from(
            historyResult['data']['requests'] as List,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تحميل البيانات: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredRequests(String status) {
    if (status == 'pending') return _pendingRequests;
    return _allRequests.where((r) => r['status'] == status).toList();
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
              child: const Icon(
                Icons.approval,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'الموافقات',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.goldenNeon,
          labelColor: AppColors.goldenNeon,
          unselectedLabelColor: AppColors.textSecondary,
          isScrollable: isMobile,
          tabs: [
            Tab(child: _buildTabHeader('معلقة', _pendingRequests.length)),
            Tab(
              child: _buildTabHeader(
                'موافق عليها',
                _getFilteredRequests('approved').length,
              ),
            ),
            Tab(
              child: _buildTabHeader(
                'مرفوضة',
                _getFilteredRequests('rejected').length,
              ),
            ),
            Tab(
              child: _buildTabHeader(
                'ملغاة',
                _getFilteredRequests('cancelled').length,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRequestsList('pending'),
                _buildRequestsList('approved'),
                _buildRequestsList('rejected'),
                _buildRequestsList('cancelled'),
              ],
            ),
    );
  }

  Widget _buildTabHeader(String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        if (count > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.goldenNeon,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRequestsList(String status) {
    final requests = _getFilteredRequests(status);

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد طلبات',
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
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return _buildRequestCard(request);
        },
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final status = request['status'] as String;
    final priority = request['priority'] as String;
    final type = request['type'] as String;
    final createdAt = DateTime.parse(request['created_at'] as String);

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'pending':
        statusColor = AppColors.warningDark;
        statusIcon = Icons.pending_outlined;
        break;
      case 'approved':
        statusColor = AppColors.successDark;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'rejected':
        statusColor = AppColors.errorDark;
        statusIcon = Icons.cancel_outlined;
        break;
      case 'cancelled':
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.block_outlined;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priority == 'high'
              ? AppColors.errorDark
              : AppColors.goldenNeon.withOpacity(0.3),
          width: priority == 'high' ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed('/approval-details', arguments: request);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Priority Badge
                  if (priority == 'high')
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorDark.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.priority_high,
                            size: 14,
                            color: AppColors.errorLight,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'عاجل',
                            style: TextStyle(
                              color: AppColors.errorLight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(status),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                request['title'] as String,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                request['description'] as String,
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.9),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  // Type
                  Icon(
                    _getTypeIcon(type),
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getTypeText(type),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),

                  const Spacer(),

                  // Time
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getTimeAgo(createdAt),
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'معلقة';
      case 'approved':
        return 'موافق';
      case 'rejected':
        return 'مرفوض';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'discount':
        return Icons.discount_outlined;
      case 'return':
        return Icons.keyboard_return_outlined;
      case 'price_override':
        return Icons.price_change_outlined;
      default:
        return Icons.request_quote_outlined;
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'discount':
        return 'خصم';
      case 'return':
        return 'إرجاع';
      case 'price_override':
        return 'تعديل سعر';
      default:
        return type;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
