# Quick Reference - استخدام ResponsiveUtils و ExceptionHandler

## 🎯 ResponsiveUtils - التصميم المتجاوب

### 1. Device Type Check
```dart
if (ResponsiveUtils.isMobile(context)) {
  // Mobile layout
} else if (ResponsiveUtils.isTablet(context)) {
  // Tablet layout
} else {
  // Desktop layout
}
```

### 2. Responsive Values
```dart
// طريقة سريعة لقيم مختلفة حسب الجهاز
final fontSize = ResponsiveUtils.valueWhen(
  context: context,
  mobile: 14.0,
  tablet: 16.0,
  desktop: 18.0,
);
```

### 3. Quick Sizes
```dart
// Padding
padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context))

// Spacing
SizedBox(height: ResponsiveUtils.spacing(context, factor: 2))

// Icons
Icon(Icons.home, size: ResponsiveUtils.iconSize(context))

// Text
Text('Hello', style: TextStyle(
  fontSize: ResponsiveUtils.textSizeMedium(context)
))

// Border Radius
borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context))

// Button Height
height: ResponsiveUtils.buttonHeight(context)
```

### 4. Responsive Widgets

#### ResponsiveContainer - للصفحات
```dart
ResponsiveContainer(
  maxWidth: 800,  // اختياري
  child: Column(
    children: [...],
  ),
)
```

#### ResponsiveLayout - Row/Column تلقائي
```dart
// يتحول من Row إلى Column على الموبايل
ResponsiveLayout(
  children: [
    Expanded(child: Widget1()),
    SizedBox(width: 16),
    Expanded(child: Widget2()),
  ],
)
```

#### ResponsiveBuilder - Custom Logic
```dart
ResponsiveBuilder(
  builder: (context, isMobile) {
    return isMobile
      ? MobileView()
      : DesktopView();
  },
)
```

---

## 🛡️ ExceptionHandler - معالجة الأخطاء

### 1. Basic Try-Catch
```dart
void _handleAction() async {
  try {
    await someAsyncOperation();
  } catch (e) {
    ExceptionHandler.logException(e);
    if (mounted) {
      ExceptionHandler.showErrorSnackBar(context, e);
    }
  }
}
```

### 2. في BLoC/Cubit
```dart
Future<void> login() async {
  try {
    emit(AuthLoading());
    final user = await repository.login();
    emit(AuthSuccess(user));
  } catch (e) {
    ExceptionHandler.logException(e);
    emit(AuthError(ExceptionHandler.getErrorMessage(e)));
  }
}
```

### 3. في Widget مع Navigation
```dart
onPressed: () async {
  try {
    await context.read<SomeCubit>().doSomething();
    if (context.mounted) {
      context.go('/success');
    }
  } catch (e) {
    ExceptionHandler.logException(e);
    if (context.mounted) {
      ExceptionHandler.showErrorDialog(context, e);
    }
  }
}
```

### 4. اختيار Dialog أو SnackBar

#### استخدم Dialog للأخطاء الحرجة:
```dart
ExceptionHandler.showErrorDialog(context, error);
// - Login failure
// - Payment failure
// - Data loss warning
```

#### استخدم SnackBar للأخطاء البسيطة:
```dart
ExceptionHandler.showErrorSnackBar(context, error);
// - Network timeout
// - Validation errors
// - Data refresh failure
```

---

## 📋 Cheat Sheet - الأحجام

### Mobile (< 600px)
```dart
Padding:   16-24
Font:      12-16
Icons:     24
Buttons:   48 height
Columns:   1-2
```

### Tablet (600-900px)
```dart
Padding:   20-32
Font:      13-18
Icons:     28
Buttons:   52 height
Columns:   2-3
```

### Desktop (> 900px)
```dart
Padding:   24-48
Font:      14-20
Icons:     32
Buttons:   56 height
Columns:   3-4
```

---

## 🎨 مثال كامل - Responsive Screen

```dart
import 'package:flutter/material.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/utils/exception_handler.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Screen',
          style: TextStyle(
            fontSize: ResponsiveUtils.textSizeLarge(context),
          ),
        ),
      ),
      body: ResponsiveContainer(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(
            ResponsiveUtils.horizontalPadding(context),
          ),
          child: Column(
            children: [
              // Header
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: ResponsiveUtils.valueWhen(
                    context: context,
                    mobile: 24.0,
                    tablet: 28.0,
                    desktop: 32.0,
                  ),
                ),
              ),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 3)),
              
              // Cards in responsive layout
              ResponsiveLayout(
                children: [
                  Expanded(child: Card1()),
                  SizedBox(
                    width: ResponsiveUtils.isMobile(context) ? 0 : 16,
                    height: ResponsiveUtils.isMobile(context) ? 16 : 0,
                  ),
                  Expanded(child: Card2()),
                ],
              ),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // Button
              SizedBox(
                width: double.infinity,
                height: ResponsiveUtils.buttonHeight(context),
                child: ElevatedButton(
                  onPressed: _handlePress,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _handlePress() async {
    try {
      await someOperation();
    } catch (e) {
      ExceptionHandler.logException(e);
      if (mounted) {
        ExceptionHandler.showErrorSnackBar(context, e);
      }
    }
  }
}
```

---

## 🚀 Best Practices

### ✅ DO:
```dart
// استخدم ResponsiveUtils للأحجام
padding: EdgeInsets.all(ResponsiveUtils.spacing(context))

// استخدم mounted check
if (mounted) {
  ExceptionHandler.showErrorSnackBar(context, e);
}

// استخدم try-catch للعمليات async
try {
  await operation();
} catch (e) {
  ExceptionHandler.logException(e);
}

// استخدم ResponsiveLayout للصفوف
ResponsiveLayout(children: [...])
```

### ❌ DON'T:
```dart
// لا تستخدم أحجام ثابتة
padding: const EdgeInsets.all(16) ❌

// لا تنسى mounted check
ExceptionHandler.showErrorDialog(context, e) ❌

// لا تترك async بدون try-catch
await operation(); // مباشرة ❌

// لا تستخدم Row مباشرة للعناصر المتعددة
Row(children: [Widget1(), Widget2()]) ❌
```

---

## 📱 Testing Checklist

عند إضافة شاشة جديدة، تأكد من:

- [ ] استخدام ResponsiveUtils للأحجام
- [ ] استخدام ResponsiveContainer أو ResponsiveLayout
- [ ] استخدام try-catch في العمليات async
- [ ] استخدام mounted check قبل showDialog/SnackBar
- [ ] اختبار على 3 أحجام: 375px، 768px، 1440px
- [ ] اختبار الأخطاء (افصل الإنترنت)
- [ ] التأكد من أن الرسائل بالعربية
- [ ] التأكد من أن الـ spacing مناسب

---

## 💡 Tips

1. **للصفحات الجديدة**: ابدأ بنسخ هيكل من صفحة موجودة (LoginScreen أو HomePage)
2. **للأخطاء**: استخدم ExceptionHandler.logException() دائماً للتتبع
3. **للأحجام**: استخدم factor parameter للتحكم (spacing(context, factor: 2))
4. **للتخطيط**: استخدم ResponsiveLayout بدلاً من Row لتوفير الوقت
5. **للاختبار**: استخدم Chrome DevTools وغيّر حجم الشاشة

---

**Happy Coding! 🚀**
