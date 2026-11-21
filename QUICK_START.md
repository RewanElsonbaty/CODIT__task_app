# 🚀 Quick Start Guide

## التشغيل السريع للمشروع

### 1️⃣ تشغيل التطبيق
```bash
# تشغيل على محاكي أو جهاز متصل
flutter run

# تشغيل على جهاز محدد
flutter run -d <device-id>

# عرض الأجهزة المتاحة
flutter devices
```

### 2️⃣ تشغيل الاختبارات
```bash
# تشغيل جميع الاختبارات
flutter test

# تشغيل Gold Calculator Tests (الأهم - 13/13 passing ✅)
flutter test test/features/gold_sales/gold_calculator_test.dart

# تشغيل Authentication Tests
flutter test test/features/authentication/auth_critical_test.dart

# تشغيل Approvals Tests
flutter test test/features/approvals/approvals_critical_test.dart

# تشغيل Installments Tests
flutter test test/features/installments/installments_critical_test.dart

# تشغيل Branch Monitoring Tests
flutter test test/features/branch_monitoring/monitoring_critical_test.dart

# تشغيل مع عرض التفاصيل
flutter test --verbose
```

### 3️⃣ تنسيق الكود
```bash
# تنسيق كل الملفات
dart format lib/ test/

# تنسيق ملف محدد
dart format lib/features/gold_sales/domain/gold_calculator.dart

# فحص بدون تعديل
dart format --output=none lib/
```

### 4️⃣ تحليل الكود
```bash
# تشغيل static analysis
flutter analyze

# تحليل شامل
dart analyze
```

---

## 📱 الشاشات المتاحة

### Gold POS Screen (✅ Complete)
للوصول للشاشة من main.dart:
```dart
MaterialApp(
  home: GoldSalePage(), // ✅ جاهزة للاستخدام
)
```

**Features:**
- إضافة منتجات
- حساب تلقائي
- إضافة بدل
- طرق دفع متعددة
- حفظ مسودة
- إتمام البيع

---

## 🔐 بيانات الاختبار

### Mock Users
```
Username: admin@codit.gold
Password: Admin@123
Role: Admin (كل الصلاحيات)

Username: manager@codit.gold
Password: Manager@123
Role: Branch Manager

Username: cashier@codit.gold
Password: Cashier@123
Role: Cashier
```

### Mock Products
```
- خاتم ذهب عيار 21 (4.5g)
- خاتم ذهب عيار 18 (3.5g)
- سلسلة ذهب عيار 21 (12g)
- أسورة ذهب عيار 21 (18g)
- أقراط ذهب عيار 18 (6g)
```

---

## 🧪 Test Case الأساسي

### Gold POS Calculator Test
```bash
flutter test test/features/gold_sales/gold_calculator_test.dart
```

**Input:**
- Gross Weight: 4500mg (4.5g)
- Stones Weight: 300mg (0.3g)  
- Net Weight: 4200mg (4.2g)
- Price per gram: 4200 EGP
- Making charge: 120 EGP/gram
- Discount: 10%

**Expected Output:** 18,157.10 EGP
**Actual Output:** 18,157.10 EGP ✅

---

## 📊 Mock APIs

### استخدام Mock APIs في الكود:

```dart
// 1. Authentication
import 'package:codit/features/authentication/data/mock_auth_api.dart';

final api = MockAuthApi();
final result = await api.login(
  username: 'admin@codit.gold',
  password: 'Admin@123',
  deviceId: 'device_001',
);

// 2. Gold Sales
import 'package:codit/features/gold_sales/data/mock_gold_sales_api.dart';

final api = MockGoldSalesApi();
final products = await api.getAllProducts();

// 3. Installments
import 'package:codit/features/installments/data/mock_installments_api.dart';

final api = MockInstallmentsApi();
final contracts = await api.getOverdueContracts();

// 4. Approvals
import 'package:codit/features/approvals/data/mock_approvals_api.dart';

final api = MockApprovalsApi();
final pending = await api.getPendingRequests(userId: 'user_002');

// 5. Branch Monitoring
import 'package:codit/features/branch_monitoring/data/mock_monitoring_api.dart';

final api = MockMonitoringApi();
final metrics = await api.getLiveMetrics('branch_main');
```

