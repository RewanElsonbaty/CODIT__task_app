# نظام الفلترة المتقدم لإضافة قطع الذهب

## 📋 نظرة عامة

نظام فلترة تدريجي متقدم يسهل على المستخدم العثور على القطعة المناسبة من خلال 4 مراحل متتالية.

## 🎯 المراحل الأربع

### المرحلة 1️⃣: اختيار الفئة (Category Selection)

**طريقة البحث:**
- البحث بأول حرف (عربي أو إنجليزي)
- أمثلة:
  - `r` أو `R` أو `ر` → خواتم (Rings)
  - `c` أو `C` أو `س` → سلاسل (Chains)
  - `b` أو `B` أو `ا` → أساور (Bracelets)
  - `e` أو `E` أو `ق` → أقراط (Earrings)

**الفئات المتاحة:**
1. خواتم (Rings) - 💍
2. سلاسل (Chains/Necklaces) - 📿
3. أساور (Bracelets) - 🔗
4. أقراط (Earrings) - 👂
5. دبل (Wedding Bands) - 💑
6. طقم (Sets) - 📦
7. توك (Brooches) - 📌
8. غوايش (Anklets) - 🦶

### المرحلة 2️⃣: اختيار النوع (Type Selection)

بعد اختيار الفئة، يتم عرض الأنواع المتاحة:

**الأنواع:**
- 🟡 ذهب (Gold) - يحتاج عيار
- ⚪ فضة (Silver) - بدون عيار
- 💎 لازوردي (Lazurde) - يحتاج عيار

### المرحلة 3️⃣: تحديد المواصفات (Filter Selection)

**فلاتر متاحة:**

1. **العيار** (للذهب واللازوردي فقط):
   - الكل
   - 18 قيراط
   - 21 قيراط
   - 24 قيراط

2. **نطاق الوزن** (بالجرام):
   - Slider لتحديد الحد الأدنى والأقصى
   - من 0 إلى 100 جرام

**مثال:**
- الفئة: خواتم
- النوع: ذهب
- العيار: 21 قيراط
- الوزن: 3-6 جرام
- **النتيجة:** يظهر فقط الخواتم الذهب عيار 21 بوزن بين 3-6 جرام

### المرحلة 4️⃣: اختيار القطعة (Product Selection)

عرض القطع المطابقة للفلتر في شكل Grid:

**معلومات كل قطعة:**
- الاسم
- الكود
- الوزن الصافي
- العيار
- الفئة

**اختيار القطعة:**
- اضغط على القطعة لاختيارها
- حدد الكمية
- اضغط "تأكيد الإضافة"

## 🔧 الملفات الرئيسية

### 1. `product_categories.dart`
```dart
// نظام التصنيف مع دعم البحث بالعربي والإنجليزي
class ProductCategory {
  final String nameAr;
  final String nameEn;
  final List<String> searchTermsAr;
  final List<String> searchTermsEn;
  // ...
}
```

### 2. `progressive_add_gold_dialog.dart`
```dart
// Dialog متعدد المراحل
class ProgressiveAddGoldDialog extends StatefulWidget {
  final List<GoldProduct> availableProducts;
  final Function(GoldProduct, int) onAddItem;
  // ...
}
```

## 🎨 واجهة المستخدم

### التصميم
- **الألوان:** ذهبي نيون (AppColors.goldenNeon)
- **الأيقونات:** Emoji للفئات، Material Icons للتفاعل
- **الانتقالات:** سلسة بين المراحل مع Progress Indicator
- **Responsive:** يتكيف مع Mobile وTablet وDesktop

### التفاعل
- **Back Button:** للرجوع للمرحلة السابقة
- **Progress Bar:** 4 segments توضح المرحلة الحالية
- **Selected State:** تمييز واضح للعناصر المختارة

## 📊 مثال استخدام

```dart
showDialog(
  context: context,
  builder: (context) => ProgressiveAddGoldDialog(
    availableProducts: products,
    onAddItem: (product, quantity) {
      // إضافة القطعة للفاتورة
      cubit.addProduct(
        product: product,
        pricePerGramPiastres: 350000, // 3500 جنيه
        makingChargeType: MakingChargeType.perGram,
        makingChargePerGramPiastres: 5000, // 50 جنيه
      );
    },
  ),
);
```

## ✨ الميزات

✅ **بحث ذكي:** بأول حرف عربي أو إنجليزي  
✅ **فلترة تدريجية:** تضييق النتائج خطوة بخطوة  
✅ **واجهة سهلة:** تصميم بديهي وواضح  
✅ **Responsive:** يعمل على جميع الأحجام  
✅ **متعدد اللغات:** عربي وإنجليزي  
✅ **قابل للتوسع:** سهل إضافة فئات وأنواع جديدة  

## 🔄 إضافة فئات جديدة

```dart
// في product_categories.dart
ProductCategory(
  id: 'new_category',
  nameAr: 'الفئة الجديدة',
  nameEn: 'New Category',
  searchTermsAr: ['فئة', 'جديدة', 'ف'],
  searchTermsEn: ['new', 'category', 'n'],
  icon: '🆕',
  types: [
    ProductType(id: 'gold', nameAr: 'ذهب', nameEn: 'Gold', icon: '🟡'),
    // ...
  ],
),
```

## 🧪 اختبار

```bash
# تشغيل التطبيق
flutter run

# الخطوات:
1. افتح صفحة "بيع الذهب"
2. اضغط "اختيار من القطع المتاحة"
3. جرب البحث بحرف واحد:
   - اكتب 'r' → يظهر خواتم
   - اكتب 'ر' → يظهر خواتم
   - اكتب 'c' → يظهر سلاسل
   - اكتب 'س' → يظهر سلاسل
4. اختر فئة → اختر نوع → حدد فلتر → اختر قطعة
```

## 📝 ملاحظات

- البيانات التجريبية موجودة في `mock_gold_sales_api.dart`
- يمكن تعديل الأيقونات والألوان من `AppColors`
- الفلترة تعمل فقط على المنتجات المتاحة (`status.canSell`)
- يمكن إضافة المزيد من الفلاتر (مثل: السعر، المصنعية، إلخ)

## 🚀 التحسينات المستقبلية

- [ ] إضافة فلتر السعر
- [ ] إضافة فلتر الماركة
- [ ] حفظ الفلاتر المفضلة
- [ ] ترتيب النتائج (حسب السعر، الوزن، إلخ)
- [ ] عرض صور المنتجات
- [ ] مقارنة بين المنتجات
- [ ] إضافة إلى المفضلة

---

**تم التطوير:** ديسمبر 2024  
**الإصدار:** 1.0.0
