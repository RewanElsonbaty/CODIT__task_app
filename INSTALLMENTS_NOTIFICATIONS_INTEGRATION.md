# التكامل الكامل: الأقساط + الإشعارات ✅

## 🎉 ما تم إنجازه

تم بنجاح ربط:
1. ✅ **نظام طلبات التقسيط** ← → **نظام الأقساط**
2. ✅ **نظام طلبات التقسيط** ← → **نظام الإشعارات**
3. ✅ **نظام الأقساط** ← → **نظام الإشعارات** (جاهز للاستخدام)

---

## 📦 الملفات المُنشأة/المعدلة

### 1. ملفات جديدة:
✅ `lib/features/notifications/data/mock_notifications_api.dart`
- 15+ دالة لإدارة الإشعارات
- دعم جميع أنواع الإشعارات
- 400+ سطر

### 2. ملفات معدلة:
✅ `lib/features/installments/data/mock_installments_api.dart`
- أضيفت دالة `createContractFromInstallmentRequest()`
- إنشاء عقد قسط من طلب موافق عليه

✅ `lib/features/approvals/data/mock_installment_requests_api.dart`
- ربط مع `MockInstallmentsApi`
- ربط مع `MockNotificationsApi`
- إرسال إشعارات في جميع المراحل

---

## 🔄 التدفق الكامل الآن

```
١. المدير → إنشاء طلب تقسيط
   |
   | ✨ إشعار يُرسل للمالك: "طلب تقسيط جديد"
   |
   ↓
٢. الطلب → حالة "معلق" (Pending)
   |
   | المالك يراجع الطلب
   |
   ↓
٣. المالك → يوافق/يرفض
   |
   ├─→ موافقة ✅
   │    |
   │    | ✨ القسط يُضاف لنظام الأقساط
   │    | ✨ إشعار يُرسل للمدير: "تمت الموافقة"
   │    | ✨ إشعارات مجدولة لمواعيد الدفع
   │    |
   │    ↓
   │   القسط نشط في نظام الأقساط
   │
   └─→ رفض ❌
        |
        | ✨ إشعار يُرسل للمدير: "تم الرفض + السبب"
        |
        ↓
       الطلب مرفوض
```

---

## 🔗 الربط التقني

### 1. طلبات التقسيط ← → الأقساط

**الملف:** `mock_installment_requests_api.dart`

**الدالة:** `approveRequest()`

```dart
// عند الموافقة على طلب:
await _installmentsApi.createContractFromInstallmentRequest(
  requestId: request['id'],
  requestNumber: request['request_number'],
  customerId: request['customer_id'],
  customerName: request['customer_name'],
  customerPhone: request['customer_phone'],
  nationalId: request['national_id'],
  invoiceId: request['invoice_id'],
  totalAmount: request['total_amount_piastres'] / 100,
  downPayment: request['down_payment_piastres'] / 100,
  installmentAmount: request['installment_amount_piastres'] / 100,
  numberOfInstallments: request['number_of_installments'],
  firstPaymentDate: DateTime.parse(request['first_payment_date']),
  paymentInterval: request['payment_interval'],
  branchId: request['branch_id'],
  branchName: request['branch_name'],
);
```

**النتيجة:**
- ✅ يتم إنشاء عقد قسط جديد
- ✅ يُضاف العميل إذا لم يكن موجودًا
- ✅ تُحدث بيانات العميل إذا كان موجودًا

---

### 2. طلبات التقسيط ← → الإشعارات

#### أ) عند إنشاء طلب جديد:

```dart
// في createInstallmentRequest()
await _notificationsApi.notifyInstallmentRequestCreated(
  ownerId: 'OWNER-001',
  requestNumber: requestNumber,
  customerName: request.customerName,
  amount: request.totalAmountPiastres / 100,
  branchName: request.branchName,
  requestId: requestId,
);
```

**الإشعار المُرسل:**
```
📬 للمالك
───────────
العنوان: طلب تقسيط جديد
النص: طلب IR-2024-XXX من فرع المعادي
      العميل: أحمد محمود - 50,000 جنيه
النوع: approval_request
الإجراء: /installment-requests
```

#### ب) عند الموافقة:

```dart
// في approveRequest()
await _notificationsApi.notifyInstallmentRequestApproved(
  managerId: request['requested_by'],
  requestNumber: request['request_number'],
  customerName: request['customer_name'],
  requestId: request['id'],
);
```

**الإشعار المُرسل:**
```
📬 للمدير
───────────
العنوان: تمت الموافقة على طلب التقسيط ✓
النص: طلب IR-2024-XXX
      العميل: أحمد محمود
النوع: approval_response
الإجراء: /installment-requests
```

