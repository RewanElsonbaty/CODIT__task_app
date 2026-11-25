# دليل الإشعارات التلقائية للأقساط
# Automatic Installment Notifications Guide

## 📋 نظرة عامة | Overview

تم تفعيل نظام الإشعارات التلقائية الكامل للأقساط. النظام يعمل في الخلفية ويرسل إشعارات تلقائياً للمالك ومديري الفروع عند:

The complete automatic notifications system for installments is now active. The system works in the background and automatically sends notifications to owners and branch managers when:

1. ⏰ **موعد استحقاق القسط اليوم** | Payment due today
2. ⚠️ **القسط متأخر** | Payment overdue
3. 📅 **تذكير مبكر (3 أيام قبل الموعد)** | Early reminder (3 days before)
4. ✅ **تم الدفع** | Payment collected
5. 📝 **طلب تقسيط جديد** | New installment request
6. ✔️ **موافقة على طلب** | Request approved
7. ❌ **رفض طلب** | Request rejected

---

## 🚀 التفعيل | Activation

### النظام مُفعّل تلقائياً!
النظام يعمل فور تشغيل التطبيق بدون أي إعدادات إضافية.

### The System is Auto-Activated!
The system works immediately when the app starts, without any additional setup.

تم إضافة السطر التالي في `main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  
  // ✅ الإشعارات التلقائية مُفعّلة
  NotificationSchedulerConfig.initialize();
  
  runApp(const CoditApp());
}
```

---

## ⏱️ جدول الفحص التلقائي | Automatic Check Schedule

### 1. الفحص اليومي الكامل | Daily Full Check
- **التوقيت**: كل يوم الساعة 9:00 صباحاً
- **Timing**: Every day at 9:00 AM
- **ما يتم فحصه | What's Checked**:
  - ✅ الأقساط المستحقة اليوم
  - ✅ الأقساط المتأخرة
  - ✅ الأقساط القادمة (خلال 3 أيام)

### 2. فحص الأقساط المتأخرة | Overdue Payments Check
- **التوقيت**: كل 6 ساعات
- **Timing**: Every 6 hours
- **ما يتم فحصه | What's Checked**:
  - ⚠️ الأقساط المتأخرة فقط

### 3. الإشعارات الفورية | Immediate Notifications
- **عند إنشاء طلب تقسيط** | On creating installment request
- **عند الموافقة/الرفض** | On approve/reject
- **عند تحصيل القسط** | On payment collection

---

## 📂 الملفات المُضافة | Added Files

### 1. `notification_scheduler_service.dart`
الخدمة الرئيسية لفحص الأقساط وإرسال الإشعارات.

Main service for checking installments and sending notifications.

**الوظائف الرئيسية | Main Functions**:
```dart
// فحص الأقساط المستحقة اليوم
checkDuePaymentsToday()

// فحص الأقساط القادمة (3 أيام)
checkUpcomingPayments()

// فحص الأقساط المتأخرة
checkOverduePayments()

// الفحص اليومي الشامل
performDailyCheck()
```

### 2. `notification_scheduler_config.dart`
إعداد وجدولة الفحص التلقائي.

Setup and scheduling of automatic checks.

**الوظائف الرئيسية | Main Functions**:
```dart
// تهيئة وبدء الجدولة
NotificationSchedulerConfig.initialize()

// فحص فوري (للاختبار)
NotificationSchedulerConfig.performImmediateCheck()

// إيقاف الجدولة
NotificationSchedulerConfig.dispose()
```

---

## 🧪 الاختبار | Testing

### اختبار فوري للنظام | Immediate System Test

يمكنك إضافة زر في صفحة الإعدادات للاختبار الفوري:

You can add a button in the settings page for immediate testing:

```dart
ElevatedButton(
  onPressed: () async {
    await NotificationSchedulerConfig.performImmediateCheck();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم فحص الأقساط وإرسال الإشعارات')),
    );
  },
  child: Text('فحص الأقساط الآن'),
)
```

### سيناريوهات الاختبار | Test Scenarios

#### 1. اختبار القسط المستحق اليوم
```dart
// أضف قسط مستحق اليوم في mock_installments_api.dart
Installment(
  id: 'test-001',
  dueDate: DateTime.now(), // اليوم
  status: 'pending',
  amount: 5000,
),
```

