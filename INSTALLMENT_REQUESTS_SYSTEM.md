# نظام طلبات التقسيط - Installment Requests System

## 📋 نظرة عامة

نظام كامل لإدارة طلبات التقسيط بين المدير والمالك، متكامل مع نظام الموافقات والأقساط.

---

## 🔄 تدفق العمل الكامل

```
١. المدير → إنشاء طلب تقسيط
   ↓
٢. الطلب → معلق (Pending) - ينتظر موافقة المالك
   ↓
٣. المالك → يراجع الطلب في صفحة طلبات التقسيط
   ↓
   ├─→ موافقة (Approved) → يُضاف للأقساط
   │
   └─→ رفض (Rejected) → يُسجل سبب الرفض
```

---

## 📁 الملفات المُنشأة

### 1. Domain Layer (النماذج)

#### `installment_request_models.dart`
```dart
// الحالات
enum InstallmentRequestStatus {
  pending,    // معلق
  approved,   // موافق عليه
  rejected,   // مرفوض
  cancelled   // ملغي
}

// طلب إنشاء تقسيط
class CreateInstallmentRequest {
  - customerName         // اسم العميل
  - customerId           // رقم العميل
  - customerPhone        // رقم الهاتف
  - nationalId           // الرقم القومي (14 رقم)
  - invoiceId            // رقم الفاتورة
  - totalAmountPiastres  // المبلغ الإجمالي (بالقرش)
  - downPaymentPiastres  // الدفعة الأولى
  - installmentAmountPiastres  // قيمة القسط
  - numberOfInstallments // عدد الأقساط
  - firstPaymentDate     // موعد أول دفعة
  - paymentInterval      // 'monthly', 'weekly', 'daily'
  - branchId             // ID الفرع
  - branchName           // اسم الفرع
  - requestedBy          // ID المدير
  - requestedByName      // اسم المدير
  - notes                // ملاحظات (اختياري)
}

// طلب تقسيط كامل
class InstallmentRequest {
  - id                   // معرف فريد
  - requestNumber        // رقم الطلب (IR-2024-XXX)
  - [all CreateInstallmentRequest fields]
  - createdAt            // تاريخ الإنشاء
  - status               // الحالة
  - reviewedBy           // من راجع الطلب
  - reviewedByName       // اسم المراجع
  - reviewedAt           // تاريخ المراجعة
  - rejectionReason      // سبب الرفض (إذا كان مرفوض)
  - version              // رقم النسخة
}

// قرار الموافقة/الرفض
class InstallmentRequestDecision {
  - requestId
  - approved             // true = موافقة, false = رفض
  - rejectionReason      // إلزامي عند الرفض
  - reviewedBy
  - reviewedByName
  - reviewedAt
}

// ملخص طلب (للقوائم)
class InstallmentRequestSummary {
  - id
  - requestNumber
  - customerName
  - customerId
  - totalAmountPiastres
  - numberOfInstallments
  - branchName
  - requestedByName
  - createdAt
  - status
}
```

---

### 2. Data Layer (Mock API)

#### `mock_installment_requests_api.dart`

**البيانات التجريبية (5 طلبات):**
1. ✅ طلب معلق - أحمد محمود - 50,000 جنيه - 8 أقساط
2. ✅ طلب معلق - فاطمة حسن - 80,000 جنيه - 6 أقساط
3. ✅ طلب موافق عليه - خالد عبد الرحمن - 35,000 جنيه
4. ✅ طلب مرفوض - نورا إبراهيم - 100,000 جنيه (سبب: مبلغ كبير)
5. ✅ طلب معلق (تقسيط أسبوعي) - ياسمين محمد - 20,000 جنيه

**الوظائف:**

