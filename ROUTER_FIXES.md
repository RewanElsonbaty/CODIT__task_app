# Router and Authentication Structure Fixes

## 🔧 Problems Fixed

### 1. Router Using Old Authentication Structure
**Problem**: `app_router.dart` was importing and using the old authentication classes:
- `AuthenticationCubit` (old) instead of `AuthCubit` (new)
- `AuthSession` and `AuthStep` (old) instead of `AuthState` classes (new)
- `LoginPage`, `OtpPage`, `DeviceVerifyPage` (old) instead of `LoginScreen`, `OtpScreen`, `DeviceVerificationScreen` (new)

**Fix Applied**:
```dart
// OLD IMPORTS ❌
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/authentication/domain/auth_session.dart';
import 'package:codit/features/authentication/presentation/login_page.dart';

// NEW IMPORTS ✅
import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/features/auth/presentation/screens/login_screen.dart';
import 'package:codit/features/auth/presentation/screens/otp_screen.dart';
import 'package:codit/features/auth/presentation/screens/device_verification_screen.dart';
```

### 2. Router Redirect Logic
**Old Logic** (using AuthSession):
```dart
if (!session.isAuthenticated) {
  if (session.step == AuthStep.otp && loc != '/otp') return '/otp';
  if (session.step == AuthStep.device && loc != '/device') return '/device';
}
```

**New Logic** (using AuthState):
```dart
if (authState is AuthOtpRequired && loc != '/otp') {
  return '/otp';
}

if (authState is AuthDeviceVerificationRequired && loc != '/device') {
  return '/device';
}

if (authState is! AuthAuthenticated && !isAuthRoute) {
  return '/login';
}
```

### 3. Route Builders with State Context
**Old** (direct instantiation without data):
```dart
GoRoute(path: '/otp', builder: (_, _) => const OtpPage()),
GoRoute(path: '/device', builder: (_, _) => const DeviceVerifyPage()),
```

**New** (with state data from AuthCubit):
```dart
GoRoute(
  path: '/otp',
  builder: (_, state) {
    final authState = authCubit.state;
    if (authState is AuthOtpRequired) {
      return OtpScreen(
        sessionId: authState.sessionId,
        phone: authState.phone,
      );
    }
    return const LoginScreen(); // Fallback
  },
),
GoRoute(
  path: '/device',
  builder: (_, state) {
    final authState = authCubit.state;
    if (authState is AuthDeviceVerificationRequired) {
      return DeviceVerificationScreen(
        verificationId: authState.deviceVerificationId,
      );
    }
    return const LoginScreen(); // Fallback
  },
),
```

---

## 🔧 Main.dart Fixes

### Problem: Using Old AuthenticationCubit
**Old**:
```dart
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';

final authCubit = getIt<AuthenticationCubit>();

authCubit.stream.listen((state) {
  if (state is AuthReady) { ... }
  else if (state is AuthInitial) { ... }
});
```

**New**:
```dart
import 'package:codit/features/auth/presentation/auth_cubit.dart';

final authCubit = getIt<AuthCubit>();

authCubit.stream.listen((state) {
  if (state is AuthAuthenticated) { ... }
  else if (state is AuthUnauthenticated) { ... }
});
```

---

## 🔧 Dependency Injection Fixes

### Problem: injection.dart Registering Old Authentication

**Old Structure** (`lib/core/di/injection.dart`):
```dart
import 'package:codit/features/authentication/data/auth_repository.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';

// Auth Repository (old structure)
getIt.registerSingleton<AuthRepository>(
  AuthRepository(
    getIt<ApiClient>().dio,
    getIt<SecureStorageService>(),
    getIt<SessionController>(),
  ),
);

// Auth Cubit (old)
authCubit = AuthenticationCubit(getIt<AuthRepository>());
getIt.registerSingleton<AuthenticationCubit>(authCubit);
```

**New Structure**:
```dart
import 'package:codit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:codit/features/auth/domain/repositories/auth_repository.dart';
import 'package:codit/features/auth/data/services/token_manager.dart';
import 'package:codit/features/auth/presentation/auth_cubit.dart';

// Token Manager (new)
getIt.registerSingleton<TokenManager>(
  TokenManager(getIt<SecureStorageService>()),
);

// Auth Repository (new structure with interface)
getIt.registerSingleton<AuthRepository>(
  AuthRepositoryImpl(
    getIt<SecureStorageService>(),
    getIt<TokenManager>(),
  ),
);

// Auth Cubit (new)
authCubit = AuthCubit(
  getIt<AuthRepository>(),
  getIt<TokenManager>(),
);
getIt.registerSingleton<AuthCubit>(authCubit);

// Initialize auth status
await authCubit.checkAuthStatus();
```

