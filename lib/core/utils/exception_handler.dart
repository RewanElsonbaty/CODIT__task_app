import 'package:flutter/material.dart';
import 'package:codit/core/errors/exceptions.dart';

/// Global Exception Handler
/// معالجة جميع الـ Exceptions بشكل آمن ومنظم
class ExceptionHandler {
  /// عرض رسالة خطأ للمستخدم
  static void showErrorDialog(BuildContext context, dynamic error) {
    String message = 'حدث خطأ غير متوقع';
    
    if (error is ServerException) {
      message = error.message;
    } else if (error is NetworkException) {
      message = 'خطأ في الاتصال بالشبكة';
    } else if (error is ValidationException) {
      message = error.message;
    } else if (error is ConflictException) {
      message = error.message;
    } else if (error is CacheException) {
      message = 'خطأ في تحميل البيانات المحفوظة';
    } else if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
            SizedBox(width: 12),
            Text(
              'خطأ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'حسناً',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// عرض Snackbar للأخطاء البسيطة
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    String message = 'حدث خطأ';
    
    if (error is ServerException) {
      message = error.message;
    } else if (error is NetworkException) {
      message = 'خطأ في الاتصال بالشبكة';
    } else if (error is ValidationException) {
      message = error.message;
    } else if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'إغلاق',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  /// معالجة الـ Exception وإرجاع رسالة
  static String getErrorMessage(dynamic error) {
    if (error is ServerException) {
      return error.message;
    } else if (error is NetworkException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is ConflictException) {
      return error.message;
    } else if (error is CacheException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'حدث خطأ غير متوقع';
  }

  /// Log Exception (للتطوير فقط)
  static void logException(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('════════════ Exception ════════════');
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
    debugPrint('═══════════════════════════════════');
  }
}
