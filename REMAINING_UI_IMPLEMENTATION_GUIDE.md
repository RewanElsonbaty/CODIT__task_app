# 📱 Remaining UI Implementation Guide

## ✅ ما تم تنفيذه

### Authentication UI ✓
- ✅ `login_screen.dart` - شاشة تسجيل الدخول كاملة
- ✅ `change_password_screen.dart` - شاشة تغيير كلمة المرور كاملة

### Approvals UI ✓ (جزئي)
- ✅ `approvals_list_screen.dart` - قائمة الطلبات مع Tabs

---

## 📋 المتبقي للتنفيذ

### 1. Approvals UI (المتبقي)

#### approval_details_screen.dart
```dart
// شاشة تفاصيل الطلب
// Features:
// - عرض كامل تفاصيل الطلب
// - Metadata الخاصة بالطلب
// - قائمة الموافقين ومتطلبات كل واحد
// - أزرار Approve/Reject/Cancel
// - Version number
// - Timeline للتحديثات

class ApprovalDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> request;
  // ...
}
```

#### create_approval_dialog.dart
```dart
// Dialog لإنشاء طلب موافقة جديد
// Features:
// - اختيار نوع الطلب (Discount/Return/Price Override)
// - إدخال البيانات حسب النوع
// - اختيار الأولوية
// - اختيار الموافقين
// - Validation

showDialog(
  context: context,
  builder: (_) => CreateApprovalDialog(),
);
```

---

### 2. Installments UI (كامل)

#### contracts_list_screen.dart
```dart
// شاشة قائمة العقود
// Features:
// - قائمة جميع العقود
// - Filter: Active/Completed/Overdue
// - Search بالعميل أو رقم العقد
// - عرض ملخص (Total debt, Overdue amount)
// - Navigation لصفحة التفاصيل

class ContractsListScreen extends StatefulWidget {
  // Tabs: Active, Completed, Overdue
  // List of contracts with:
  // - Contract number
  // - Customer name
  // - Remaining amount
  // - Next payment date
  // - Status badge
}
```

#### contract_details_screen.dart
```dart
// شاشة تفاصيل العقد
// Features:
// - معلومات العقد الكاملة
// - معلومات العميل
// - جدول الأقساط (Paid/Pending)
// - Timeline للدفعات
// - زر "تسجيل دفعة"
// - حساب Late fees إذا متأخر

class ContractDetailsScreen extends StatefulWidget {
  final String contractId;
  // Display:
  // - Contract info
  // - Customer info
  // - Payment schedule table
  // - Payment history timeline
  // - Button: Record Payment
}
```

#### record_payment_screen.dart
```dart
// شاشة تسجيل دفعة
// Features:
// - إدخال المبلغ
// - اختيار طريقة الدفع
// - ملاحظات
// - حساب تلقائي للمتبقي
// - Validation (لا يزيد عن المتبقي)

class RecordPaymentScreen extends StatefulWidget {
  final String contractId;
  final double remainingAmount;
  // Form:
  // - Amount field (with max = remaining)
  // - Payment method dropdown
  // - Notes (optional)
  // - Submit button
}
```

#### customer_search_screen.dart
```dart
// شاشة البحث عن عميل
// Features:
// - Search bar (name/phone/national_id)
// - قائمة النتائج
// - عرض معلومات العميل
// - عرض العقود النشطة
// - زر "إنشاء عقد جديد"

class CustomerSearchScreen extends StatefulWidget {
  // Search by:
  // - Name
  // - Phone
  // - National ID
  // Display:
  // - Customer list
  // - Credit score
  // - Total debt
  // - Overdue debt
}
```

#### create_customer_screen.dart
```dart
// شاشة إنشاء عميل جديد
// Features:
// - Name, Phone, National ID, Address
// - Validation (National ID unique)
// - Auto credit score = 750

class CreateCustomerScreen extends StatefulWidget {
  // Form:
  // - Name (required)
  // - Phone (required, format)
  // - National ID (required, 14 digits, unique)
  // - Address (required)
  // - Submit button
}
```

