# 📥 تحميل خطوط Cairo

## ⚠️ مطلوب: حمّل الخطوط قبل تشغيل التطبيق

### الطريقة الأولى: Google Fonts (الأسهل) ✅

1. اذهب إلى: https://fonts.google.com/specimen/Cairo
2. اضغط "Download family"
3. فك ضغط الملف
4. انسخ هذه الملفات إلى مجلد `fonts/`:
   - Cairo-Regular.ttf
   - Cairo-Medium.ttf
   - Cairo-SemiBold.ttf
   - Cairo-Bold.ttf
   - Cairo-ExtraBold.ttf

### الطريقة الثانية: التحميل المباشر

استخدم الروابط التالية (من GitHub):
- [Cairo Variable Font](https://github.com/google/fonts/raw/main/ofl/cairo/Cairo%5Bwght%5D.ttf)

بعد التحميل:
1. استخرج الخطوط باستخدام أداة مثل FontForge أو استخدم Cairo الثابتة
2. ضعها في مجلد fonts/

### التحقق من التثبيت:

```bash
flutter pub get
flutter run
```

إذا ظهرت أخطاء تتعلق بالخطوط، تأكد من وجود الملفات في مجلد fonts/.