#### 2. اختبار القسط المتأخر
```dart
// أضف قسط متأخر
Installment(
  id: 'test-002',
  dueDate: DateTime.now().subtract(Duration(days: 5)), // قبل 5 أيام
  status: 'pending',
  amount: 3000,
),
```

#### 3. اختبار التذكير المبكر
```dart
// أضف قسط قادم
Installment(
  id: 'test-003',
  dueDate: DateTime.now().add(Duration(days: 2)), // بعد يومين
  status: 'pending',
  amount: 4000,
),
```

---

## 📊 أنواع الإشعارات المُرسلة | Notification Types Sent

### 1. إشعار استحقاق القسط | Payment Due Notification
```
📅 موعد دفع القسط اليوم
العميل: أحمد محمد
المبلغ: 5,000 ج.م
العقد: IC-2024-001
```

### 2. إشعار القسط المتأخر | Overdue Notification
```
⚠️ قسط متأخر منذ 5 أيام
العميل: فاطمة علي
المبلغ: 3,000 ج.م
العقد: IC-2024-002
```

### 3. إشعار طلب تقسيط جديد | New Request Notification
```
📝 طلب تقسيط جديد
من: مدير الفرع الرئيسي
العميل: محمد حسن
المبلغ: 50,000 ج.م
بحاجة للموافقة
```

### 4. إشعار الموافقة | Approval Notification
```
✅ تمت الموافقة على طلب التقسيط
الطلب: IR-2024-001
العميل: سارة أحمد
تم إضافة العقد إلى النظام
```

### 5. إشعار الرفض | Rejection Notification
```
❌ تم رفض طلب التقسيط
الطلب: IR-2024-002
السبب: تاريخ ائتماني غير مناسب
```

---

## 🎯 من يستقبل الإشعارات؟ | Who Receives Notifications?

### المالك (Owner)
- ✅ جميع إشعارات الأقساط المستحقة
- ✅ جميع إشعارات الأقساط المتأخرة
- ✅ طلبات التقسيط الجديدة
- ✅ تأكيدات الموافقة/الرفض

### مدير الفرع (Branch Manager)
- ✅ أقساط فرعه المستحقة
- ✅ أقساط فرعه المتأخرة
- ✅ تأكيدات موافقة/رفض طلباته
- ✅ تذكيرات الدفع لعملائه

---

## ⚙️ الإعدادات المتقدمة | Advanced Settings

### تعديل توقيت الفحص اليومي | Change Daily Check Time

في `notification_scheduler_config.dart`:

```dart
// تغيير من 9 صباحاً إلى 8 صباحاً
var nextRun = DateTime(now.year, now.month, now.day, 8, 0); // 8 AM
```

### تعديل فترة فحص الأقساط المتأخرة | Change Overdue Check Interval

```dart
// تغيير من 6 ساعات إلى 4 ساعات
_overdueTimer = Timer.periodic(
  const Duration(hours: 4), // كان 6
  (_) => _performScheduledCheck('overdue'),
);
```

### تعديل فترة التذكير المبكر | Change Early Reminder Period

في `notification_scheduler_service.dart`:

```dart
// تغيير من 3 أيام إلى 5 أيام
final in5Days = today.add(const Duration(days: 5)); // كان 3
```

---

## 🔧 استكشاف الأخطاء | Troubleshooting

### الإشعارات لا تظهر | Notifications Not Showing

#### 1. تحقق من تفعيل النظام
```dart
// في main.dart
NotificationSchedulerConfig.initialize(); // ✅ موجود؟
```

#### 2. تحقق من البيانات الوهمية
```bash
# افحص mock_installments_api.dart
# هل هناك أقساط مستحقة؟
```

#### 3. اختبار فوري
```dart
await NotificationSchedulerConfig.performImmediateCheck();
```

#### 4. فحص السجلات
```dart
// في exception_handler.dart
// ابحث عن أخطاء NotificationSchedulerService
```

### الإشعارات مكررة | Duplicate Notifications

هذا طبيعي إذا:
- القسط مستحق اليوم **و** متأخر → إشعاران
- الفحص اليومي **و** فحص المتأخرات في نفس الوقت

الحل:
```dart
// أضف تتبع للإشعارات المُرسلة لتجنب التكرار
final _sentNotifications = <String>{};

if (!_sentNotifications.contains(installment.id)) {
  await sendNotification(...);
  _sentNotifications.add(installment.id);
}
```

---

## 🎨 تخصيص الإشعارات | Customizing Notifications

### إضافة صوت للإشعارات المهمة