```dart
// إنشاء طلب جديد (للمدير)
Future<InstallmentRequest> createInstallmentRequest(CreateInstallmentRequest)

// الحصول على جميع الطلبات (مع فلترة)
Future<List<InstallmentRequest>> getAllRequests({
  InstallmentRequestStatus? status,
  String? branchId,
})

// الطلبات المعلقة فقط (للمالك)
Future<List<InstallmentRequest>> getPendingRequests()

// تفاصيل طلب معين
Future<InstallmentRequest> getRequestDetails(String requestId)

// الموافقة (المالك فقط)
Future<InstallmentRequest> approveRequest(InstallmentRequestDecision)

// الرفض (المالك فقط)
Future<InstallmentRequest> rejectRequest(InstallmentRequestDecision)

// الإلغاء (صاحب الطلب فقط)
Future<InstallmentRequest> cancelRequest(String requestId, String cancelledBy)

// إحصائيات
Future<Map<String, dynamic>> getStatistics({String? branchId})
// Returns:
// - total, pending, approved, rejected, cancelled
// - total_amount, approved_amount
// - avg_approval_time_hours
// - approval_rate

// البحث
Future<List<InstallmentRequest>> searchRequests(String query)
// يبحث في: اسم العميل، رقم الهاتف، الرقم القومي، رقم الفاتورة، رقم الطلب

// عدد الطلبات المعلقة (للإشعارات)
int getPendingCount()
```

---

### 3. Presentation Layer (الصفحات)

#### `create_installment_request_page.dart`
**صفحة إنشاء طلب تقسيط جديد (للمدير)**

**الأقسام:**
1. **بيانات العميل:**
   - اسم العميل (مطلوب)
   - رقم العميل (مطلوب)
   - رقم الهاتف (11 رقم - مطلوب)
   - الرقم القومي (14 رقم - مطلوب)

2. **بيانات الفاتورة:**
   - رقم الفاتورة (مطلوب)
   - المبلغ الإجمالي (مطلوب)
   - الدفعة الأولى (مطلوب)

3. **تفاصيل التقسيط:**
   - قيمة القسط (مطلوب)
   - عدد الأقساط (مطلوب)
   - موعد أول دفعة (DatePicker - مطلوب)
   - فترة السداد (شهري/أسبوعي/يومي)

4. **ملاحظات:**
   - حقل نصي اختياري

**التحققات:**
- جميع الحقول المطلوبة مليئة
- رقم الهاتف 11 رقم
- الرقم القومي 14 رقم
- الدفعة الأولى < المبلغ الإجمالي
- مجموع الأقساط = المبلغ المتبقي

**الاستجابة:**
- عند النجاح: رسالة نجاح + رقم الطلب + إغلاق الصفحة
- عند الفشل: رسالة خطأ

---

#### `installment_requests_page.dart`
**صفحة عرض طلبات التقسيط**

**التبويبات (Tabs):**
1. الكل - جميع الطلبات
2. معلق - الطلبات المعلقة (مع Badge برتقالي)
3. موافق - الطلبات الموافق عليها (مع Badge أخضر)
4. مرفوض - الطلبات المرفوضة (مع Badge أحمر)

**كل بطاقة طلب تعرض:**
- الحالة (badge ملون)
- رقم الطلب
- اسم العميل + رقم الهاتف
- المبلغ الإجمالي
- القسط الشهري
- عدد الأقساط
- موعد أول دفعة
- اسم الفرع
- اسم مقدم الطلب
- سبب الرفض (إن وجد)

**الميزات:**
- Pull to refresh
- التبديل بين التبويبات
- الضغط على البطاقة → صفحة التفاصيل
- زر FAB (للمدير): "طلب جديد"

**الصلاحيات:**
- **المالك:** يرى جميع الطلبات من جميع الفروع
- **المدير:** يرى طلبات فرعه فقط

---

#### `installment_request_details_page.dart`
**صفحة تفاصيل طلب التقسيط**

**الأقسام:**

1. **بيانات العميل:**
   - اسم العميل
   - رقم العميل
   - رقم الهاتف
   - الرقم القومي

2. **بيانات الفاتورة:**
   - رقم الفاتورة
   - المبلغ الإجمالي (ذهبي - highlighted)
   - الدفعة الأولى
   - المبلغ المتبقي (highlighted)

3. **تفاصيل التقسيط:**
   - قيمة القسط (ذهبي - highlighted)
   - عدد الأقساط
   - موعد أول دفعة
   - فترة السداد (شهري/أسبوعي/يومي)

4. **بيانات الطلب:**
   - الفرع
   - مقدم الطلب
   - تاريخ التقديم
   - ملاحظات (إن وجدت)

5. **بيانات المراجعة (إذا تمت):**
   - المراجع
   - تاريخ المراجعة
   - سبب الرفض (إذا كان مرفوض)

**الأزرار (للمالك فقط - إذا كان معلق):**
- زر "رفض" (أحمر) - يفتح dialog لإدخال سبب الرفض
- زر "موافقة" (أخضر) - يفتح dialog للتأكيد

