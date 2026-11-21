import 'dart:math';
import '../../../core/data/mock_api_client.dart';
import '../domain/gold_models.dart';

/// Mock Gold Sales API
/// يحاكي عمليات البيع والمخزون والمنتجات
class MockGoldSalesApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // Mock Products Database
  final List<GoldProduct> _products = [];

  // Mock Invoices Database
  final List<Map<String, dynamic>> _invoices = [];

  MockGoldSalesApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    // منتجات تجريبية
    _products.addAll([
      // خواتم
      GoldProduct(
        id: 'prod_001',
        code: 'RING-001',
        barcode: '1234567890123',
        name: 'خاتم ذهب عيار 21 - موديل كلاسيك',
        karat: GoldKarat.k21,
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        category: 'خواتم',
        pricePerGramPiastres: 420000, // 4200 جنيه
        makingChargePerGramPiastres: 12000, // 120 جنيه
        taxPercentage: 14,
      ),
      GoldProduct(
        id: 'prod_002',
        code: 'RING-002',
        barcode: '1234567890124',
        name: 'خاتم ذهب عيار 18 - موديل فرنسي',
        karat: GoldKarat.k18,
        grossWeightMg: 3500,
        stonesWeightMg: 200,
        category: 'خواتم',
        pricePerGramPiastres: 380000,
        makingChargePerGramPiastres: 15000,
        taxPercentage: 14,
      ),

      // سلاسل
      GoldProduct(
        id: 'prod_003',
        code: 'CHAIN-001',
        barcode: '1234567890125',
        name: 'سلسلة ذهب عيار 21 - 50 سم',
        karat: GoldKarat.k21,
        grossWeightMg: 12000,
        stonesWeightMg: 0,
        category: 'سلاسل',
        pricePerGramPiastres: 420000,
        makingChargePerGramPiastres: 8000,
        taxPercentage: 14,
      ),

      // أساور
      GoldProduct(
        id: 'prod_004',
        code: 'BRAC-001',
        barcode: '1234567890126',
        name: 'أسورة ذهب عيار 21 - موديل إيطالي',
        karat: GoldKarat.k21,
        grossWeightMg: 18000,
        stonesWeightMg: 500,
        category: 'أساور',
        pricePerGramPiastres: 420000,
        makingChargePerGramPiastres: 10000,
        taxPercentage: 14,
      ),

      // أقراط
      GoldProduct(
        id: 'prod_005',
        code: 'EARR-001',
        barcode: '1234567890127',
        name: 'أقراط ذهب عيار 18 - مرصع ألماس',
        karat: GoldKarat.k18,
        grossWeightMg: 6000,
        stonesWeightMg: 800,
        category: 'أقراط',
        pricePerGramPiastres: 380000,
        makingChargePerGramPiastres: 20000,
        taxPercentage: 14,
      ),
    ]);
  }

  /// البحث عن منتج بالكود أو الباركود
  Future<Map<String, dynamic>> searchProduct({
    String? code,
    String? barcode,
  }) async {
    await _client.get(
      '/products/search',
      queryParams: {
        if (code != null) 'code': code,
        if (barcode != null) 'barcode': barcode,
      },
    );

    GoldProduct? product;
    if (code != null) {
      product = _products.where((p) => p.code == code).firstOrNull;
    } else if (barcode != null) {
      product = _products.where((p) => p.barcode == barcode).firstOrNull;
    }

    if (product == null) {
      return {'success': false, 'error': 'المنتج غير موجود'};
    }

    return {'success': true, 'data': product.toJson()};
  }

  /// الحصول على جميع المنتجات
  Future<Map<String, dynamic>> getAllProducts({
    String? category,
    GoldKarat? karat,
    int? limit,
  }) async {
    await _client.get(
      '/products',
      queryParams: {
        if (category != null) 'category': category,
        if (karat != null) 'karat': karat.name,
        if (limit != null) 'limit': limit.toString(),
      },
    );

    var filtered = _products;

    if (category != null) {
      filtered = filtered.where((p) => p.category == category).toList();
    }

    if (karat != null) {
      filtered = filtered.where((p) => p.karat == karat).toList();
    }

    if (limit != null && limit < filtered.length) {
      filtered = filtered.sublist(0, limit);
    }

    return {
      'success': true,
      'data': {
        'products': filtered.map((p) => p.toJson()).toList(),
        'total': filtered.length,
      },
    };
  }

  /// حفظ فاتورة جديدة
  Future<Map<String, dynamic>> createInvoice(GoldInvoice invoice) async {
    await _client.post('/invoices', body: invoice.toJson(), canFail: true);

    // حفظ الفاتورة
    _invoices.add({
      ...invoice.toJson(),
      'created_at': DateTime.now().toIso8601String(),
    });

    return {
      'success': true,
      'data': {
        'invoice_id': invoice.id,
        'invoice_number': '#${invoice.id.substring(0, 8).toUpperCase()}',
        'grand_total': invoice.grandTotal,
      },
    };
  }

  /// الحصول على فاتورة معينة
  Future<Map<String, dynamic>> getInvoice(String invoiceId) async {
    await _client.get('/invoices/$invoiceId');

    final invoice = _invoices.where((i) => i['id'] == invoiceId).firstOrNull;

    if (invoice == null) {
      return {'success': false, 'error': 'الفاتورة غير موجودة'};
    }

    return {'success': true, 'data': invoice};
  }

  /// الحصول على فواتير اليوم
  Future<Map<String, dynamic>> getTodayInvoices() async {
    await _client.get('/invoices/today');

    final today = DateTime.now();
    final todayInvoices = _invoices.where((invoice) {
      final createdAt = DateTime.parse(invoice['created_at'] as String);
      return createdAt.year == today.year &&
          createdAt.month == today.month &&
          createdAt.day == today.day;
    }).toList();

    final totalSales = todayInvoices.fold<double>(
      0.0,
      (sum, invoice) => sum + (invoice['grand_total'] as double),
    );

    return {
      'success': true,
      'data': {
        'invoices': todayInvoices,
        'total_count': todayInvoices.length,
        'total_sales': totalSales,
      },
    };
  }

  /// حفظ فاتورة كمسودة
  Future<Map<String, dynamic>> saveDraft(GoldInvoice invoice) async {
    await _client.post('/invoices/draft', body: invoice.toJson());

    return {
      'success': true,
      'data': {'draft_id': invoice.id, 'message': 'تم حفظ المسودة بنجاح'},
    };
  }

  /// الحصول على المسودات
  Future<Map<String, dynamic>> getDrafts() async {
    await _client.get('/invoices/drafts');

    final drafts = _invoices.where((i) => i['status'] == 'draft').toList();

    return {
      'success': true,
      'data': {'drafts': drafts, 'total_count': drafts.length},
    };
  }

  /// التحقق من صحة الفاتورة
  Future<Map<String, dynamic>> validateInvoice(GoldInvoice invoice) async {
    await _client.post('/invoices/validate', body: invoice.toJson());

    final errors = <String>[];

    // التحقق من الأصناف
    if (invoice.lineItems.isEmpty) {
      errors.add('يجب إضافة صنف واحد على الأقل');
    }

    // التحقق من المبلغ المدفوع
    final paid = invoice.payments.fold<double>(0, (sum, p) => sum + p.amount);
    if (paid < invoice.grandTotal) {
      errors.add('المبلغ المدفوع أقل من الإجمالي');
    }

    // التحقق من توفر المنتجات
    for (final item in invoice.lineItems) {
      final product = _products
          .where((p) => p.id == item.product.id)
          .firstOrNull;
      if (product == null) {
        errors.add('المنتج ${item.product.name} غير متوفر');
      }
    }

    return {
      'success': errors.isEmpty,
      'data': {'valid': errors.isEmpty, 'errors': errors},
    };
  }

  /// الحصول على إحصائيات المبيعات
  Future<Map<String, dynamic>> getSalesStatistics({
    required DateTime from,
    required DateTime to,
  }) async {
    await _client.get(
      '/sales/statistics',
      queryParams: {'from': from.toIso8601String(), 'to': to.toIso8601String()},
    );

    final filtered = _invoices.where((invoice) {
      final createdAt = DateTime.parse(invoice['created_at'] as String);
      return createdAt.isAfter(from) && createdAt.isBefore(to);
    }).toList();

    final totalSales = filtered.fold<double>(
      0.0,
      (sum, invoice) => sum + (invoice['grand_total'] as double),
    );

    final totalItems = filtered.fold<int>(
      0,
      (sum, invoice) => sum + (invoice['line_items'] as List).length,
    );

    return {
      'success': true,
      'data': {
        'total_invoices': filtered.length,
        'total_sales': totalSales,
        'total_items': totalItems,
        'average_sale': filtered.isEmpty ? 0.0 : totalSales / filtered.length,
      },
    };
  }

  /// إضافة منتج جديد (للاختبار)
  void addProduct(GoldProduct product) {
    _products.add(product);
  }

  /// مسح البيانات (للاختبار)
  void clearData() {
    _products.clear();
    _invoices.clear();
    _initializeMockData();
  }
}

/// Extension لدعم firstOrNull
extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