```dart
// في mock_notifications_api.dart
AppNotification(
  // ... باقي الحقول
  priority: 'high', // للأقساط المتأخرة
  sound: 'notification_sound.mp3',
)
```

### تجميع الإشعارات المتشابهة

```dart
// بدلاً من إشعار لكل قسط، أرسل إشعار واحد:
"لديك 5 أقساط مستحقة اليوم بمجموع 25,000 ج.م"
```

### إضافة أزرار للإشعارات

```dart
AppNotification(
  // ... باقي الحقول
  actions: [
    NotificationAction(id: 'pay', label: 'دفع الآن'),
    NotificationAction(id: 'remind', label: 'ذكرني لاحقاً'),
  ],
)
```

---

## 📱 التكامل مع Firebase Cloud Messaging

### لإشعارات Push حقيقية (اختياري):

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.6
```

```dart
// في main.dart
await Firebase.initializeApp();
await FirebaseMessaging.instance.requestPermission();

// في notification_scheduler_service.dart
// أرسل الإشعار عبر FCM بدلاً من الحفظ المحلي
await FirebaseMessaging.instance.sendMessage(...);
```

---

## 📈 الإحصائيات | Statistics

### مراقبة الأداء | Performance Monitoring

```dart
class NotificationStats {
  static int totalSent = 0;
  static int dueTodayCount = 0;
  static int overdueCount = 0;
  static int upcomingCount = 0;
  
  static Map<String, int> getStats() {
    return {
      'total': totalSent,
      'dueToday': dueTodayCount,
      'overdue': overdueCount,
      'upcoming': upcomingCount,
    };
  }
}
```

### عرض الإحصائيات في لوحة التحكم

```dart
// في admin dashboard
FutureBuilder(
  future: NotificationStats.getStats(),
  builder: (context, snapshot) {
    return Column(
      children: [
        StatCard(title: 'إجمالي الإشعارات', value: stats['total']),
        StatCard(title: 'مستحقة اليوم', value: stats['dueToday']),
        StatCard(title: 'متأخرة', value: stats['overdue']),
      ],
    );
  },
)
```

---

## 🎓 أفضل الممارسات | Best Practices

### 1. لا ترسل إشعارات كثيرة
- ✅ إشعار واحد يومياً للأقساط المستحقة
- ❌ لا ترسل إشعار كل ساعة

### 2. أعط الأولوية للمهم
- 🔴 المتأخرة → أولوية عالية
- 🟡 المستحقة اليوم → أولوية متوسطة
- 🟢 القادمة → أولوية منخفضة

### 3. اجعلها قابلة للتخصيص
```dart
// اسمح للمستخدم بتعطيل أنواع معينة
class NotificationPreferences {
  bool enableDueNotifications = true;
  bool enableOverdueNotifications = true;
  bool enableUpcomingNotifications = false;
}
```

### 4. احترم وقت الراحة
```dart
// لا ترسل إشعارات بعد 10 مساءً
final now = DateTime.now();
if (now.hour >= 22 || now.hour < 7) {
  return; // لا ترسل الآن
}
```

---

## ✅ الخلاصة | Summary

### تم التنفيذ ✅
1. ✅ نظام جدولة كامل
2. ✅ فحص يومي تلقائي (9 صباحاً)
3. ✅ فحص دوري للمتأخرات (كل 6 ساعات)
4. ✅ إشعارات لجميع الأحداث
5. ✅ تكامل مع نظام الأقساط
6. ✅ تكامل مع نظام الموافقات

### جاهز للاستخدام 🚀
- النظام يعمل فور تشغيل التطبيق
- لا حاجة لإعدادات إضافية
- جميع الإشعارات تُرسل تلقائياً

### اختياري (مستقبلاً) 🔮
- [ ] تكامل مع Firebase FCM
- [ ] إشعارات صوتية
- [ ] تخصيص التوقيت لكل مستخدم
- [ ] لوحة إحصائيات الإشعارات

---

## 📞 الدعم | Support

للأسئلة أو المشاكل:
1. راجع قسم "استكشاف الأخطاء" أعلاه
2. افحص السجلات في `exception_handler.dart`
3. اختبر باستخدام `performImmediateCheck()`
4. راجع ملفات Mock للبيانات التجريبية

---

**تم التحديث**: 2024
**الإصدار**: 1.0.0
**الحالة**: ✅ مُفعّل ويعمل