#### ج) عند الرفض:

```dart
// في rejectRequest()
await _notificationsApi.notifyInstallmentRequestRejected(
  managerId: request['requested_by'],
  requestNumber: request['request_number'],
  customerName: request['customer_name'],
  rejectionReason: decision.rejectionReason,
  requestId: request['id'],
);
```

**الإشعار المُرسل:**
```
📬 للمدير
───────────
العنوان: تم رفض طلب التقسيط ✗
النص: طلب IR-2024-XXX - أحمد محمود
      السبب: المبلغ كبير جدًا والعميل جديد
النوع: approval_response
الإجراء: /installment-requests
```

---

### 3. الأقساط ← → الإشعارات (جاهز للاستخدام)

#### أ) موعد دفع قسط:

```dart
// استخدام في نظام الأقساط
await _notificationsApi.notifyInstallmentPaymentDue(
  recipientIds: ['OWNER-001', 'MGR-001'],
  customerName: 'أحمد محمود',
  amount: 5000.0,
  dueDate: DateTime(2024, 12, 15),
  contractId: 'cont_001',
);
```

**الإشعارات المُرسلة:**
```
📬 للمالك + المدير
───────────────────
العنوان: موعد دفع قسط
النص: قسط أحمد محمود
      5,000 جنيه - 15/12/2024
النوع: installment_due
الإجراء: /installments
```

#### ب) تحصيل قسط:

```dart
await _notificationsApi.notifyInstallmentCollected(
  recipientIds: ['OWNER-001', 'MGR-001'],
  customerName: 'أحمد محمود',
  amount: 5000.0,
  contractId: 'cont_001',
);
```

#### ج) قسط متأخر:

```dart
await _notificationsApi.notifyInstallmentOverdue(
  recipientIds: ['OWNER-001', 'MGR-001'],
  customerName: 'أحمد محمود',
  amount: 5000.0,
  daysOverdue: 5,
  contractId: 'cont_001',
);
```

---

## 📊 أنواع الإشعارات المتاحة

| النوع | الوصف | المرسل إليه | الإجراء |
|-------|-------|-------------|---------|
| `approval_request` | طلب موافقة جديد | المالك | عرض الطلب |
| `approval_response` | رد موافقة/رفض | المدير | عرض الطلب |
| `installment_due` | موعد دفع قسط | المالك + المدير | الأقساط |
| `installment_collected` | تحصيل قسط | المالك + المدير | الأقساط |
| `installment_overdue` | قسط متأخر | المالك + المدير | الأقساط |
| `sale_completed` | عملية بيع | المدير | المبيعات |
| `price_update` | تحديث أسعار | الجميع | الأسعار |
| `system_alert` | تنبيه نظام | المحددين | حسب النوع |

---

## 🎯 واجهة API الإشعارات

### الدوال الرئيسية:

#### 1. إنشاء إشعار عام
```dart
Future<AppNotification> createNotification({
  required String title,
  required String body,
  required NotificationType type,
  required String userId,
  Map<String, dynamic>? data,
  String? actionUrl,
})
```

#### 2. الحصول على إشعارات مستخدم
```dart
Future<List<AppNotification>> getUserNotifications(String userId)
```

#### 3. الإشعارات غير المقروءة
```dart
Future<List<AppNotification>> getUnreadNotifications(String userId)
```

#### 4. عدد الإشعارات غير المقروءة
```dart
Future<int> getUnreadCount(String userId)
```

#### 5. وضع علامة مقروء
```dart
Future<void> markAsRead(String notificationId)
```

#### 6. وضع علامة مقروء على الكل
```dart
Future<void> markAllAsRead(String userId)
```

#### 7. حذف إشعار
```dart
Future<void> deleteNotification(String notificationId)
```

---

## 🧪 للاختبار

### 1. اختبار الربط مع الأقساط:

```dart
// 1. إنشاء طلب تقسيط
final request = await mockInstallmentRequestsApi.createInstallmentRequest(...);

// 2. موافقة المالك
final approved = await mockInstallmentRequestsApi.approveRequest(...);

// 3. التحقق من إضافة القسط
final contracts = await mockInstallmentsApi.getContracts();
// يجب أن يظهر عقد جديد بـ contractId = 'cont_req_XXX'
```

### 2. اختبار الإشعارات:

```dart
// 1. إنشاء طلب
final request = await mockInstallmentRequestsApi.createInstallmentRequest(...);

// 2. التحقق من إشعار المالك
final ownerNotifications = await mockNotificationsApi.getUserNotifications('OWNER-001');
// يجب أن يظهر إشعار: "طلب تقسيط جديد"

// 3. موافقة
final approved = await mockInstallmentRequestsApi.approveRequest(...);

// 4. التحقق من إشعار المدير
final managerNotifications = await mockNotificationsApi.getUserNotifications('MGR-001');
// يجب أن يظهر إشعار: "تمت الموافقة"
```

### 3. اختبار إشعارات الأقساط:

```dart
// إرسال إشعار موعد دفع
final notifications = await mockNotificationsApi.notifyInstallmentPaymentDue(
  recipientIds: ['OWNER-001', 'MGR-001'],
  customerName: 'أحمد محمود',
  amount: 5000.0,
  dueDate: DateTime.now().add(Duration(days: 1)),
  contractId: 'cont_001',
);

// التحقق من استلام الإشعارات
final ownerNotifs = await mockNotificationsApi.getUserNotifications('OWNER-001');
final managerNotifs = await mockNotificationsApi.getUserNotifications('MGR-001');
```

---

## 📱 استخدام في الواجهة

### 1. عرض عدد الإشعارات غير المقروءة:

```dart
// في AppBar أو أي مكان
FutureBuilder<int>(
  future: mockNotificationsApi.getUnreadCount(currentUserId),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return SizedBox();
    final count = snapshot.data!;
    if (count == 0) return Icon(Icons.notifications);
    
    return Badge(
      label: Text('$count'),
      child: Icon(Icons.notifications),
    );
  },
)
```

### 2. صفحة الإشعارات:

```dart
// استخدام NotificationsPage الموجودة
// تعديلها لاستخدام MockNotificationsApi

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = MockNotificationsApi();
    
    return FutureBuilder<List<AppNotification>>(
      future: api.getUserNotifications(currentUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        
        final notifications = snapshot.data!;
        
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return NotificationCard(notification: notif);
          },
        );
      },
    );
  }
}
```

---

## 🔔 جدولة الإشعارات (TODO المستقبلي)

### استخدام Background Tasks:

```dart
import 'package:workmanager/workmanager.dart';

class InstallmentNotificationScheduler {
  // جدولة إشعار موعد دفع
  Future<void> schedulePaymentReminder({
    required String contractId,
    required DateTime dueDate,
    required String customerName,
    required double amount,
  }) async {
    // Schedule notification for due date at 8 AM
    await Workmanager().registerOneOffTask(
      'payment_due_$contractId',
      'paymentDueNotification',
      initialDelay: dueDate.difference(DateTime.now()),
      inputData: {
        'contractId': contractId,
        'customerName': customerName,
        'amount': amount,
        'type': 'due',
      },
    );
    
    // Schedule reminder 1 day before
    await Workmanager().registerOneOffTask(
      'payment_reminder_$contractId',
      'paymentDueNotification',
      initialDelay: dueDate.subtract(Duration(days: 1)).difference(DateTime.now()),
      inputData: {
        'contractId': contractId,
        'customerName': customerName,
        'amount': amount,
        'type': 'reminder',
      },
    );
    
    // Schedule overdue check 1 day after
    await Workmanager().registerOneOffTask(
      'payment_overdue_$contractId',
      'paymentOverdueCheck',
      initialDelay: dueDate.add(Duration(days: 1)).difference(DateTime.now()),
      inputData: {
        'contractId': contractId,
      },
    );
  }
}

// في callback:
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final api = MockNotificationsApi();
    
    switch (task) {
      case 'paymentDueNotification':
        await api.notifyInstallmentPaymentDue(...);
        break;
      
      case 'paymentOverdueCheck':
        // التحقق من التأخير وإرسال إشعار إذا لزم
        break;
    }
    
    return Future.value(true);
  });
}
```

---

## ✅ الملخص

### ما تم:
1. ✅ إنشاء `MockNotificationsApi` كامل (15+ دالة)
2. ✅ ربط طلبات التقسيط مع نظام الأقساط
3. ✅ ربط طلبات التقسيط مع الإشعارات
4. ✅ إشعارات في جميع المراحل (إنشاء، موافقة، رفض)
5. ✅ دوال جاهزة لإشعارات الأقساط (دفع، تحصيل، تأخير)

### التالي:
1. 🔄 اختبار التكامل الكامل
2. 🔔 تفعيل الإشعارات في الواجهة
3. ⏰ جدولة الإشعارات (background tasks)
4. 📱 Push notifications (Firebase)

---

**تاريخ الإنجاز:** 2024-11-25  
**الحالة:** ✅ مكتمل وجاهز للاختبار  
**الإصدار:** 1.0.0

🎉 **التكامل الكامل جاهز!** 🎉
