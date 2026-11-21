import 'package:flutter/material.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:codit/core/utils/number_formatters.dart';

/// Dialog لحل تعارضات المزامنة
class ConflictResolutionDialog extends StatelessWidget {
  const ConflictResolutionDialog({
    super.key,
    required this.collection,
    required this.onResolve,
  });

  final Collection collection;
  final Function(ConflictResolution) onResolve;

  @override
  Widget build(BuildContext context) {
    final amount = collection.amountPiastres / 100.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange[700],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'تعارض في المزامنة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // معلومات التحصيل
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      'العميل',
                      collection.customerName,
                      Icons.person,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'المبلغ',
                      '${NumberFormatters.formatCurrency(amount)} ج.م',
                      Icons.attach_money,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'طريقة الدفع',
                      _getPaymentMethodName(collection.paymentMethod),
                      Icons.payment,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'التاريخ',
                      _formatDate(collection.collectedAt),
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // الرسالة التوضيحية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'هذا التحصيل تم رفضه من الخادم بسبب تعارض (ربما تم تحصيله مسبقاً أو حدث تغيير في البيانات).',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange[900],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                'اختر الإجراء المناسب:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // إعادة المحاولة
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onResolve(ConflictResolution.retry);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          
          // حذف محلياً
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onResolve(ConflictResolution.discardLocal);
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'حذف محلياً',
              style: TextStyle(color: Colors.red),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          
          // مراجعة لاحقاً
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onResolve(ConflictResolution.reviewLater);
            },
            child: const Text('مراجعة لاحقاً'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'cash':
        return 'نقدي';
      case 'card':
        return 'بطاقة';
      case 'transfer':
        return 'تحويل بنكي';
      case 'check':
        return 'شيك';
      default:
        return method;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// خيارات حل التعارض
enum ConflictResolution {
  retry,        // إعادة محاولة المزامنة
  discardLocal, // حذف السجل المحلي
  reviewLater,  // مراجعة لاحقاً
}
