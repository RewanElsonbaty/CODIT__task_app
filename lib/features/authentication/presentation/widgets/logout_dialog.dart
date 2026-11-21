import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog تأكيد تسجيل الخروج
class LogoutDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorDark.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.errorDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل أنت متأكد من تسجيل الخروج؟',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'سيتم إنهاء جلستك الحالية وستحتاج إلى تسجيل الدخول مرة أخرى.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
