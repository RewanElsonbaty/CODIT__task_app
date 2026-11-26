# 📱 دليل Responsive و RTL/LTR - نظام متكامل

## ✅ ما تم إنجازه

### 1. **نظام الاتجاه (RTL/LTR)** ✅

#### أ. LocaleCubit (جديد):
```dart
// lib/core/localization/locale_cubit.dart
class LocaleCubit extends Cubit<Locale> {
  ✅ تحميل اللغة المحفوظة عند بدء التطبيق
  ✅ تغيير اللغة وحفظها
  ✅ تبديل بين العربية والإنجليزية
  ✅ الحصول على الاتجاه الحالي (RTL/LTR)
}
```

#### ب. main.dart (محدّث):
```dart
// ❌ قبل التحديث
MaterialApp.router(
  locale: const Locale('ar'),
  builder: (context, child) {
    return Directionality(
      textDirection: TextDirection.rtl, // ← ثابت دائماً
      child: child,
    );
  },
)

// ✅ بعد التحديث
BlocBuilder<LocaleCubit, Locale>(
  builder: (context, locale) {
    return MaterialApp.router(
      locale: locale, // ← يتغير حسب الاختيار
      builder: (context, child) {
        final isArabic = locale.languageCode == 'ar';
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child,
        );
      },
    );
  },
)
```

#### ج. LanguageSwitcher Widget (جديد):
```dart
// lib/core/widgets/language_switcher.dart
✅ LanguageSwitcher()     - ListTile كامل مع Switch
✅ LanguageChip()         - Chip بسيط للتبديل
```

---

### 2. **نظام Responsive** ✅

#### ResponsiveUtils (موجود ومحسّن):
```dart
// lib/core/utils/responsive_utils.dart

class ResponsiveUtils {
  // ✅ Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // ✅ Device Type Detection
  static bool isMobile(BuildContext context) {...}
  static bool isTablet(BuildContext context) {...}
  static bool isDesktop(BuildContext context) {...}

  // ✅ Responsive Values
  static T valueWhen<T>({...}) {...}

  // ✅ Dimensions
  static double width(BuildContext context) {...}
  static double height(BuildContext context) {...}
  static double horizontalPadding(BuildContext context) {...}
  static double verticalPadding(BuildContext context) {...}
  static double cardWidth(BuildContext context) {...}

  // ✅ Grid & Layout
  static int gridColumns(BuildContext context) {...}
  static double spacing(BuildContext context, {double factor = 1.0}) {...}
  static double radius(BuildContext context) {...}
  static double iconSize(BuildContext context) {...}
  static double buttonHeight(BuildContext context) {...}

  // ✅ Text Sizes
  static double textSizeSmall(BuildContext context) {...}
  static double textSizeMedium(BuildContext context) {...}
  static double textSizeLarge(BuildContext context) {...}
}
```

#### Helper Widgets (موجودة):
```dart
✅ ResponsiveBuilder    - Builder pattern للتخطيط
✅ ResponsiveContainer  - Container مع قيود responsive
✅ ResponsiveLayout     - Row/Column حسب الحجم
```

---

## 📋 كيفية جعل الكود Responsive

### النمط 1: استخدام valueWhen
```dart
// ✅ Padding
padding: EdgeInsets.all(
  ResponsiveUtils.valueWhen(
    context: context,
    mobile: 16.0,
    tablet: 24.0,
    desktop: 32.0,
  ),
)

// ✅ Font Size
style: TextStyle(
  fontSize: ResponsiveUtils.valueWhen(
    context: context,
    mobile: 14.0,
    tablet: 16.0,
    desktop: 18.0,
  ),
)

// ✅ Width/Height
width: ResponsiveUtils.valueWhen(
  context: context,
  mobile: double.infinity,
  tablet: 600.0,
  desktop: 800.0,
)
```

### النمط 2: استخدام Helper Methods
```dart
// ✅ Horizontal Padding
padding: EdgeInsets.symmetric(
  horizontal: ResponsiveUtils.horizontalPadding(context),
)

// ✅ Spacing
SizedBox(height: ResponsiveUtils.spacing(context, factor: 2.0))

// ✅ Icon Size
Icon(Icons.home, size: ResponsiveUtils.iconSize(context))

// ✅ Button Height
height: ResponsiveUtils.buttonHeight(context)

// ✅ Text Sizes
style: TextStyle(
  fontSize: ResponsiveUtils.textSizeLarge(context),
)
```

### النمط 3: استخدام Device Type
```dart
// ✅ Conditional Layout
if (ResponsiveUtils.isMobile(context)) {
  return Column(children: [...]);
} else {
  return Row(children: [...]);
}

// ✅ Grid Columns
GridView.count(
  crossAxisCount: ResponsiveUtils.gridColumns(context),
  children: [...],
)
```

### النمط 4: استخدام ResponsiveLayout
```dart
// ✅ Auto Row/Column
ResponsiveLayout(
  children: [
    Widget1(),
    Widget2(),
    Widget3(),
  ],
)
// Mobile: Column
// Tablet/Desktop: Row
```

---

## 🎯 Checklist للصفحات الموجودة