#### create_contract_screen.dart
```dart
// شاشة إنشاء عقد أقساط جديد
// Features:
// - اختيار فاتورة
// - إدخال المقدم
// - اختيار عدد الأقساط
// - حساب تلقائي للقسط الشهري
// - Late fee percentage

class CreateContractScreen extends StatefulWidget {
  final String customerId;
  // Form:
  // - Invoice selection
  // - Down payment amount
  // - Installments count (dropdown)
  // - Late fee % (default 5%)
  // - Auto-calculate monthly installment
  // - Submit button
}
```

---

### 3. Branch Monitoring UI (كامل)

#### monitoring_dashboard_screen.dart
```dart
// شاشة Dashboard الرئيسية
// Features:
// - Branch selector (dropdown)
// - Live metrics cards
// - Charts (Sales, Inventory)
// - Alerts panel
// - Refresh button (real-time)

class MonitoringDashboardScreen extends StatefulWidget {
  // Top:
  // - Branch selector
  // - Date range picker
  // 
  // Metrics Cards (Grid):
  // - Today Sales Total
  // - Today Sales Count
  // - Active Users
  // - Inventory Value
  // - Pending Approvals
  // - Overdue Installments
  //
  // Charts:
  // - Line chart: Sales over time
  // - Bar chart: Inventory by category
  //
  // Alerts Panel:
  // - List of active alerts
  // - Severity badges
}
```

#### branch_comparison_screen.dart
```dart
// شاشة مقارنة الفروع
// Features:
// - Multi-select branches
// - Date range selector
// - Comparison table
// - Charts (side-by-side bars)

class BranchComparisonScreen extends StatefulWidget {
  // Date range picker
  // Branch multi-select
  // 
  // Table:
  // | Branch | Sales | Transactions | Avg | Inventory |
  // |--------|-------|--------------|-----|-----------|
  // | Cairo  | 500K  | 120          | 4.2K| 2M        |
  // | Giza   | 300K  | 80           | 3.8K| 1.5M      |
  //
  // Chart:
  // - Grouped bar chart comparing metrics
}
```

#### inventory_tracking_screen.dart
```dart
// شاشة تتبع المخزون
// Features:
// - Branch selector
// - Inventory by category table
// - Inventory by karat table
// - Total value
// - Low stock alerts

class InventoryTrackingScreen extends StatefulWidget {
  // Branch selector
  // 
  // Table 1: By Category
  // | Category | Items | Weight | Value |
  // |----------|-------|--------|-------|
  // | Rings    | 45    | 500g   | 2.1M  |
  // | Chains   | 30    | 800g   | 3.4M  |
  //
  // Table 2: By Karat
  // | Karat | Items | Weight | Value |
  // |-------|-------|--------|-------|
  // | 21K   | 80    | 1.2kg  | 5M    |
  // | 18K   | 60    | 800g   | 3M    |
}
```

#### alerts_panel_screen.dart
```dart
// شاشة التنبيهات
// Features:
// - قائمة جميع التنبيهات
// - Filter by severity (High/Medium/Low)
// - Filter by type
// - Acknowledge button
// - Details for each alert

class AlertsPanelScreen extends StatefulWidget {
  // Filters:
  // - Severity (All/High/Medium/Low)
  // - Type (All/Low Inventory/Overdue/System)
  // - Status (All/Unread/Read)
  //
  // List:
  // - Alert cards with:
  //   - Severity badge
  //   - Title
  //   - Message
  //   - Branch
  //   - Timestamp
  //   - Acknowledge button
}
```

#### active_users_screen.dart
```dart
// شاشة المستخدمين النشطين
// Features:
// - Branch selector
// - قائمة المستخدمين النشطين
// - Last activity time
// - Transactions count
// - Login time

class ActiveUsersScreen extends StatefulWidget {
  // Branch selector
  // 
  // List:
  // - User cards with:
  //   - Name
  //   - Role badge
  //   - Logged in time
  //   - Last activity
  //   - Transactions count today
  //   - Status indicator (Active/Idle)
}
```

---

## 🔧 Backend Integration

### 1. HTTP Client Setup