**Key Changes**:
1. Added `TokenManager` service for token operations
2. Using interface `AuthRepository` with implementation `AuthRepositoryImpl`
3. Removed dependency on `ApiClient` and `SessionController` (old structure)
4. Added `checkAuthStatus()` call on initialization

---

## 🔧 Deep Link Handler Fixes

### Problem: Using Old AuthenticationCubit

**File**: `lib/core/deep_linking/deep_link_handler.dart`

**Old**:
```dart
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';

final AuthenticationCubit _authCubit;

if (authState is! AuthReady) {
  // Not authenticated
}
```

**New**:
```dart
import 'package:codit/features/auth/presentation/auth_cubit.dart';

final AuthCubit _authCubit;

if (authState is! AuthAuthenticated) {
  // Not authenticated
}
```

---

## 🔧 Login Screen Platform Detection Fix

### Problem: Missing kIsWeb import for Web platform detection

**Added Import**:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;
```

**Updated Device Info Logic**:
```dart
Future<void> _initializeDeviceInfo() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    
    if (kIsWeb) {
      // Web platform (check first before Platform.is*)
      final webInfo = await deviceInfo.webBrowserInfo;
      setState(() {
        _deviceId = 'web_${webInfo.userAgent.hashCode}';
        _deviceName = '${webInfo.browserName} on ${webInfo.platform}';
      });
    } else if (Platform.isAndroid) {
      // Android logic
    } else if (Platform.isIOS) {
      // iOS logic
    }
    // ... other platforms
  } catch (e) {
    // Fallback
  }
}
```

**Why**: `kIsWeb` must be checked **before** `Platform.is*` because `Platform` throws on web. Checking `kIsWeb` first prevents the error.

---

## 📊 Files Modified

### Core Routing:
1. `lib/core/routing/app_router.dart`
   - Updated imports to new auth structure
   - Updated redirect logic to use `AuthState` classes
   - Updated route builders to pass state data
   - Fixed parameter naming (`_` → `__` for unused parameters)

### Main Entry:
2. `lib/main.dart`
   - Updated import to `AuthCubit`
   - Updated state checks (`AuthReady` → `AuthAuthenticated`)
   - Updated DI resolution (`getIt<AuthCubit>()`)

### Dependency Injection:
3. `lib/core/di/injection.dart`
   - Complete rewrite of auth dependencies
   - Added `TokenManager` registration
   - Updated `AuthRepository` to use interface + implementation
   - Updated `AuthCubit` registration
   - Added `checkAuthStatus()` initialization
   - Fixed callback: `handleRefreshFailed()` → `logout()`

### Deep Linking:
4. `lib/core/deep_linking/deep_link_handler.dart`
   - Updated import to `AuthCubit`
   - Updated state check: `AuthReady` → `AuthAuthenticated`

### Authentication Screens:
5. `lib/features/auth/presentation/screens/login_screen.dart`
   - Added `kIsWeb` import
   - Updated device info logic to check `kIsWeb` first

---

## ✅ Verification Checklist

### Router:
- [x] Uses `AuthCubit` instead of `AuthenticationCubit`
- [x] Redirect logic uses `AuthState` classes
- [x] OTP route receives `sessionId` and `phone`
- [x] Device verification route receives `verificationId`
- [x] Fallback to LoginScreen if accessed directly

### Main App:
- [x] Imports `AuthCubit`
- [x] Resolves `getIt<AuthCubit>()`
- [x] Listens to correct state types

### Dependency Injection:
- [x] Registers `TokenManager`
- [x] Registers `AuthRepository` interface
- [x] Registers `AuthRepositoryImpl` as implementation
- [x] Registers `AuthCubit` with correct parameters
- [x] Calls `checkAuthStatus()` on init

### Deep Linking:
- [x] Uses `AuthCubit`
- [x] Checks `AuthAuthenticated` state

### Platform Detection:
- [x] Checks `kIsWeb` before `Platform.is*`
- [x] Handles all 6 platforms correctly

---

## 🎯 Result

All errors related to old authentication structure have been fixed. The router now correctly uses the new Clean Architecture authentication system with:

✅ Proper state management via `AuthCubit`  
✅ State-driven navigation via `AuthState` classes  
✅ Data passing to screens via route builders  
✅ Fallback handling for direct route access  
✅ Correct dependency injection structure  
✅ Platform detection working on all 6 platforms  

The application should now compile and run without authentication-related errors!

---

**Date**: 2024-01-XX  
**Fixed By**: AI Assistant  
**Status**: ✅ All Router & Auth Errors Fixed