---

## 🎨 Theme Usage

### استخدام الألوان:
```dart
import 'package:codit/core/theme/app_colors.dart';

// Primary colors
AppColors.goldenNeon  // #FFD700
AppColors.background  // #171514
AppColors.card        // #2A2725

// Text colors
AppColors.textPrimary    // #FFFFFF
AppColors.textSecondary  // #9CA3AF

// Status colors
AppColors.successDark  // Success
AppColors.errorDark    // Error
AppColors.warningDark  // Warning
```

### استخدام Luxury Theme:
```dart
import 'package:codit/core/theme/luxury_theme.dart';

MaterialApp(
  theme: LuxuryTheme.darkTheme,
  // ...
)
```

---

## 📱 Responsive Design

### استخدام ResponsiveUtils:
```dart
import 'package:codit/core/utils/responsive_utils.dart';

// Check device type
if (ResponsiveUtils.isMobile(context)) {
  return MobileLayout();
} else if (ResponsiveUtils.isTablet(context)) {
  return TabletLayout();
} else {
  return DesktopLayout();
}

// Adaptive spacing
final spacing = ResponsiveUtils.spacing(context);
// Mobile: 16, Tablet: 24, Desktop: 32

// Adaptive font size
final fontSize = ResponsiveUtils.fontSize(context, base: 14);
// Mobile: 14, Tablet: 16, Desktop: 18
```

---

## 🔧 Troubleshooting

### مشاكل شائعة وحلولها:

#### 1. Build fails
```bash
# تنظيف ال build
flutter clean
flutter pub get
flutter run
```

#### 2. Tests fail
```bash
# إعادة تنصيب dependencies
flutter pub get
flutter test --no-pub
```

#### 3. Import errors
```bash
# التأكد من package name صحيح
# في pubspec.yaml: name: codit
# في imports: import 'package:codit/...'
```

#### 4. Theme issues
```bash
# التأكد من استخدام LuxuryTheme.darkTheme
# في main.dart
```

---

## 📂 هيكل المشروع

```
lib/
├── core/               # المكونات المشتركة
│   ├── data/          # Mock API Client
│   ├── theme/         # Luxury Theme
│   └── utils/         # Responsive Utils
│
└── features/          # الوحدات
    ├── authentication/    # المصادقة
    ├── gold_sales/       # نقاط البيع ✅
    ├── installments/     # الأقساط
    ├── approvals/        # الموافقات
    └── branch_monitoring/ # المراقبة
```

---

## 📄 الملفات المهمة

### Documentation
- `README.md` - نظرة عامة على المشروع
- `IMPLEMENTATION_SUMMARY.md` - ملخص شامل للتنفيذ
- `COMPLETION_STATUS.md` - حالة الإنجاز
- `QUICK_START.md` - هذا الملف

### Tests
- `test/features/gold_sales/gold_calculator_test.dart` ✅
- `test/features/authentication/auth_critical_test.dart` ✅
- `test/features/approvals/approvals_critical_test.dart` ✅
- `test/features/installments/installments_critical_test.dart` ✅
- `test/features/branch_monitoring/monitoring_critical_test.dart` ✅

---

## ✅ Checklist قبل المراجعة

- [x] التطبيق يعمل بدون أخطاء
- [x] جميع tests تعمل
- [x] الكود منسق (dart format)
- [x] لا توجد warnings (flutter analyze)
- [x] Documentation كاملة
- [x] Gold POS UI كاملة
- [x] Mock APIs جاهزة
- [x] Critical Tests جاهزة

---

## 📞 Support

إذا واجهت أي مشكلة:
1. تحقق من هذا الملف
2. راجع README.md
3. افحص IMPLEMENTATION_SUMMARY.md
4. شغل `flutter doctor` للتأكد من البيئة

---

**Built with Flutter 💙 | Ready to Review ✅**