#### lib/core/network/api_client.dart
```dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;
  
  ApiClient({required this.baseUrl}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(_LoggingInterceptor());
    _dio.interceptors.add(_ErrorInterceptor());
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
  
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
```

### 2. Auth Interceptor

```dart
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token from storage
    final token = _getStoredToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### 3. Error Handling

```dart
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired, refresh it
      _refreshToken();
    }
    handler.next(err);
  }
}
```

---

## 💾 Local Storage (Hive)

### 1. Setup Hive

```dart
// lib/core/storage/local_storage.dart
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static late Box _userBox;
  static late Box _cacheBox;
  static late Box _syncQueueBox;
  
  static Future<void> init() async {
    await Hive.initFlutter();
    
    _userBox = await Hive.openBox('user');
    _cacheBox = await Hive.openBox('cache');
    _syncQueueBox = await Hive.openBox('sync_queue');
  }
  
  // User data
  static String? getToken() => _userBox.get('token');
  static Future<void> setToken(String token) => _userBox.put('token', token);
  
  // Cache
  static dynamic getCache(String key) => _cacheBox.get(key);
  static Future<void> setCache(String key, dynamic value) =>
      _cacheBox.put(key, value);
  
  // Sync queue
  static List<Map<String, dynamic>> getSyncQueue() {
    return List<Map<String, dynamic>>.from(_syncQueueBox.values);
  }
  
  static Future<void> addToSyncQueue(Map<String, dynamic> operation) {
    return _syncQueueBox.add(operation);
  }
}
```

### 2. Offline Mode

```dart
// lib/core/network/offline_manager.dart
class OfflineManager {
  final ApiClient _apiClient;
  final LocalStorage _storage;
  
  Future<dynamic> executeWithOfflineSupport({
    required Future<dynamic> Function() onlineOperation,
    required String cacheKey,
    Duration cacheDuration = const Duration(hours: 1),
  }) async {
    try {
      // Try online first
      final result = await onlineOperation();
      
      // Cache the result
      await _storage.setCache(cacheKey, {
        'data': result,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      return result;
    } catch (e) {
      // If offline, return cached data
      final cached = _storage.getCache(cacheKey);
      
      if (cached != null) {
        final timestamp = DateTime.parse(cached['timestamp']);
        if (DateTime.now().difference(timestamp) < cacheDuration) {
          return cached['data'];
        }
      }
      
      rethrow;
    }
  }
  
  Future<void> syncPendingOperations() async {
    final queue = _storage.getSyncQueue();
    
    for (final operation in queue) {
      try {
        await _executeOperation(operation);
        await _storage.removeSyncItem(operation['id']);
      } catch (e) {
        // Keep in queue for later
      }
    }
  }
}
```

---

## 🚀 Advanced Features

### 1. Barcode Scanner

```yaml
# pubspec.yaml
dependencies:
  mobile_scanner: ^3.5.0
```

```dart
// lib/features/gold_sales/presentation/barcode_scanner_screen.dart
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مسح الباركود')),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              Navigator.pop(context, barcode.rawValue);
            }
          }
        },
      ),
    );
  }
}
```

### 2. Receipt Printing (PDF)

```yaml
dependencies:
  pdf: ^3.10.0
  printing: ^5.11.0
```

```dart
// lib/features/gold_sales/utils/receipt_generator.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptGenerator {
  static Future<void> printInvoice(GoldInvoice invoice) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text('CODIT Gold', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              
              // Invoice number
              pw.Text('Invoice #${invoice.id}'),
              pw.Text('Date: ${invoice.createdAt}'),
              
              pw.SizedBox(height: 20),
              
              // Line items table
              pw.Table.fromTextArray(
                headers: ['Item', 'Weight', 'Price', 'Total'],
                data: invoice.lineItems.map((item) => [
                  item.product.name,
                  '${item.product.netWeightGrams}g',
                  '${item.pricePerGram} EGP',
                  '${item.total} EGP',
                ]).toList(),
              ),
              
              pw.SizedBox(height: 20),
              
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Grand Total:', style: pw.TextStyle(fontSize: 18)),
                  pw.Text('${invoice.grandTotal} EGP',
                      style: pw.TextStyle(fontSize: 18)),
                ],
              ),
            ],
          );
        },
      ),
    );
    
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
```

### 3. Multi-language Support

```dart
// lib/core/localization/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'password': 'Password',
      'gold_pos': 'Gold POS',
      // ... more translations
    },
    'ar': {
      'login': 'تسجيل الدخول',
      'password': 'كلمة المرور',
      'gold_pos': 'نقاط البيع',
      // ... more translations
    },
  };
  
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}
```

### 4. Dark/Light Theme Toggle

```dart
// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  
  ThemeMode get themeMode => _themeMode;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }
}

