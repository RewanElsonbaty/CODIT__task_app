# اختبار سريع للإشعارات التلقائية
# Quick Test for Automatic Notifications

## ⚡ اختبار فوري (5 دقائق)

### 1️⃣ تشغيل التطبيق
```bash
flutter run
```

### 2️⃣ إضافة زر اختبار مؤقت

أضف هذا الكود في أي صفحة (مثلاً في `home_page.dart`):

```dart
// في _buildBody أو في AppBar
FloatingActionButton(
  onPressed: () async {
    // اختبار فوري للإشعارات
    await NotificationSchedulerConfig.performImmediateCheck();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تم فحص الأقساط وإرسال الإشعارات'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  },
  child: Icon(Icons.notifications_active),
  tooltip: 'اختبار الإشعارات',
)
```

### 3️⃣ أضف بيانات اختبار

في `mock_installments_api.dart`، أضف عقد قسط للاختبار:

```dart
InstallmentContract(
  id: 'test-contract-001',
  contractNumber: 'IC-TEST-001',
  customerId: 'C-001',
  customerName: 'عميل اختبار',
  customerPhone: '01234567890',
  branchId: 'branch-001',
  branchManagerId: 'manager-001',
  status: 'active',
  createdAt: DateTime.now(),
  
  // أضف أقساط بمواعيد مختلفة للاختبار
  installments: [
    // قسط مستحق اليوم
    Installment(
      id: 'inst-test-001',
      contractId: 'test-contract-001',
      installmentNumber: 1,
      amount: 5000,
      dueDate: DateTime.now(), // ⏰ اليوم
      status: 'pending',
      notes: 'قسط اختبار مستحق اليوم',
    ),
    
    // قسط متأخر
    Installment(
      id: 'inst-test-002',
      contractId: 'test-contract-001',
      installmentNumber: 2,
      amount: 5000,
      dueDate: DateTime.now().subtract(Duration(days: 5)), // ⚠️ متأخر 5 أيام
      status: 'pending',
      notes: 'قسط اختبار متأخر',
    ),
    
    // قسط قادم (تذكير مبكر)
    Installment(
      id: 'inst-test-003',
      contractId: 'test-contract-001',
      installmentNumber: 3,
      amount: 5000,
      dueDate: DateTime.now().add(Duration(days: 2)), // 📅 بعد يومين
      status: 'pending',
      notes: 'قسط اختبار قادم',
    ),
  ],
)
```

### 4️⃣ اضغط زر الاختبار

الآن اضغط على الزر الذي أضفته → سيتم فحص جميع الأقساط

### 5️⃣ افحص الإشعارات

اذهب لصفحة الإشعارات:
```dart
context.go('/notifications');
```

يجب أن ترى:
- ✅ إشعار للقسط المستحق اليوم
- ⚠️ إشعار للقسط المتأخر
- 📅 إشعار للقسط القادم (تذكير مبكر)

---

## 🧪 اختبار متقدم

### اختبار طلب تقسيط جديد

```dart
// في create_installment_request_page.dart
// بعد إنشاء الطلب بنجاح:

// 1. ارجع للصفحة الرئيسية
context.go('/home');

// 2. اذهب للإشعارات
context.go('/notifications');

// 3. يجب أن ترى إشعار "طلب تقسيط جديد"
```

### اختبار الموافقة على طلب

```dart
// في installment_request_details_page.dart
// بعد الموافقة على الطلب:

// 1. اذهب لصفحة الأقساط
context.go('/installments');

// 2. ابحث عن العقد الجديد المُنشأ تلقائياً

// 3. اذهب للإشعارات
context.go('/notifications');

// 4. يجب أن ترى إشعار "تمت الموافقة"
```

### اختبار الرفض

```dart
// في installment_request_details_page.dart
// بعد رفض الطلب:

// 1. اذهب للإشعارات
context.go('/notifications');

// 2. يجب أن ترى إشعار "تم الرفض" مع السبب
```

---

## 📊 النتائج المتوقعة

### بعد الفحص الفوري:

#### للمالك (Owner):
```
📅 موعد دفع القسط اليوم
العميل: عميل اختبار
المبلغ: 5,000 ج.م
العقد: IC-TEST-001

⚠️ قسط متأخر منذ 5 أيام
العميل: عميل اختبار
المبلغ: 5,000 ج.م
العقد: IC-TEST-001
```

#### لمدير الفرع (Manager):
```
نفس الإشعارات أعلاه
(فقط للأقساط التابعة لفرعه)
```

---

## 🔍 فحص السجلات (Logs)

إذا لم تظهر الإشعارات، افحص Console:

```bash
flutter run --verbose
```

ابحث عن:
```
NotificationSchedulerService.checkDuePaymentsToday
NotificationSchedulerService.checkOverduePayments
NotificationSchedulerService.checkUpcomingPayments
```

---

## ✅ قائمة التحقق (Checklist)

- [ ] تم تشغيل التطبيق بنجاح
- [ ] تم إضافة بيانات الاختبار
- [ ] تم إضافة زر الاختبار المؤقت
- [ ] تم الضغط على زر الاختبار
- [ ] ظهرت رسالة "تم فحص الأقساط"
- [ ] تم فتح صفحة الإشعارات
- [ ] ظهرت الإشعارات الثلاثة (مستحق، متأخر، قادم)
- [ ] تم اختبار إنشاء طلب تقسيط
- [ ] تم اختبار الموافقة على طلب
- [ ] تم اختبار الرفض
- [ ] جميع الإشعارات تظهر بشكل صحيح

---

## 🐛 استكشاف الأخطاء الشائعة

### 1. لا توجد إشعارات
**السبب**: لا توجد أقساط في mock data
**الحل**: أضف بيانات الاختبار أعلاه

### 2. الإشعارات لا تظهر في UI
**السبب**: لم يتم تحديث UI
**الحل**: 
```dart
// تأكد من استدعاء
setState(() {});
// أو استخدم
BlocProvider.of<NotificationsCubit>(context).refresh();
```

### 3. خطأ في Console
**السبب**: import ناقص
**الحل**:
```dart
import 'package:codit/features/notifications/services/notification_scheduler_config.dart';
```

### 4. الإشعارات مكررة
**السبب**: الفحص اليومي والدوري في نفس الوقت
**الحل**: هذا طبيعي، أو أضف منع للتكرار

---

## 🎯 الخطوات التالية

بعد نجاح الاختبار:

1. ✅ احذف زر الاختبار المؤقت
2. ✅ احذف بيانات الاختبار
3. ✅ أضف بيانات حقيقية
4. ✅ راقب الإشعارات في الساعة 9 صباحاً
5. ✅ راقب فحص المتأخرات كل 6 ساعات

---

## 📱 اختبار على الهاتف

للاختبار على جهاز حقيقي:

```bash
# Android
flutter run -d <device-id>

# iOS
flutter run -d <device-id>

# قائمة الأجهزة المتصلة
flutter devices
```

---

## 🎉 تهانينا!

إذا نجحت جميع الاختبارات، النظام يعمل بشكل كامل! 🚀

النظام الآن:
- ✅ يفحص الأقساط تلقائياً
- ✅ يرسل إشعارات في المواعيد المحددة
- ✅ يتكامل مع نظام الأقساط والموافقات
- ✅ جاهز للإنتاج
