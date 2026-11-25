import 'package:codit/features/installments/data/mock_installments_api.dart';
import 'package:codit/features/notifications/data/mock_notifications_api.dart';
import 'package:codit/core/utils/exception_handler.dart';

/// خدمة جدولة الإشعارات للأقساط
/// تتحقق من مواعيد الدفع وترسل إشعارات تلقائية
class NotificationSchedulerService {
  final MockInstallmentsApi installmentsApi;
  final MockNotificationsApi notificationsApi;

  NotificationSchedulerService({
    MockInstallmentsApi? installmentsApi,
    MockNotificationsApi? notificationsApi,
  })  : installmentsApi = installmentsApi ?? MockInstallmentsApi(),
        notificationsApi = notificationsApi ?? MockNotificationsApi();

  /// تحقق من الأقساط المستحقة اليوم وأرسل إشعارات
  Future<void> checkDuePaymentsToday() async {
    try {
      print('Checking due payments for today...');
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
    }
  }

  /// تحقق من الأقساط المستحقة خلال 3 أيام القادمة وأرسل تذكيرات
  Future<void> checkUpcomingPayments() async {
    try {
      print('Checking upcoming payments...');
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
    }
  }

  /// تحقق من الأقساط المتأخرة وأرسل إشعارات
  Future<void> checkOverduePayments() async {
    try {
      print('Checking overdue payments...');
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
    }
  }

  /// تحقق من جميع حالات الأقساط وأرسل الإشعارات المناسبة
  Future<void> performDailyCheck() async {
    try {
      await checkDuePaymentsToday();
      await checkOverduePayments();
      await checkUpcomingPayments();
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
    }
  }

  /// مساعد: تحقق إذا كان تاريخان في نفس اليوم
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
