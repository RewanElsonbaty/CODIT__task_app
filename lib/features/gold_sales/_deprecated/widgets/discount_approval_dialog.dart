import 'package:flutter/material.dart';

/// Dialog shown when discount percentage exceeds the threshold (10%)
/// and requires manager approval
class DiscountApprovalDialog extends StatelessWidget {
  final int discountPercent;
  final int thresholdPercent;
  final String itemDescription;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const DiscountApprovalDialog({
    super.key,
    required this.discountPercent,
    required this.thresholdPercent,
    required this.itemDescription,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD4AF37),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'موافقة على الخصم',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخصم المطلوب يتجاوز الحد المسموح',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('القطعة', itemDescription),
          const SizedBox(height: 8),
          _buildInfoRow(
            'نسبة الخصم',
            '$discountPercent%',
            valueColor: const Color(0xFFD4AF37),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('الحد المسموح', '$thresholdPercent%'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[300],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'يتطلب موافقة المدير',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onReject,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'رفض',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onApprove,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'موافقة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Show the dialog and return true if approved, false if rejected
  static Future<bool> show({
    required BuildContext context,
    required int discountPercent,
    required int thresholdPercent,
    required String itemDescription,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DiscountApprovalDialog(
        discountPercent: discountPercent,
        thresholdPercent: thresholdPercent,
        itemDescription: itemDescription,
        onApprove: () => Navigator.of(context).pop(true),
        onReject: () => Navigator.of(context).pop(false),
      ),
    );
    return result ?? false;
  }
}