### يجب تطبيق على جميع الصفحات:

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ 1. Responsive Padding
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.horizontalPadding(context),
          vertical: ResponsiveUtils.verticalPadding(context),
        ),
        child: Column(
          children: [
            // ✅ 2. Responsive Text
            Text(
              'عنوان',
              style: TextStyle(
                fontSize: ResponsiveUtils.textSizeLarge(context),
              ),
            ),
            
            // ✅ 3. Responsive Spacing
            SizedBox(height: ResponsiveUtils.spacing(context)),
            
            // ✅ 4. Responsive Width
            Container(
              width: ResponsiveUtils.cardWidth(context),
              child: ...,
            ),
            
            // ✅ 5. Responsive Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  double.infinity,
                  ResponsiveUtils.buttonHeight(context),
                ),
              ),
              child: Text('زر'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📊 الصفحات الحالية

### تستخدم ResponsiveUtils (8 صفحات):
```
✅ LoginScreen
✅ BranchesSimplePage
✅ InstallmentsPage
✅ ApprovalsPage
✅ [4 صفحات أخرى]
```

### تحتاج تحديث (20 صفحة):
```
🔄 HomePage
🔄 SettingsPage
🔄 ProfilePage
🔄 NotificationsPage
🔄 [16 صفحة أخرى]
```

---

## 🔧 نموذج تحديث صفحة قديمة

### قبل:
```dart
// ❌ قيم ثابتة
class OldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0), // ← ثابت
        child: Column(
          children: [
            Text(
              'عنوان',
              style: TextStyle(fontSize: 24.0), // ← ثابت
            ),
            SizedBox(height: 16.0), // ← ثابت
            Container(
              width: 300.0, // ← ثابت
              child: ...,
            ),
          ],
        ),
      ),
    );
  }
}
```

### بعد:
```dart
// ✅ قيم responsive
class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          ResponsiveUtils.horizontalPadding(context), // ← responsive
        ),
        child: Column(
          children: [
            Text(
              'عنوان',
              style: TextStyle(
                fontSize: ResponsiveUtils.textSizeLarge(context), // ← responsive
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(context), // ← responsive
            ),
            Container(
              width: ResponsiveUtils.cardWidth(context), // ← responsive
              child: ...,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🌐 استخدام اللغة والاتجاه

### 1. الحصول على اللغة الحالية:
```dart
// في أي Widget
final localeCubit = context.read<LocaleCubit>();
final isArabic = localeCubit.isArabic;
final isEnglish = localeCubit.isEnglish;
final textDirection = localeCubit.textDirection;
```

### 2. تبديل اللغة:
```dart
// تبديل
context.read<LocaleCubit>().toggleLocale();

// تغيير لعربي
context.read<LocaleCubit>().changeLocale('ar');

// تغيير لإنجليزي
context.read<LocaleCubit>().changeLocale('en');
```

### 3. إضافة زر تبديل اللغة:
```dart
// في AppBar
actions: [
  LanguageChip(), // ← Chip بسيط
]

// في Drawer/Settings
LanguageSwitcher(), // ← ListTile كامل
```

---

## 📱 الاختبار

### 1. اختبار Responsive:
```dart
// تشغيل على أحجام مختلفة
flutter run -d windows  // Desktop
flutter run -d chrome   // Web (تغيير حجم المتصفح)
flutter run -d android  // Mobile

// أو استخدام Device Preview
dependencies:
  device_preview: ^1.1.0
```

### 2. اختبار RTL/LTR:
```dart
// تبديل اللغة في Settings
// التحقق من:
✅ النصوص تتحرك من اليمين لليسار (عربي)
✅ النصوص تتحرك من اليسار لليمين (إنجليزي)
✅ الأيقونات في الجهة الصحيحة
✅ الـ Drawer يفتح من الجهة الصحيحة
```

---

## ✨ الخلاصة

### تم إنجازه:
```
✅ LocaleCubit للغة والاتجاه
✅ تحديث main.dart للدعم الكامل
✅ LanguageSwitcher Widget
✅ ResponsiveUtils محسّن وشامل
✅ Helper Widgets للتخطيط
✅ Documentation كامل
```

### النتيجة:
```
✅ العربي: RTL (من اليمين لليسار)
✅ الإنجليزي: LTR (من الشمال لليمين)
✅ Responsive: Mobile + Tablet + Desktop
✅ تبديل اللغة: سهل وسلس
✅ حفظ اللغة: تلقائي
```

---

## 🚀 للتطبيق على صفحة جديدة

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/localization/locale_cubit.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ الحصول على اللغة
    final isArabic = context.read<LocaleCubit>().isArabic;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'عنوان' : 'Title'),
        actions: [
          LanguageChip(), // ✅ زر تبديل اللغة
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.horizontalPadding(context),
          vertical: ResponsiveUtils.verticalPadding(context),
        ),
        child: Column(
          children: [
            // ✅ Responsive Text
            Text(
              isArabic ? 'مرحباً' : 'Welcome',
              style: TextStyle(
                fontSize: ResponsiveUtils.textSizeLarge(context),
              ),
            ),
            
            // ✅ Responsive Spacing
            SizedBox(height: ResponsiveUtils.spacing(context)),
            
            // ✅ Responsive Layout
            ResponsiveLayout(
              children: [
                Card(...),
                Card(...),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

**تاريخ التوثيق**: ${DateTime.now().toString().split('.')[0]}
**الحالة**: ✅ مكتمل
**RTL/LTR**: ✅ يعمل
**Responsive**: ✅ جاهز