**بعد القرار:**
- رسالة نجاح
- إغلاق الصفحة
- تحديث القائمة

---

## 🛣️ الروابط (Routes)

### المضافة في `app_router.dart`:

```dart
// 1. صفحة قائمة الطلبات
GoRoute(
  path: '/installment-requests',
  redirect: (context, state) {
    // التحقق من الصلاحيات
    // المالك أو المدير
  },
  builder: (_, state) {
    // تحديد userRole و branchId
    return InstallmentRequestsPage(
      userRole: userRole,
      branchId: branchId,
    );
  },
)

// 2. إنشاء طلب جديد
GoRoute(
  path: '/create-installment-request',
  redirect: (context, state) {
    // التحقق من الصلاحيات
    // المدير فقط
  },
  builder: (_, __) => const CreateInstallmentRequestPage(),
)
```

---

## 🎯 الصلاحيات

| الدور | القراءة | الإنشاء | الموافقة/الرفض | الإلغاء |
|------|--------|---------|---------------|---------|
| **المالك** | ✅ جميع الطلبات | ❌ | ✅ | ❌ |
| **المدير** | ✅ طلبات فرعه | ✅ | ❌ | ✅ طلباته فقط |
| **الموظف** | ❌ | ❌ | ❌ | ❌ |

---

## 🔗 التكامل مع الأنظمة الأخرى

### 1. نظام الموافقات (`approvals`)
- مشترك في نفس القسم (`features/approvals`)
- يستخدم نفس الـ routing permissions
- يمكن دمج الطلبات في صفحة واحدة لاحقًا

### 2. نظام الأقساط (`installments`)
**عند الموافقة على طلب:**
```dart
// في mock_installment_requests_api.dart
Future<InstallmentRequest> approveRequest(decision) async {
  // ... update request status
  
  // TODO: إضافة القسط لنظام الأقساط
  // await mockInstallmentsApi.createInstallmentFromRequest(request);
  
  return updatedRequest;
}
```

**البيانات المُمررة:**
- معلومات العميل (ID, Name, Phone, National ID)
- المبلغ المتبقي (بعد الدفعة الأولى)
- قيمة القسط
- عدد الأقساط
- موعد أول دفعة
- فترة السداد
- الفرع

### 3. نظام الإشعارات (`notifications`)

**الإشعارات المطلوبة:**

#### عند إنشاء طلب جديد:
```dart
Notification {
  to: 'المالك',
  title: 'طلب تقسيط جديد',
  body: 'طلب تقسيط من ${branchName} - ${customerName}',
  type: 'installment_request_created',
  data: {requestId, requestNumber, amount},
}
```

#### عند الموافقة:
```dart
Notification {
  to: 'المدير صاحب الطلب',
  title: 'تمت الموافقة على طلب التقسيط',
  body: 'طلب ${requestNumber} - ${customerName}',
  type: 'installment_request_approved',
  data: {requestId, requestNumber},
}
```

#### عند الرفض:
```dart
Notification {
  to: 'المدير صاحب الطلب',
  title: 'تم رفض طلب التقسيط',
  body: 'طلب ${requestNumber} - السبب: ${rejectionReason}',
  type: 'installment_request_rejected',
  data: {requestId, requestNumber, rejectionReason},
}
```

#### في موعد دفع القسط:
```dart
// كل شهر/أسبوع/يوم حسب payment_interval
Notification {
  to: ['المالك', 'المدير التابع للفرع'],
  title: 'موعد دفع قسط',
  body: 'قسط ${customerName} - ${installmentAmount} جنيه - ${dueDate}',
  type: 'installment_payment_due',
  data: {installmentId, customerId, amount, dueDate},
}
```

**التنفيذ:**
```dart
// في notification service
class InstallmentNotificationScheduler {
  // جدولة إشعار موعد الدفع
  Future<void> schedulePaymentReminder({
    required String installmentId,
    required DateTime dueDate,
    required String customerName,
    required double amount,
    required String branchId,
  }) async {
    // استخدام flutter_local_notifications
    // أو background_fetch
    // أو work_manager
    
    // Schedule notification for:
    // 1. يوم موعد الدفع (8 صباحًا)
    // 2. قبل موعد الدفع بيوم (تذكير)
    // 3. بعد موعد الدفع بيوم (متأخر)
  }
}
```

---

## 📊 الإحصائيات

