import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import '../domain/installment_request_models.dart';
import '../data/mock_installment_requests_api.dart';

/// صفحة تفاصيل طلب التقسيط
/// 
/// للمالك: عرض التفاصيل + الموافقة/الرفض
/// للمدير: عرض التفاصيل فقط
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

  /// ?????? ?? ?????? ???????? ?? ?????
  /// ?????? ??????? ??????? ???????? ??????
  bool _canApproveOrReject() {
    return widget.userRole == 'owner' || widget.userRole == 'manager';
  }

  Future<void> _approveRequest() async {
    // تأكيد الموافقة
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'تأكيد الموافقة',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'هل أنت متأكد من الموافقة على طلب التقسيط؟\n\n'
          'سيتم إضافة القسط لحساب ${_currentRequest.customerName}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('موافقة'),
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
        reviewedByName: 'أحمد المالك', // TODO: Get from current user
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
                  child: Text('تمت الموافقة على الطلب بنجاح'),
                ),
              ],
            ),
            backgroundColor: AppColors.successDark,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // العودة مع تحديث
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
            content: Text('خطأ في الموافقة: ${e.toString()}'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _rejectRequest() async {
    // فتح dialog لإدخال سبب الرفض
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'رفض الطلب',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'يرجى تحديد سبب رفض الطلب:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rejectionReasonController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'اكتب سبب الرفض هنا...',
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
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = _rejectionReasonController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى إدخال سبب الرفض'),
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
            child: const Text('رفض الطلب'),
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
        reviewedByName: 'أحمد المالك', // TODO: Get from current user
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
                  child: Text('تم رفض الطلب'),
                ),
              ],
            ),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // العودة مع تحديث
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
            content: Text('خطأ في الرفض: ${e.toString()}'),
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
          // بيانات العميل
          _buildSection(
            title: 'بيانات العميل',
            icon: Icons.person,
            children: [
              _buildDetailRow(
                icon: Icons.person_outline,
                label: 'اسم العميل',
                value: _currentRequest.customerName,
              ),
              _buildDetailRow(
                icon: Icons.badge,
                label: 'رقم العميل',
                value: _currentRequest.customerId,
              ),
              _buildDetailRow(
                icon: Icons.phone,
                label: 'رقم الهاتف',
                value: _currentRequest.customerPhone,
              ),
              _buildDetailRow(
                icon: Icons.credit_card,
                label: 'الرقم القومي',
                value: _currentRequest.nationalId,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // بيانات الفاتورة
          _buildSection(
            title: 'بيانات الفاتورة',
            icon: Icons.receipt_long,
            children: [
              _buildDetailRow(
                icon: Icons.receipt,
                label: 'رقم الفاتورة',
                value: _currentRequest.invoiceId,
              ),
              _buildDetailRow(
                icon: Icons.attach_money,
                label: 'المبلغ الإجمالي',
                value: '${_currentRequest.totalAmount.toStringAsFixed(2)} جنيه',
                valueColor: AppColors.goldenNeon,
                isHighlighted: true,
              ),
              _buildDetailRow(
                icon: Icons.payments,
                label: 'الدفعة الأولى',
                value: '${_currentRequest.downPayment.toStringAsFixed(2)} جنيه',
              ),
              _buildDetailRow(
                icon: Icons.calculate,
                label: 'المبلغ المتبقي',
                value: '${_currentRequest.remainingAmount.toStringAsFixed(2)} جنيه',
                valueColor: AppColors.textPrimary,
                isHighlighted: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // تفاصيل التقسيط
          _buildSection(
            title: 'تفاصيل التقسيط',
            icon: Icons.payment,
            children: [
              _buildDetailRow(
                icon: Icons.money,
                label: 'قيمة القسط',
                value: '${_currentRequest.installmentAmount.toStringAsFixed(2)} جنيه',
                valueColor: AppColors.goldenNeon,
                isHighlighted: true,
              ),
              _buildDetailRow(
                icon: Icons.numbers,
                label: 'عدد الأقساط',
                value: '${_currentRequest.numberOfInstallments} قسط',
              ),
              _buildDetailRow(
                icon: Icons.calendar_today,
                label: 'موعد أول دفعة',
                value:
                    '${_currentRequest.firstPaymentDate.day}/${_currentRequest.firstPaymentDate.month}/${_currentRequest.firstPaymentDate.year}',
              ),
              _buildDetailRow(
                icon: Icons.schedule,
                label: 'فترة السداد',
                value: _currentRequest.paymentIntervalArabic,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // بيانات الطلب
          _buildSection(
            title: 'بيانات الطلب',
            icon: Icons.info,
            children: [
              _buildDetailRow(
                icon: Icons.store,
                label: 'الفرع',
                value: _currentRequest.branchName,
              ),
              _buildDetailRow(
                icon: Icons.person_outline,
                label: 'مقدم الطلب',
                value: _currentRequest.requestedByName,
              ),
              _buildDetailRow(
                icon: Icons.access_time,
                label: 'تاريخ التقديم',
                value:
                    '${_currentRequest.createdAt.day}/${_currentRequest.createdAt.month}/${_currentRequest.createdAt.year} - ${_currentRequest.createdAt.hour}:${_currentRequest.createdAt.minute.toString().padLeft(2, '0')}',
              ),
              if (_currentRequest.notes != null &&
                  _currentRequest.notes!.isNotEmpty)
                _buildDetailRow(
                  icon: Icons.note,
                  label: 'ملاحظات',
                  value: _currentRequest.notes!,
                  isMultiline: true,
                ),
            ],
          ),

          // إذا تمت المراجعة
          if (!_currentRequest.isPending) ...[
            const SizedBox(height: 20),
            _buildSection(
              title: 'بيانات المراجعة',
              icon: Icons.check_circle,
              children: [
                _buildDetailRow(
                  icon: Icons.person,
                  label: 'المراجع',
                  value: _currentRequest.reviewedByName ?? 'غير محدد',
                ),
                if (_currentRequest.reviewedAt != null)
                  _buildDetailRow(
                    icon: Icons.access_time,
                    label: 'تاريخ المراجعة',
                    value:
                        '${_currentRequest.reviewedAt!.day}/${_currentRequest.reviewedAt!.month}/${_currentRequest.reviewedAt!.year} - ${_currentRequest.reviewedAt!.hour}:${_currentRequest.reviewedAt!.minute.toString().padLeft(2, '0')}',
                  ),
                if (_currentRequest.isRejected &&
                    _currentRequest.rejectionReason != null)
                  _buildDetailRow(
                    icon: Icons.block,
                    label: 'سبب الرفض',
                    value: _currentRequest.rejectionReason!,
                    valueColor: AppColors.errorDark,
                    isMultiline: true,
                  ),
              ],
            ),
          ],

          // أزرار الموافقة/الرفض (للمالك فقط)
          if (_canApproveOrReject() && _currentRequest.isPending) ...[
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
                      'رفض',
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
                      'موافقة',
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

