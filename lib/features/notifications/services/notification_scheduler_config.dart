import 'dart:async';
import 'package:codit/features/notifications/services/notification_scheduler_service.dart';
import 'package:codit/core/utils/exception_handler.dart';

/// إعداد وجدولة الإشعارات التلقائية
/// 
/// الاستخدام في main.dart بعد تهيئة Firebase:
/// 
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///   NotificationSchedulerConfig.initialize();
///   runApp(MyApp());
/// }
/// ```
class NotificationSchedulerConfig {
  static NotificationSchedulerService? _scheduler;
  static Timer? _dailyTimer;
  static Timer? _overdueTimer;

  /// تهيئة وبدء الجدولة التلقائية
  static void initialize() {
    _scheduler = NotificationSchedulerService();
    _startDailyCheck();
    _startOverdueCheck();
  }

  /// إيقاف الجدولة التلقائية
  static void dispose() {
    _dailyTimer?.cancel();
    _overdueTimer?.cancel();
    _dailyTimer = null;
    _overdueTimer = null;
  }

  /// فحص فوري (يمكن استدعاؤه من الإعدادات أو للاختبار)
  static Future<void> performImmediateCheck() async {
    try {
      await _scheduler?.performDailyCheck();
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
    }
  }

  /// بدء الفحص اليومي (في الساعة 9 صباحاً)
  static void _startDailyCheck() {
    final now = DateTime.now();
    var nextRun = DateTime(now.year, now.month, now.day, 9, 0);

    if (nextRun.isBefore(now)) {
      nextRun = nextRun.add(const Duration(days: 1));
    }

    final initialDelay = nextRun.difference(now);

    Future.delayed(initialDelay, () {
      _performScheduledCheck('daily');
      
      _dailyTimer = Timer.periodic(
        const Duration(hours: 24),
        (_) => _performScheduledCheck('daily'),
      );
    });
  }

  /// بدء الفحص الدوري للأقساط المتأخرة (كل 6 ساعات)
  static void _startOverdueCheck() {
    _performScheduledCheck('overdue');

    _overdueTimer = Timer.periodic(
      const Duration(hours: 6),
      (_) => _performScheduledCheck('overdue'),
    );
  }

  /// تنفيذ الفحص المجدول
  static Future<void> _performScheduledCheck(String type) async {
    try {
      if (type == 'daily') {
        await _scheduler?.performDailyCheck();
      } else if (type == 'overdue') {
        await _scheduler?.checkOverduePayments();
      }
    } catch (e, stackTrace) {
      ExceptionHandler.logException(e, stackTrace);
    }
  }
}
