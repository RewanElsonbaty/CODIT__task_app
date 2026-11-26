import 'package:flutter/material.dart';
import 'package:codit/core/errors/exceptions.dart';

/// Global Exception Handler
/// معالجة جميع الـ Exceptions بشكل آمن ومنظم
class ExceptionHandler {
  /// عرض رسالة خطأ للمستخدم
  static void showErrorDialog(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);

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
    final message = getErrorMessage(error);

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
    } else if (error is MockNetworkException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is ConflictException) {
      return error.message;
    } else if (error is VersionConflictException) {
      return error.message;
    } else if (error is CacheException) {
      return error.message;
    } else if (error is AuthException) {
      return error.message;
    } else if (error is UnauthorizedException) {
      return error.message;
    } else if (error is NotFoundException) {
      return error.message;
    } else if (error is TimeoutException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString()
          .replaceAll('Exception: ', '')
          .replaceAll('exception: ', '');
    } else if (error is String) {
      return error;
    }
    return 'حدث خطأ غير متوقع';
  }

  /// عرض Success Snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// عرض Warning Snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// عرض Info Snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
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

  /// معالجة Exception بشكل شامل
  static Future<T?> handleException<T>({
    required Future<T> Function() operation,
    BuildContext? context,
    String? errorMessage,
    bool showSnackBar = false,
    bool showDialog = false,
    T? defaultValue,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      logException(e, stackTrace);
      
      if (context != null && context.mounted) {
        final message = errorMessage ?? getErrorMessage(e);
        
        if (showDialog) {
          showErrorDialog(context, message);
        } else if (showSnackBar) {
          showErrorSnackBar(context, message);
        }
      }
      
      return defaultValue;
    }
  }
}
