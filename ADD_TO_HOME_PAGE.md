# إضافة زر "طلبات التقسيط" للصفحة الرئيسية

## 📍 الملف المطلوب تعديله

**الملف:** `lib/features/home/presentation/home_page.dart`

---

## ✏️ التعديل المطلوب

### 1. إيجاد قسم بطاقات القائمة (Menu Cards)

ابحث عن السطر الذي يحتوي على:
```dart
GridView.count(
  crossAxisCount: ResponsiveUtils.columns(context, mobile: 2, tablet: 3),
  ...
  children: [
    // هنا البطاقات الموجودة
```

---

### 2. إضافة بطاقة "طلبات التقسيط"

**أضف هذا الكود بعد بطاقة "الموافقات" أو في أي مكان مناسب:**

```dart
// طلبات التقسيط (للمالك والمدير فقط)
if (permissions.contains('all') ||
    permissions.contains('installments') ||
    permissions.contains('approvals'))
  _buildMenuCard(
    context: context,
    title: 'طلبات التقسيط',
    icon: Icons.account_balance_wallet,
    color: Colors.purple,
    onTap: () => context.go('/installment-requests'),
  ),
```

---

### 3. البديل: إضافة كبطاقة مخصصة

إذا كنت تريد تصميم أكثر تميزًا:

```dart
// طلبات التقسيط - بطاقة مميزة
if (permissions.contains('all') ||
    permissions.contains('installments') ||
    permissions.contains('approvals'))
  GestureDetector(
    onTap: () => context.go('/installment-requests'),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.8),
            Colors.deepPurple.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'طلبات التقسيط',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // عدد الطلبات المعلقة (optional)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '3 معلق',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
```

---

## 🎨 خيارات الأيقونة

اختر واحدة من هذه:

```dart
Icons.account_balance_wallet    // محفظة
Icons.payment                   // دفع
Icons.request_quote             // طلب
Icons.receipt_long              // فاتورة طويلة
Icons.attach_money              // نقود
Icons.credit_card               // بطاقة
Icons.money                     // مال (iOS style)
```

---

## 🎨 خيارات الألوان

```dart
Colors.purple          // بنفسجي
Colors.deepPurple      // بنفسجي غامق
Colors.indigo          // نيلي
Colors.teal            // أزرق مخضر
Colors.cyan            // سماوي
Colors.blue            // أزرق
Colors.pink            // وردي
Colors.amber           // كهرماني
```

---

## 📝 مثال كامل

إذا كان الكود الحالي يبدو هكذا:

```dart
GridView.count(
  crossAxisCount: ResponsiveUtils.columns(context, mobile: 2, tablet: 3),
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  childAspectRatio: 1.2,
  children: [
    // مبيعات الذهب
    if (permissions.contains('all') || permissions.contains('gold_sales'))
      _buildMenuCard(...),
    
    // الموافقات
    if (permissions.contains('all') || permissions.contains('approvals'))
      _buildMenuCard(...),
      
    // ... البطاقات الأخرى
  ],
)
```

**أضف بعد "الموافقات":**

```dart
GridView.count(
  crossAxisCount: ResponsiveUtils.columns(context, mobile: 2, tablet: 3),
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  childAspectRatio: 1.2,
  children: [
    // مبيعات الذهب
    if (permissions.contains('all') || permissions.contains('gold_sales'))
      _buildMenuCard(...),
    
    // الموافقات
    if (permissions.contains('all') || permissions.contains('approvals'))
      _buildMenuCard(...),
      
    // 🆕 طلبات التقسيط - NEW!
    if (permissions.contains('all') ||
        permissions.contains('installments') ||
        permissions.contains('approvals'))
      _buildMenuCard(
        context: context,
        title: 'طلبات التقسيط',
        icon: Icons.account_balance_wallet,
        color: Colors.purple,
        onTap: () => context.go('/installment-requests'),
      ),
      
    // ... البطاقات الأخرى
  ],
)
```

---

## 🔄 البديل: إضافة في قائمة منفصلة

إذا كنت تريد قسم منفصل:

```dart
// في build method
Column(
  children: [
    // القسم الرئيسي
    _buildMainSection(),
    
    const SizedBox(height: 24),
    
    // قسم الموافقات والطلبات
    if (permissions.contains('all') ||
        permissions.contains('installments') ||
        permissions.contains('approvals'))
      _buildApprovalsSection(),
  ],
)

// الدالة الجديدة
Widget _buildApprovalsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'الموافقات والطلبات',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 16),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        childAspectRatio: 1.2,
        children: [
          _buildMenuCard(
            context: context,
            title: 'الموافقات',
            icon: Icons.check_circle,
            color: Colors.orange,
            onTap: () => context.go('/approvals'),
          ),
          _buildMenuCard(
            context: context,
            title: 'طلبات التقسيط',
            icon: Icons.account_balance_wallet,
            color: Colors.purple,
            onTap: () => context.go('/installment-requests'),
          ),
        ],
      ),
    ],
  );
}
```

---

## 🎯 الخيار الموصى به

**للبساطة والسرعة:**
استخدم الخيار الأول (إضافة بطاقة عادية)

**للتميز:**
استخدم الخيار الثاني (بطاقة مخصصة بـ gradient)

**للتنظيم:**
استخدم الخيار الثالث (قسم منفصل للموافقات والطلبات)

---

## ✅ التحقق

بعد الإضافة:
1. ✅ حفظ الملف
2. ✅ Hot reload (r)
3. ✅ تحقق من ظهور البطاقة
4. ✅ تحقق من الصلاحيات (تظهر للمالك والمدير فقط)
5. ✅ اضغط على البطاقة
6. ✅ تحقق من فتح صفحة طلبات التقسيط

---

## 🐛 استكشاف الأخطاء

### البطاقة لا تظهر
- تحقق من الصلاحيات في `permissions`
- تأكد من شرط `if` صحيح
- تحقق من أن الكود داخل `children` list

### الضغط لا يعمل
- تحقق من `onTap: () => context.go('/installment-requests')`
- تأكد من استيراد `go_router`
- تحقق من تعريف الـ route في `app_router.dart`

### الأيقونة لا تظهر
- تحقق من `import 'package:flutter/material.dart'`
- جرب أيقونة أخرى
- تأكد من `icon:` parameter موجود

---

## 📸 الشكل النهائي المتوقع

```
┌─────────────┬─────────────┐
│   مبيعات    │  الموافقات   │
│    الذهب    │             │
└─────────────┴─────────────┘
┌─────────────┬─────────────┐
│   طلبات     │   إدارة     │  ← NEW!
│  التقسيط    │  المخزون    │
└─────────────┴─────────────┘
```

---

**الوقت المتوقع:** 2-5 دقائق  
**الصعوبة:** ⭐ سهل  
**الحالة:** ✅ جاهز للتطبيق
