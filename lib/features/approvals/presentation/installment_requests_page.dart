import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import '../domain/installment_request_models.dart';
import '../data/mock_installment_requests_api.dart';
import 'installment_request_details_page.dart';

/// ØµÙØ­Ø© Ø¹Ø±Ø¶ Ø·Ù„Ø¨Ø§Øª Ø§Ù„ØªÙ‚Ø³ÙŠØ·
/// 
/// Ù„Ù„Ù…Ø§Ù„Ùƒ: Ø¹Ø±Ø¶ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø¹Ù„Ù‚Ø© + Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø©/Ø§Ù„Ø±ÙØ¶
/// Ù„Ù„Ù…Ø¯ÙŠØ±: Ø¹Ø±Ø¶ Ø·Ù„Ø¨Ø§ØªÙ‡ ÙÙ‚Ø·
class InstallmentRequestsPage extends StatefulWidget {
  final String userRole; // 'owner' or 'manager'
  final String? branchId; // Ù„Ù„Ù…Ø¯ÙŠØ± ÙÙ‚Ø·

  const InstallmentRequestsPage({
    super.key,
    required this.userRole,
    this.branchId,
  });

  @override
  State<InstallmentRequestsPage> createState() =>
      _InstallmentRequestsPageState();
}

class _InstallmentRequestsPageState extends State<InstallmentRequestsPage>
    with SingleTickerProviderStateMixin {
  final _api = MockInstallmentRequestsApi();

  late TabController _tabController;
  List<InstallmentRequest> _allRequests = [];
  List<InstallmentRequest> _pendingRequests = [];
  List<InstallmentRequest> _approvedRequests = [];
  List<InstallmentRequest> _rejectedRequests = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final requests = await _api.getAllRequests(
        branchId: widget.userRole == 'manager' ? widget.branchId : null,
      );

      if (mounted) {
        setState(() {
          _allRequests = requests;
          _pendingRequests = requests
              .where((r) => r.status == InstallmentRequestStatus.pending)
              .toList();
          _approvedRequests = requests
              .where((r) => r.status == InstallmentRequestStatus.approved)
              .toList();
          _rejectedRequests = requests
              .where((r) => r.status == InstallmentRequestStatus.rejected)
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      ExceptionHandler.logException(e);
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openRequestDetails(InstallmentRequest request) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => InstallmentRequestDetailsPage(
          request: request,
          userRole: widget.userRole,
        ),
      ),
    );

    // Ø¥Ø°Ø§ ØªÙ… Ø§Ù„ØªØ¹Ø¯ÙŠÙ„ØŒ Ø£Ø¹Ø¯ ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ù‚Ø§Ø¦Ù…Ø©
    if (result == true) {
      _loadRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Ø·Ù„Ø¨Ø§Øª Ø§Ù„ØªÙ‚Ø³ÙŠØ·'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.goldenNeon,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.goldenNeon,
          tabs: [
            Tab(
              text: 'Ø§Ù„ÙƒÙ„',
              icon: Badge(
                label: Text(_allRequests.length.toString()),
                child: const Icon(Icons.list),
              ),
            ),
            Tab(
              text: 'Ù…Ø¹Ù„Ù‚',
              icon: Badge(
                label: Text(_pendingRequests.length.toString()),
                backgroundColor: AppColors.warning,
                child: const Icon(Icons.pending),
              ),
            ),
            Tab(
              text: 'Ù…ÙˆØ§ÙÙ‚',
              icon: Badge(
                label: Text(_approvedRequests.length.toString()),
                backgroundColor: AppColors.success,
                child: const Icon(Icons.check_circle),
              ),
            ),
            Tab(
              text: 'Ù…Ø±ÙÙˆØ¶',
              icon: Badge(
                label: Text(_rejectedRequests.length.toString()),
                backgroundColor: AppColors.errorDark,
                child: const Icon(Icons.cancel),
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
                    _buildRequestsList(_allRequests),
                    _buildRequestsList(_pendingRequests),
                    _buildRequestsList(_approvedRequests),
                    _buildRequestsList(_rejectedRequests),
                  ],
                ),
      floatingActionButton: widget.userRole == 'manager'
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.of(context).pushNamed(
                  '/create-installment-request',
                );
                if (result != null) {
                  _loadRequests();
                }
              },
              backgroundColor: AppColors.goldenNeon,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: const Text('Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯'),
            )
          : null,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorDark,
            ),
            const SizedBox(height: 16),
            Text(
              'Ø­Ø¯Ø« Ø®Ø·Ø£ ÙÙŠ ØªØ­Ù…ÙŠÙ„ Ø§Ù„Ø·Ù„Ø¨Ø§Øª',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? '',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadRequests,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenNeon,
                foregroundColor: Colors.black,
              ),
              child: const Text('Ø¥Ø¹Ø§Ø¯Ø© Ø§Ù„Ù…Ø­Ø§ÙˆÙ„Ø©'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(List<InstallmentRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø·Ù„Ø¨Ø§Øª',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      color: AppColors.goldenNeon,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return _buildRequestCard(requests[index]);
        },
      ),
    );
  }

  Widget _buildRequestCard(InstallmentRequest request) {
    return GestureDetector(
      onTap: () => _openRequestDetails(request),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: request.isPending
              ? LinearGradient(
                  colors: [
                    AppColors.goldenNeon.withOpacity(0.1),
                    AppColors.goldenNeon.withOpacity(0.05),
                  ],
                )
              : null,
          color: request.isPending ? null : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: request.isPending
                ? AppColors.goldenNeon
                : AppColors.border.withOpacity(0.3),
            width: request.isPending ? 2 : 1,
          ),
          boxShadow: request.isPending
              ? [
                  BoxShadow(
                    color: AppColors.goldenGlow.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status.displayName,
                    style: TextStyle(
                      color: _getStatusColor(request.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  request.requestNumber,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Customer Info
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.goldenNeon,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.customerName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        request.customerPhone,
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
            const SizedBox(height: 12),

            const Divider(color: AppColors.border),
            const SizedBox(height: 12),

            // Financial Details
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.attach_money,
                    label: 'Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ',
                    value: '${request.totalAmount.toStringAsFixed(0)} Ø¬Ù†ÙŠÙ‡',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.payments,
                    label: 'Ø§Ù„Ù‚Ø³Ø· Ø§Ù„Ø´Ù‡Ø±ÙŠ',
                    value: '${request.installmentAmount.toStringAsFixed(0)} Ø¬Ù†ÙŠÙ‡',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.numbers,
                    label: 'Ø¹Ø¯Ø¯ Ø§Ù„Ø£Ù‚Ø³Ø§Ø·',
                    value: '${request.numberOfInstallments} Ù‚Ø³Ø·',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.calendar_today,
                    label: 'Ø£ÙˆÙ„ Ø¯ÙØ¹Ø©',
                    value:
                        '${request.firstPaymentDate.day}/${request.firstPaymentDate.month}/${request.firstPaymentDate.year}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),

            // Branch & Requester
            Row(
              children: [
                const Icon(
                  Icons.store,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  request.branchName,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  request.requestedByName.split(' - ').first,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // Show rejection reason if rejected
            if (request.isRejected && request.rejectionReason != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorDark.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.errorDark.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.errorDark,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ø³Ø¨Ø¨ Ø§Ù„Ø±ÙØ¶: ${request.rejectionReason}',
                        style: const TextStyle(
                          color: AppColors.errorDark,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(InstallmentRequestStatus status) {
    switch (status) {
      case InstallmentRequestStatus.pending:
        return AppColors.warning;
      case InstallmentRequestStatus.approved:
        return AppColors.success;
      case InstallmentRequestStatus.rejected:
        return AppColors.errorDark;
      case InstallmentRequestStatus.cancelled:
        return AppColors.textSecondary;
    }
  }
}