### المتاحة حاليًا:
```dart
{
  'total': int,              // إجمالي الطلبات
  'pending': int,            // المعلقة
  'approved': int,           // الموافق عليها
  'rejected': int,           // المرفوضة
  'cancelled': int,          // الملغاة
  'total_amount': double,    // إجمالي المبالغ
  'approved_amount': double, // المبالغ الموافق عليها
  'avg_approval_time_hours': double,  // متوسط وقت الموافقة
  'approval_rate': double,   // نسبة الموافقة (%)
}
```

### يمكن إضافة:
- توزيع الطلبات حسب الفرع
- توزيع الطلبات حسب فترة السداد
- متوسط قيمة القسط
- أكثر المديرين طلبًا
- أكثر الفروع طلبات موافق عليها

---

## 🧪 السيناريوهات للاختبار

### 1. المدير يُنشئ طلب تقسيط
```
1. تسجيل دخول كمدير
2. الانتقال إلى "طلبات التقسيط"
3. الضغط على زر "طلب جديد" (FAB)
4. تعبئة جميع البيانات:
   - اسم العميل: "محمد علي"
   - رقم العميل: "CUST-TEST-001"
   - رقم الهاتف: "01234567890"
   - الرقم القومي: "12345678901234"
   - رقم الفاتورة: "INV-TEST-001"
   - المبلغ الإجمالي: 50000
   - الدفعة الأولى: 10000
   - قيمة القسط: 5000
   - عدد الأقساط: 8
   - موعد أول دفعة: (بعد شهر)
   - فترة السداد: شهري
   - ملاحظات: "عميل جديد - أول تعامل"
5. الضغط على "إرسال الطلب للمالك"
6. التحقق من رسالة النجاح
7. التحقق من ظهور الطلب في القائمة (تبويب "معلق")
```

### 2. المالك يوافق على الطلب
```
1. تسجيل دخول كمالك
2. الانتقال إلى "طلبات التقسيط"
3. التحقق من badge عدد الطلبات المعلقة
4. الانتقال لتبويب "معلق"
5. الضغط على بطاقة الطلب
6. مراجعة جميع التفاصيل
7. الضغط على زر "موافقة" (أخضر)
8. تأكيد الموافقة في الـ dialog
9. التحقق من رسالة النجاح
10. التحقق من انتقال الطلب لتبويب "موافق"
11. التحقق من ظهور تاريخ المراجعة واسم المراجع
```

### 3. المالك يرفض الطلب
```
1. تسجيل دخول كمالك
2. الانتقال إلى طلب معلق
3. الضغط على زر "رفض" (أحمر)
4. إدخال سبب الرفض: "المبلغ كبير جدًا والعميل جديد"
5. الضغط على "رفض الطلب"
6. التحقق من رسالة النجاح
7. التحقق من ظهور الطلب في تبويب "مرفوض"
8. التحقق من ظهور سبب الرفض في البطاقة والتفاصيل
```

### 4. البحث في الطلبات
```
1. الذهاب إلى قائمة الطلبات
2. استخدام شريط البحث (TODO: إضافته)
3. البحث برقم الهاتف: "01234567890"
4. البحث برقم الفاتورة: "INV-TEST-001"
5. البحث باسم العميل: "محمد"
6. التحقق من النتائج الصحيحة
```

### 5. الإحصائيات
```
1. طلب الإحصائيات من API
2. التحقق من الأرقام الصحيحة:
   - إجمالي الطلبات = 6 (5 mock + 1 جديد)
   - المعلقة = X
   - الموافق عليها = X
   - المرفوضة = X
   - إجمالي المبالغ
   - نسبة الموافقة
```

---

## 📝 TODO - التحسينات المستقبلية

### 1. البحث والفلترة ✨
```dart
// إضافة شريط بحث في InstallmentRequestsPage
// إضافة فلاتر متقدمة:
// - حسب الفرع
// - حسب المدير
// - حسب نطاق المبلغ
// - حسب نطاق التاريخ
// - حسب فترة السداد
```

### 2. ربط مع نظام الأقساط ✨
```dart
// عند الموافقة:
await mockInstallmentsApi.createInstallmentPlan({
  customerId: request.customerId,
  customerName: request.customerName,
  invoiceId: request.invoiceId,
  totalAmount: request.remainingAmount,
  installmentAmount: request.installmentAmount,
  numberOfInstallments: request.numberOfInstallments,
  firstPaymentDate: request.firstPaymentDate,
  paymentInterval: request.paymentInterval,
  branchId: request.branchId,
});
```