// In main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: LuxuryTheme.lightTheme,  // Add light theme
            darkTheme: LuxuryTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            // ...
          );
        },
      ),
    );
  }
}
```

### 5. Export Reports (Excel)

```yaml
dependencies:
  excel: ^2.1.0
```

```dart
// lib/core/utils/report_generator.dart
import 'package:excel/excel.dart';
import 'dart:io';

class ReportGenerator {
  static Future<File> generateSalesReport({
    required DateTime from,
    required DateTime to,
    required List<GoldInvoice> invoices,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sales Report'];
    
    // Headers
    sheet.appendRow([
      'Invoice #',
      'Date',
      'Items Count',
      'Subtotal',
      'Trade-in',
      'Grand Total',
    ]);
    
    // Data
    for (final invoice in invoices) {
      sheet.appendRow([
        invoice.id,
        invoice.createdAt.toString(),
        invoice.lineItems.length,
        invoice.subtotal,
        invoice.tradeInValue,
        invoice.grandTotal,
      ]);
    }
    
    // Save
    final bytes = excel.encode();
    final file = File('/path/to/sales_report.xlsx');
    await file.writeAsBytes(bytes!);
    
    return file;
  }
}
```

---

## 📦 Required Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  
  # Network
  dio: ^5.4.0
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # UI
  intl: ^0.18.1
  
  # Charts
  fl_chart: ^0.66.0
  
  # Barcode Scanner
  mobile_scanner: ^3.5.0
  
  # PDF & Printing
  pdf: ^3.10.0
  printing: ^5.11.0
  
  # Excel
  excel: ^2.1.0
  
  # Utils
  path_provider: ^2.1.1
  share_plus: ^7.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
```

---

## ⏱️ Estimated Time per Screen

| Screen | Complexity | Time |
|--------|-----------|------|
| Approval Details | Medium | 2h |
| Create Approval Dialog | Medium | 1.5h |
| Contracts List | Medium | 2h |
| Contract Details | High | 3h |
| Record Payment | Simple | 1h |
| Customer Search | Medium | 2h |
| Create Customer | Simple | 1h |
| Create Contract | Medium | 2h |
| Monitoring Dashboard | High | 4h |
| Branch Comparison | Medium | 2h |
| Inventory Tracking | Medium | 2h |
| Alerts Panel | Medium | 1.5h |
| Active Users | Simple | 1h |

**Total Estimated Time: 25 hours**

---

## 🎯 Priority Implementation Order

### Phase 1 (High Priority - 8 hours)
1. Approval Details Screen
2. Contract Details Screen
3. Record Payment Screen
4. Monitoring Dashboard (basic)

### Phase 2 (Medium Priority - 10 hours)
5. Contracts List Screen
6. Customer Search/Create
7. Create Contract Screen
8. Approval Create Dialog

### Phase 3 (Nice to Have - 7 hours)
9. Branch Comparison
10. Inventory Tracking
11. Alerts Panel
12. Active Users

---

## ✅ Implementation Checklist

### For Each Screen:
- [ ] Create screen file
- [ ] Implement UI (mobile responsive)
- [ ] Implement UI (tablet responsive)
- [ ] Connect to Mock API
- [ ] Add loading states
- [ ] Add error handling
- [ ] Add validation (if form)
- [ ] Add navigation
- [ ] Test on mobile
- [ ] Test on tablet
- [ ] Format code
- [ ] Add to routing

---

**Status**: Guide Complete ✅  
**Next Step**: Start implementing screens one by one from Phase 1
