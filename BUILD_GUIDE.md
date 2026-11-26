# 📱 Build Guide - CODIT System

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Localizations
```bash
flutter gen-l10n
```

### 3. Run Development
```bash
flutter run
```

---

## 📦 Build for Production

### Option 1: Standard Build (Recommended)
```bash
flutter build apk --release
```

### Option 2: Skip Gradle Validation (If needed)
```bash
flutter build apk --release --android-skip-build-dependency-validation
```

### Option 3: Build AAB (For Google Play)
```bash
flutter build appbundle --release
```

---

## 🛠️ Build Configuration

### Gradle Version: 9.5.0
**File:** `android/gradle/wrapper/gradle-wrapper.properties`
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-9.5.0-bin.zip
```

### Android Gradle Plugin: 9.3.1
**File:** `android/settings.gradle.kts`
```kotlin
plugins {
    id("com.android.application") version "9.3.1" apply false
}
```

### Kotlin Version: 2.2.10
**File:** `android/settings.gradle.kts`
```kotlin
plugins {
    id("org.jetbrains.kotlin.android") version "2.2.10" apply false
}
```

---

## 🌍 Supported Languages

- ✅ **Arabic (ar)** - Default
- ✅ **English (en)**

**To add more languages:**
1. Create `lib/l10n/app_[locale].arb`
2. Add translations
3. Update `supportedLocales` in `main.dart`
4. Run `flutter gen-l10n`

---

## 📐 Responsive Design

**Supported Screen Sizes:**
- ✅ Mobile: < 600px
- ✅ Tablet: 600px - 900px
- ✅ Desktop: > 900px

**All widgets use `ResponsiveUtils` for automatic adaptation.**

---

## 🎨 Theme

**Theme:** Dark Theme (Luxury Design)
**Primary Color:** Golden Neon (#FFD700)
**Background:** Dark (#121212)

**To change theme:**
Edit `lib/core/theme/luxury_theme.dart`

---

## 🔐 Accounts for Testing

```
👤 owner / owner123          → All Permissions
👤 manager / manager123      → Approve/Reject + Manage
👤 cashier / cashier123      → Payments Only
👤 installments_manager / installments123 → Monitor Only
```

---

## 🐛 Troubleshooting

### Error: Gradle version not supported
**Solution:** Check `gradle-wrapper.properties` has version 9.5.0+

### Error: Android Gradle Plugin version not supported
**Solution:** Check `settings.gradle.kts` has AGP version 9.3.1+

### Error: Null safety issues
**Solution:** All fixed! Just run `flutter pub get` again

### Error: Localization files not found
**Solution:** Run `flutter gen-l10n`

---

## 📊 Build Output

**APK Location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**AAB Location:**
```
build/app/outputs/bundle/release/app-release.aab
```

---

## ✅ Pre-Build Checklist

- [x] Dependencies installed (`flutter pub get`)
- [x] Localizations generated (`flutter gen-l10n`)
- [x] No compilation errors (`flutter analyze`)
- [x] Gradle version 9.5.0+
- [x] AGP version 9.3.1+
- [x] Null safety enabled
- [x] All Mock APIs connected
- [x] Responsive design applied
- [x] Exception handling implemented

---

## 🎉 You're Ready to Build!

**Just run:**
```bash
flutter build apk --release
```

**Or:**
```bash
flutter build appbundle --release
```

---

**Built with ❤️ by Kiro AI Assistant**

