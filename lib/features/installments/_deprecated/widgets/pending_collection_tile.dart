import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class PendingCollectionTile extends StatelessWidget {
  const PendingCollectionTile({
    super.key,
    required this.collection,
    this.onRetry,
    this.onDiscard,
  });

  final Collection collection;
  final VoidCallback? onRetry;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = intl.DateFormat('yyyy-MM-dd h:mm a', 'ar');
    final isConflict = collection.syncStatus == 'conflict_review';
    final isSending = collection.syncStatus == 'sending';
    final isFailed = collection.syncStatus == 'send_failed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.card,
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(collection.syncStatus).withOpacity(0.3),
          width: isConflict ? 2 : 1,
        ),
        boxShadow: isConflict
            ? [
                BoxShadow(
                  color: _getStatusColor(collection.syncStatus).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: _buildStatusIcon(isConflict, isSending, isFailed),
        title: Row(
          children: [
            Expanded(
              child: Text(
                collection.customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${(collection.amountPiastres / 100.0).toStringAsFixed(2)} ج',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _getStatusColor(collection.syncStatus),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.tag,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'معرف: ${collection.id.substring(0, 8)}...',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.numbers,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'ترتيب ${collection.deviceSequence}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  dateFormatter.format(collection.collectedAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatusChip(collection.syncStatus),
          ],
        ),
        children: [
          const Divider(color: AppColors.textSecondary, height: 1),
          const SizedBox(height: 16),
          
          // التفاصيل الإضافية
          _buildInfoRow(
            icon: Icons.payment,
            label: 'طريقة الدفع',
            value: _formatPaymentMethod(collection.paymentMethod),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.fingerprint,
            label: 'مفتاح التفرد',
            value: '${collection.idempotencyKey.substring(0, 12)}...',
          ),
          if (collection.notes != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.notes,
              label: 'ملاحظات',
              value: collection.notes!,
            ),
          ],

          // رسالة تعارض إذا وجدت
          if (isConflict) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warningDark.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warningDark,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تعارض في المزامنة',
                          style: TextStyle(
                            color: AppColors.warningDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'المبلغ يتجاوز الرصيد المتاح على الخادم. قد يكون هناك تحصيل آخر من جهاز مختلف.',
                    style: TextStyle(
                      color: AppColors.warningDark.withOpacity(0.9),
                      height: 1.4,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // الأزرار
          if (isConflict || isFailed) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (onRetry != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('إعادة المحاولة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.infoLight,
                        side: const BorderSide(color: AppColors.infoLight),
                      ),
                    ),
                  ),
                if (onRetry != null && onDiscard != null) const SizedBox(width: 8),
                if (onDiscard != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDiscard,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('حذف'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorDark,
                        side: const BorderSide(color: AppColors.errorDark),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool isConflict, bool isSending, bool isFailed) {
    if (isSending) {
      return Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.infoLight.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.infoLight),
          ),
        ),
      );
    }

    IconData icon;
    Color color;

    if (isConflict) {
      icon = Icons.warning_amber_rounded;
      color = AppColors.warningDark;
    } else if (isFailed) {
      icon = Icons.error;
      color = AppColors.errorDark;
    } else {
      icon = Icons.cloud_upload;
      color = AppColors.textSecondary;
    }

    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'saved_local':
        bgColor = AppColors.textSecondary.withOpacity(0.2);
        textColor = AppColors.textSecondary;
        label = 'محفوظ محلياً';
        break;
      case 'awaiting_sync':
        bgColor = AppColors.infoLight.withOpacity(0.2);
        textColor = AppColors.infoLight;
        label = 'في انتظار المزامنة';
        break;
      case 'sending':
        bgColor = AppColors.infoLight.withOpacity(0.2);
        textColor = AppColors.infoLight;
        label = 'جاري الإرسال...';
        break;
      case 'confirmed':
        bgColor = AppColors.successLight.withOpacity(0.2);
        textColor = AppColors.successLight;
        label = 'مؤكد';
        break;
      case 'conflict_review':
        bgColor = AppColors.warningDark.withOpacity(0.2);
        textColor = AppColors.warningDark;
        label = 'يحتاج مراجعة';
        break;
      case 'send_failed':
        bgColor = AppColors.errorDark.withOpacity(0.2);
        textColor = AppColors.errorDark;
        label = 'فشل الإرسال';
        break;
      default:
        bgColor = AppColors.textSecondary.withOpacity(0.2);
        textColor = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method) {
      case 'cash':
        return 'نقداً';
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.successLight;
      case 'conflict_review':
        return AppColors.warningDark;
      case 'send_failed':
        return AppColors.errorDark;
      case 'sending':
        return AppColors.infoLight;
      default:
        return AppColors.textSecondary;
    }
  }
}