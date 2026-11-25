import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import '../domain/installment_request_models.dart';
import '../data/mock_installment_requests_api.dart';

/// ØµÙØ­Ø© ØªÙØ§ØµÙŠÙ„ Ø·Ù„Ø¨ Ø§Ù„ØªÙ‚Ø³ÙŠØ·
/// 
/// Ù„Ù„Ù…Ø§Ù„Ùƒ: Ø¹Ø±Ø¶ Ø§Ù„ØªÙØ§ØµÙŠÙ„ + Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø©/Ø§Ù„Ø±ÙØ¶
/// Ù„Ù„Ù…Ø¯ÙŠØ±: Ø¹Ø±Ø¶ Ø§Ù„ØªÙØ§ØµÙŠÙ„ ÙÙ‚Ø·
class InstallmentRequestDetailsPage extends StatefulWidget {
  final InstallmentRequest request;
  final String userRole; // 'owner' or 'manager'

  const InstallmentRequestDetailsPage({
    super.key,
    required this.request,
    required this.userRole,
  });

  @override
  State<InstallmentRequestDetailsPage> createState() =>
      _InstallmentRequestDetailsPageState();
}

class _InstallmentRequestDetailsPageState
    extends State<InstallmentRequestDetailsPage> {
  final _api = MockInstallmentRequestsApi();
  final _rejectionReasonController = TextEditingController();
  
  bool _isProcessing = false;
  late InstallmentRequest _currentRequest;

  @override
  void initState() {
    super.initState();
    _currentRequest = widget.request;
  }

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }

  Future<void> _approveRequest() async {
    // ØªØ£ÙƒÙŠØ¯ Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø©
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'ØªØ£ÙƒÙŠØ¯ Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø©',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø© Ø¹Ù„Ù‰ Ø·Ù„Ø¨ Ø§Ù„ØªÙ‚Ø³ÙŠØ·ØŸ\n\n'
          'Ø³ÙŠØªÙ… Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ù‚Ø³Ø· Ù„Ø­Ø³Ø§Ø¨ ${_currentRequest.customerName}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Ù…ÙˆØ§ÙÙ‚Ø©'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final decision = InstallmentRequestDecision(
        requestId: _currentRequest.id,
        approved: true,
        reviewedBy: 'OWNER-001', // TODO: Get from current user
        reviewedByName: 'Ø£Ø­Ù…Ø¯ Ø§Ù„Ù…Ø§Ù„Ùƒ', // TODO: Get from current user
        reviewedAt: DateTime.now(),
      );

      final updatedRequest = await _api.approveRequest(decision);

      if (mounted) {
        setState(() {
          _currentRequest = updatedRequest;
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('ØªÙ…Øª Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø© Ø¹Ù„Ù‰ Ø§Ù„Ø·Ù„Ø¨ Ø¨Ù†Ø¬Ø§Ø­'),
                ),
              ],
            ),
            backgroundColor: AppColors.successDark,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Ø§Ù„Ø¹ÙˆØ¯Ø© Ù…Ø¹ ØªØ­Ø¯ÙŠØ«
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ExceptionHandler.logException(e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ø®Ø·Ø£ ÙÙŠ Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø©: ${e.toString()}'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _rejectRequest() async {
    // ÙØªØ­ dialog Ù„Ø¥Ø¯Ø®Ø§Ù„ Ø³Ø¨Ø¨ Ø§Ù„Ø±ÙØ¶
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Ø±ÙØ¶ Ø§Ù„Ø·Ù„Ø¨',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ÙŠØ±Ø¬Ù‰ ØªØ­Ø¯ÙŠØ¯ Ø³Ø¨Ø¨ Ø±ÙØ¶ Ø§Ù„Ø·Ù„Ø¨:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rejectionReasonController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Ø§ÙƒØªØ¨ Ø³Ø¨Ø¨ Ø§Ù„Ø±ÙØ¶ Ù‡Ù†Ø§...',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _rejectionReasonController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Ø¥Ù„ØºØ§Ø¡'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = _rejectionReasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø³Ø¨Ø¨ Ø§Ù„Ø±ÙØ¶'),
                    backgroundColor: AppColors.errorDark,
                  ),
                );
                return;
              }
              Navigator.of(context).pop(reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorDark,
            ),
            child: const Text('Ø±ÙØ¶ Ø§Ù„Ø·Ù„Ø¨'),
          ),
        ],
      ),
    );

    if (reason == null || reason.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final decision = InstallmentRequestDecision(
        requestId: _currentRequest.id,
        approved: false,
        rejectionReason: reason,
        reviewedBy: 'OWNER-001', // TODO: Get from current user
        reviewedByName: 'Ø£Ø­Ù…Ø¯ Ø§Ù„Ù…Ø§Ù„Ùƒ', // TODO: Get from current user
        reviewedAt: DateTime.now(),
      );

      final updatedRequest = await _api.rejectRequest(decision);

      if (mounted) {
        setState(() {
          _currentRequest = updatedRequest;
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.block, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('ØªÙ… Ø±ÙØ¶ Ø§Ù„Ø·Ù„Ø¨'),
                ),
              ],
            ),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Ø§Ù„Ø¹ÙˆØ¯Ø© Ù…Ø¹ ØªØ­Ø¯ÙŠØ«
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      ExceptionHandler.logException(e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ø®Ø·Ø£ ÙÙŠ Ø§Ù„Ø±ÙØ¶: ${e.toString()}'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _rejectionReasonController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(_currentRequest.requestNumber),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(_currentRequest.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _currentRequest.status.displayName,
              style: TextStyle(
                color: _getStatusColor(_currentRequest.status),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
        children: [
          // Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹Ù…ÙŠÙ„
          _buildSection(
            title: 'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹Ù…ÙŠÙ„',
            icon: Icons.person,
            children: [
              _buildDetailRow(
                icon: Icons.person_outline,
                label: 'Ø§Ø³Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„',
                value: _currentRequest.customerName,
              ),
              _buildDetailRow(
                icon: Icons.badge,
                label: 'Ø±Ù‚Ù… Ø§Ù„Ø¹Ù…ÙŠÙ„',
                value: _currentRequest.customerId,
              ),
              _buildDetailRow(
                icon: Icons.phone,
                label: 'Ø±Ù‚Ù… Ø§Ù„Ù‡Ø§ØªÙ',
                value: _currentRequest.customerPhone,
              ),
              _buildDetailRow(
                icon: Icons.credit_card,
                label: 'Ø§Ù„Ø±Ù‚Ù… Ø§Ù„Ù‚ÙˆÙ…ÙŠ',
                value: _currentRequest.nationalId,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙØ§ØªÙˆØ±Ø©
          _buildSection(
            title: 'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„ÙØ§ØªÙˆØ±Ø©',
            icon: Icons.receipt_long,
            children: [
              _buildDetailRow(
                icon: Icons.receipt,
                label: 'Ø±Ù‚Ù… Ø§Ù„ÙØ§ØªÙˆØ±Ø©',
                value: _currentRequest.invoiceId,
              ),
              _buildDetailRow(
                icon: Icons.attach_money,
                label: 'Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ø¥Ø¬Ù…Ø§Ù„ÙŠ',
                value: '${_currentRequest.totalAmount.toStringAsFixed(2)} Ø¬Ù†ÙŠÙ‡',
                valueColor: AppColors.goldenNeon,
                isHighlighted: true,
              ),
              _buildDetailRow(
                icon: Icons.payments,
                label: 'Ø§Ù„Ø¯ÙØ¹Ø© Ø§Ù„Ø£ÙˆÙ„Ù‰',
                value: '${_currentRequest.downPayment.toStringAsFixed(2)} Ø¬Ù†ÙŠÙ‡',
              ),
              _buildDetailRow(
                icon: Icons.calculate,
                label: 'Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ù…ØªØ¨Ù‚ÙŠ',
                value: '${_currentRequest.remainingAmount.toStringAsFixed(2)} Ø¬Ù†ÙŠÙ‡',
                valueColor: AppColors.textPrimary,
                isHighlighted: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙ‚Ø³ÙŠØ·
          _buildSection(
            title: 'ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙ‚Ø³ÙŠØ·',
            icon: Icons.payment,
            children: [
              _buildDetailRow(
                icon: Icons.money,
                label: 'Ù‚ÙŠÙ…Ø© Ø§Ù„Ù‚Ø³Ø·',
                value: '${_currentRequest.installmentAmount.toStringAsFixed(2)} Ø¬Ù†ÙŠÙ‡',
                valueColor: AppColors.goldenNeon,
                isHighlighted: true,
              ),
              _buildDetailRow(
                icon: Icons.numbers,
                label: 'Ø¹Ø¯Ø¯ Ø§Ù„Ø£Ù‚Ø³Ø§Ø·',
                value: '${_currentRequest.numberOfInstallments} Ù‚Ø³Ø·',
              ),
              _buildDetailRow(
                icon: Icons.calendar_today,
                label: 'Ù…ÙˆØ¹Ø¯ Ø£ÙˆÙ„ Ø¯ÙØ¹Ø©',
                value:
                    '${_currentRequest.firstPaymentDate.day}/${_currentRequest.firstPaymentDate.month}/${_currentRequest.firstPaymentDate.year}',
              ),
              _buildDetailRow(
                icon: Icons.schedule,
                label: 'ÙØªØ±Ø© Ø§Ù„Ø³Ø¯Ø§Ø¯',
                value: _currentRequest.paymentIntervalArabic,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø·Ù„Ø¨
          _buildSection(
            title: 'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø·Ù„Ø¨',
            icon: Icons.info,
            children: [
              _buildDetailRow(
                icon: Icons.store,
                label: 'Ø§Ù„ÙØ±Ø¹',
                value: _currentRequest.branchName,
              ),
              _buildDetailRow(
                icon: Icons.person_outline,
                label: 'Ù…Ù‚Ø¯Ù… Ø§Ù„Ø·Ù„Ø¨',
                value: _currentRequest.requestedByName,
              ),
              _buildDetailRow(
                icon: Icons.access_time,
                label: 'ØªØ§Ø±ÙŠØ® Ø§Ù„ØªÙ‚Ø¯ÙŠÙ…',
                value:
                    '${_currentRequest.createdAt.day}/${_currentRequest.createdAt.month}/${_currentRequest.createdAt.year} - ${_currentRequest.createdAt.hour}:${_currentRequest.createdAt.minute.toString().padLeft(2, '0')}',
              ),
              if (_currentRequest.notes != null &&
                  _currentRequest.notes!.isNotEmpty)
                _buildDetailRow(
                  icon: Icons.note,
                  label: 'Ù…Ù„Ø§Ø­Ø¸Ø§Øª',
                  value: _currentRequest.notes!,
                  isMultiline: true,
                ),
            ],
          ),

          // Ø¥Ø°Ø§ ØªÙ…Øª Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©
          if (!_currentRequest.isPending) ...[
            const SizedBox(height: 20),
            _buildSection(
              title: 'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©',
              icon: Icons.check_circle,
              children: [
                _buildDetailRow(
                  icon: Icons.person,
                  label: 'Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹',
                  value: _currentRequest.reviewedByName ?? 'ØºÙŠØ± Ù…Ø­Ø¯Ø¯',
                ),
                if (_currentRequest.reviewedAt != null)
                  _buildDetailRow(
                    icon: Icons.access_time,
                    label: 'ØªØ§Ø±ÙŠØ® Ø§Ù„Ù…Ø±Ø§Ø¬Ø¹Ø©',
                    value:
                        '${_currentRequest.reviewedAt!.day}/${_currentRequest.reviewedAt!.month}/${_currentRequest.reviewedAt!.year} - ${_currentRequest.reviewedAt!.hour}:${_currentRequest.reviewedAt!.minute.toString().padLeft(2, '0')}',
                  ),
                if (_currentRequest.isRejected &&
                    _currentRequest.rejectionReason != null)
                  _buildDetailRow(
                    icon: Icons.block,
                    label: 'Ø³Ø¨Ø¨ Ø§Ù„Ø±ÙØ¶',
                    value: _currentRequest.rejectionReason!,
                    valueColor: AppColors.errorDark,
                    isMultiline: true,
                  ),
              ],
            ),
          ],

          // Ø£Ø²Ø±Ø§Ø± Ø§Ù„Ù…ÙˆØ§ÙÙ‚Ø©/Ø§Ù„Ø±ÙØ¶ (Ù„Ù„Ù…Ø§Ù„Ùƒ ÙÙ‚Ø·)
          if (widget.userRole == 'owner' && _currentRequest.isPending) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _rejectRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.block),
                    label: const Text(
                      'Ø±ÙØ¶',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _approveRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'Ù…ÙˆØ§ÙÙ‚Ø©',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.goldenNeon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isHighlighted = false,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 16,
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
                    color: valueColor ?? AppColors.textPrimary,
                    fontSize: isHighlighted ? 16 : 14,
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
