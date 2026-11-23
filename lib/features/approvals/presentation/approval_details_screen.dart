import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../data/mock_approvals_api.dart';

/// شاشة تفاصيل طلب الموافقة
class ApprovalDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> request;

  const ApprovalDetailsScreen({super.key, required this.request});

  @override
  State<ApprovalDetailsScreen> createState() => _ApprovalDetailsScreenState();
}

class _ApprovalDetailsScreenState extends State<ApprovalDetailsScreen> {
  final _api = MockApprovalsApi();
  bool _isProcessing = false;
  late Map<String, dynamic> _currentRequest;

  @override
  void initState() {
    super.initState();
    _currentRequest = Map.from(widget.request);
  }

  Future<void> _approveRequest(String userId) async {
    if (!mounted) return;

    final confirmed = await _showConfirmDialog(
      title: 'تأكيد الموافقة',
      message: 'هل أنت متأكد من الموافقة على هذا الطلب؟',
      confirmText: 'موافق',
      isApprove: true,
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      final result = await _api.approveRequestFull(
        requestId: _currentRequest['id'],
        userId: userId,
        notes: null,
      );

      if (result['success'] == true && mounted) {
        setState(() {
          _currentRequest = result['data']['request'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت الموافقة بنجاح'),
            backgroundColor: AppColors.successDark,
          ),
        );

        if (_currentRequest['status'] == 'approved') {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.of(context).pop(true);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشلت الموافقة: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _rejectRequest(String userId) async {
    if (!mounted) return;

    final reason = await _showRejectDialog();
    if (reason == null) return;

    setState(() => _isProcessing = true);

    try {
      final result = await _api.rejectRequestFull(
        requestId: _currentRequest['id'],
        userId: userId,
        reason: reason,
      );

      if (result['success'] == true && mounted) {
        setState(() {
          _currentRequest = result['data'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم رفض الطلب'),
            backgroundColor: AppColors.errorDark,
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).pop(true);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الرفض: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    required bool isApprove,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove
                  ? AppColors.successDark
                  : AppColors.errorDark,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  Future<String?> _showRejectDialog() {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        title: const Text(
          'سبب الرفض',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'اكتب سبب رفض الطلب...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context, controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorDark,
            ),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final status = _currentRequest['status'] as String;
    final canTakeAction = status == 'pending' && !_isProcessing;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'تفاصيل الطلب',
          style: TextStyle(color: AppColors.textPrimary, fontFamily: 'Cairo'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isMobile ? _buildMobileLayout() : _buildTabletLayout(),
      bottomNavigationBar: canTakeAction ? _buildActionButtons(isMobile) : null,
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(),
          const SizedBox(height: 16),
          _buildBasicInfoCard(),
          const SizedBox(height: 16),
          _buildMetadataCard(),
          const SizedBox(height: 16),
          _buildApproversCard(),
          const SizedBox(height: 16),
          _buildTimelineCard(),
          const SizedBox(height: 80), // Space for bottom buttons
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildBasicInfoCard(),
                const SizedBox(height: 16),
                _buildMetadataCard(),
              ],
            ),
          ),
        ),

        // Right column
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildApproversCard(),
                const SizedBox(height: 16),
                _buildTimelineCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    final status = _currentRequest['status'] as String;
    final priority = _currentRequest['priority'] as String;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'pending':
        statusColor = AppColors.warningDark;
        statusIcon = Icons.pending_outlined;
        statusText = 'معلق';
        break;
      case 'approved':
        statusColor = AppColors.successDark;
        statusIcon = Icons.check_circle_outline;
        statusText = 'موافق عليه';
        break;
      case 'rejected':
        statusColor = AppColors.errorDark;
        statusIcon = Icons.cancel_outlined;
        statusText = 'مرفوض';
        break;
      case 'cancelled':
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.block_outlined;
        statusText = 'ملغي';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help_outline;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.2), statusColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(statusIcon, color: statusColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
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
                    const SizedBox(width: 8),
                    Text(
                      'النسخة: ${_currentRequest['version']}',
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
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'معلومات أساسية',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          _buildInfoRow('العنوان', _currentRequest['title']),
          const SizedBox(height: 12),
          _buildInfoRow('الوصف', _currentRequest['description']),
          const SizedBox(height: 12),
          _buildInfoRow('النوع', _getTypeText(_currentRequest['type'])),
          const SizedBox(height: 12),
          _buildInfoRow('مقدم الطلب', _currentRequest['requester_name']),
          const SizedBox(height: 12),
          _buildInfoRow(
            'تاريخ الإنشاء',
            _formatDate(_currentRequest['created_at']),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard() {
    final metadata = _currentRequest['metadata'] as Map<String, dynamic>?;
    if (metadata == null || metadata.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.data_object, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'تفاصيل إضافية',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          ...metadata.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildInfoRow(
                _formatKey(entry.key),
                entry.value.toString(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildApproversCard() {
    final approvers = _currentRequest['approvers'] as List;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people_outline, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'الموافقون',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          ...approvers.map((approver) {
            return _buildApproverItem(approver);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildApproverItem(Map<String, dynamic> approver) {
    final status = approver['status'] as String;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'pending':
        statusColor = AppColors.warningDark;
        statusIcon = Icons.pending;
        break;
      case 'approved':
        statusColor = AppColors.successDark;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = AppColors.errorDark;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  approver['role'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (approver['approved_at'] != null)
                  Text(
                    _formatDate(approver['approved_at']),
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
  }

  Widget _buildTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'المسار الزمني',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          _buildTimelineItem(
            'تم الإنشاء',
            _formatDate(_currentRequest['created_at']),
            Icons.add_circle_outline,
            AppColors.infoDark,
          ),
          if (_currentRequest['approved_at'] != null)
            _buildTimelineItem(
              'تمت الموافقة',
              _formatDate(_currentRequest['approved_at']),
              Icons.check_circle_outline,
              AppColors.successDark,
            ),
          if (_currentRequest['rejected_at'] != null)
            _buildTimelineItem(
              'تم الرفض',
              _formatDate(_currentRequest['rejected_at']),
              Icons.cancel_outlined,
              AppColors.errorDark,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    // TODO: Get actual user ID from auth state
    const userId = 'user_002';

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.goldenNeon, width: 2)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isProcessing ? null : () => _rejectRequest(userId),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.close),
                label: const Text('رفض'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.errorDark, width: 2),
                  foregroundColor: AppColors.errorDark,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : () => _approveRequest(userId),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: const Text('موافقة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
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

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) {
          return word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}