### 3. الإشعارات ⏰
```dart
// عند الإنشاء
await notificationService.sendToOwner(
  'طلب تقسيط جديد',
  'طلب من ${request.branchName} - ${request.customerName}',
);

// عند الموافقة/الرفض
await notificationService.sendToManager(
  request.requestedBy,
  title,
  body,
);

// موعد الدفع (Scheduled)
await notificationService.schedulePaymentReminder(
  installmentId: id,
  dueDate: dueDate,
  recipients: [ownerId, managerId],
);
```

### 4. التقارير 📊
```dart
class InstallmentRequestsReportPage {
  // تقرير شامل:
  // - الرسوم البيانية (Charts)
  // - توزيع حسب الفرع
  // - توزيع حسب الحالة
  // - اتجاهات الموافقة
  // - متوسط المبالغ
  // - Export PDF
}
```

### 5. التعليقات والمناقشة 💬
```dart
class InstallmentRequestComment {
  final String commentId;
  final String requestId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;
}

// في صفحة التفاصيل:
// قسم للتعليقات
// المالك والمدير يمكنهم التعليق
// المدير يمكنه الرد على تساؤلات المالك
```

### 6. المرفقات 📎
```dart
// إضافة صور/ملفات للطلب
class InstallmentRequestAttachment {
  final String attachmentId;
  final String requestId;
  final String type; // 'image', 'pdf', 'doc'
  final String url;
  final String filename;
  final int sizeBytes;
  final DateTime uploadedAt;
}

// أمثلة:
// - صورة بطاقة العميل
// - صورة الفاتورة
// - عقد التقسيط الموقع
```

### 7. النسخ والتعديل 🔄
```dart
// في قائمة الطلبات المرفوضة:
// زر "إعادة تقديم" - ينسخ البيانات ويفتح صفحة إنشاء جديدة

// للطلبات المعلقة (للمدير فقط):
// زر "تعديل" - يعدل البيانات قبل موافقة المالك
```

### 8. التصدير والطباعة 🖨️
```dart
// تصدير الطلبات:
// - Excel
// - PDF
// - CSV

// طباعة تفاصيل الطلب
// - تنسيق احترافي
// - يتضمن شعار الشركة
// - تفاصيل كاملة
```

---

## 🎨 التخصيص

### الألوان المستخدمة:
```dart
// الحالات
pending → AppColors.warning (برتقالي)
approved → AppColors.success (أخضر)
rejected → AppColors.errorDark (أحمر)
cancelled → AppColors.textSecondary (رمادي)

// التمييز
highlighted values → AppColors.goldenNeon
primary text → AppColors.textPrimary
secondary text → AppColors.textSecondary
background → AppColors.background
cards → AppColors.card
borders → AppColors.border
```

### الأيقونات:
```dart
person → بيانات العميل
receipt_long → بيانات الفاتورة
payment → تفاصيل التقسيط
info → بيانات الطلب
check_circle → موافقة
block → رفض
pending → معلق
```

---

## ✅ ملخص الإنجاز

### تم إنشاء:
1. ✅ 3 نماذج domain كاملة
2. ✅ Mock API متكامل (10+ وظائف)
3. ✅ 5 طلبات تجريبية متنوعة
4. ✅ 3 صفحات presentation كاملة
5. ✅ ربط مع routing + permissions
6. ✅ تصميم responsive
7. ✅ معالجة exceptions شاملة
8. ✅ validation كامل
9. ✅ UX/UI احترافي
10. ✅ توثيق شامل

### جاهز للاستخدام:
- ✅ المدير يمكنه إنشاء طلبات
- ✅ المالك يمكنه المراجعة والموافقة/الرفض
- ✅ القوائم والتبويبات تعمل
- ✅ التفاصيل كاملة
- ✅ الصلاحيات محددة
- ✅ جاهز للربط مع الأقساط والإشعارات

### التالي:
- 🔄 ربط مع نظام الأقساط
- 🔔 إضافة الإشعارات
- 📊 صفحة الإحصائيات
- 🔍 البحث المتقدم

---

**تاريخ الإنشاء:** 2024-11-25  
**الحالة:** ✅ مكتمل وجاهز للاختبار  
**الإصدار:** 1.0.0
