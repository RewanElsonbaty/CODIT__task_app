import 'mock_api_client.dart';
import '../../features/gold_sales/domain/gold_models.dart';

/// Mock Gold Sales API
/// يحاكي عمليات البيع والمخزون والمنتجات
class MockGoldSalesApi {
  final MockApiClient _client = MockApiClient();

  // Mock Products Database
  final List<GoldProduct> _products = [];

  // Mock Invoices Database
  final List<Map<String, dynamic>> _invoices = [];

  MockGoldSalesApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    // منتجات تجريبية متنوعة
    _products.addAll([
      // خواتم - عيار 21
      GoldProduct(
        code: 'RING-001',
        barcode: '1234567890123',
        name: 'خاتم ذهب عيار 21 - موديل كلاسيك',
        karat: Karat.k21,
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        status: ProductStatus.available,
        category: 'خواتم',
        makingChargePerGram: 50.0,
      ),
      GoldProduct(
        code: 'RING-002',
        barcode: '1234567890124',
        name: 'خاتم ذهب عيار 21 - موديل إيطالي',
        karat: Karat.k21,
        grossWeightMg: 5200,
        stonesWeightMg: 400,
        status: ProductStatus.available,
        category: 'خواتم',
        makingChargePerGram: 55.0,
      ),
      GoldProduct(
        code: 'RING-003',
        barcode: '1234567890125',
        name: 'دبلة زفاف ذهب عيار 21',
        karat: Karat.k21,
        grossWeightMg: 6000,
        stonesWeightMg: 200,
        status: ProductStatus.available,
        category: 'خواتم',
        makingChargePerGram: 60.0,
      ),

      // خواتم - عيار 18
      GoldProduct(
        code: 'RING-004',
        barcode: '1234567890126',
        name: 'خاتم ذهب عيار 18 - موديل فرنسي',
        karat: Karat.k18,
        grossWeightMg: 3500,
        stonesWeightMg: 500,
        status: ProductStatus.available,
        category: 'خواتم',
        makingChargePerGram: 65.0,
      ),
      GoldProduct(
        code: 'RING-005',
        barcode: '1234567890127',
        name: 'خاتم ذهب عيار 18 - مرصع فصوص',
        karat: Karat.k18,
        grossWeightMg: 4000,
        stonesWeightMg: 800,
        status: ProductStatus.available,
        category: 'خواتم',
        makingChargePerGram: 70.0,
      ),

      // سلاسل - عيار 21
      GoldProduct(
        code: 'CHAIN-001',
        barcode: '1234567890128',
        name: 'سلسلة ذهب عيار 21 - 50 سم',
        karat: Karat.k21,
        grossWeightMg: 12000,
        stonesWeightMg: 0,
        status: ProductStatus.available,
        category: 'سلاسل',
        makingChargePerGram: 40.0,
      ),
      GoldProduct(
        code: 'CHAIN-002',
        barcode: '1234567890129',
        name: 'سلسلة ذهب عيار 21 - 60 سم',
        karat: Karat.k21,
        grossWeightMg: 15000,
        stonesWeightMg: 0,
        status: ProductStatus.available,
        category: 'سلاسل',
        makingChargePerGram: 42.0,
      ),
      GoldProduct(
        code: 'CHAIN-003',
        barcode: '1234567890130',
        name: 'سلسلة ذهب عيار 21 - موديل إيطالي',
        karat: Karat.k21,
        grossWeightMg: 18000,
        stonesWeightMg: 0,
        status: ProductStatus.available,
        category: 'سلاسل',
        makingChargePerGram: 45.0,
      ),

      // سلاسل - عيار 24
      GoldProduct(
        code: 'CHAIN-004',
        barcode: '1234567890131',
        name: 'سلسلة ذهب عيار 24 - كلاسيك',
        karat: Karat.k24,
        grossWeightMg: 10000,
        stonesWeightMg: 0,
        status: ProductStatus.available,
        category: 'سلاسل',
        makingChargePerGram: 35.0,
      ),

      // أساور - عيار 21
      GoldProduct(
        code: 'BRAC-001',
        barcode: '1234567890132',
        name: 'أسورة ذهب عيار 21 - موديل إيطالي',
        karat: Karat.k21,
        grossWeightMg: 18000,
        stonesWeightMg: 500,
        status: ProductStatus.available,
        category: 'أساور',
        makingChargePerGram: 48.0,
      ),
      GoldProduct(
        code: 'BRAC-002',
        barcode: '1234567890133',
        name: 'أسورة ذهب عيار 21 - عريض',
        karat: Karat.k21,
        grossWeightMg: 22000,
        stonesWeightMg: 0,
        status: ProductStatus.available,
        category: 'أساور',
        makingChargePerGram: 45.0,
      ),
      GoldProduct(
        code: 'BRAC-003',
        barcode: '1234567890134',
        name: 'أسورة ذهب عيار 21 - موديل هندي',
        karat: Karat.k21,
        grossWeightMg: 25000,
        stonesWeightMg: 1000,
        status: ProductStatus.available,
        category: 'أساور',
        makingChargePerGram: 52.0,
      ),

      // أساور - عيار 18
      GoldProduct(
        code: 'BRAC-004',
        barcode: '1234567890135',
        name: 'أسورة ذهب عيار 18 - بفصوص',
        karat: Karat.k18,
        grossWeightMg: 15000,
        stonesWeightMg: 1500,
        status: ProductStatus.available,
        category: 'أساور',
        makingChargePerGram: 60.0,
      ),

      // أقراط/حلق - عيار 21
      GoldProduct(
        code: 'EARR-001',
        barcode: '1234567890136',
        name: 'أقراط ذهب عيار 21 - كلاسيك',
        karat: Karat.k21,
        grossWeightMg: 5000,
        stonesWeightMg: 300,
        status: ProductStatus.available,
        category: 'حلق',
        makingChargePerGram: 55.0,
      ),
      GoldProduct(
        code: 'EARR-002',
        barcode: '1234567890137',
        name: 'حلق ذهب عيار 21 - موديل دائري',
        karat: Karat.k21,
        grossWeightMg: 7000,
        stonesWeightMg: 500,
        status: ProductStatus.available,
        category: 'حلق',
        makingChargePerGram: 58.0,
      ),

      // أقراط/حلق - عيار 18
      GoldProduct(
        code: 'EARR-003',
        barcode: '1234567890138',
        name: 'أقراط ذهب عيار 18 - مرصع ألماس',
        karat: Karat.k18,
        grossWeightMg: 6000,
        stonesWeightMg: 1000,
        status: ProductStatus.available,
        category: 'حلق',
        makingChargePerGram: 70.0,
      ),
      GoldProduct(
        code: 'EARR-004',
        barcode: '1234567890139',
        name: 'حلق ذهب عيار 18 - موديل فرنسي',
        karat: Karat.k18,
        grossWeightMg: 4500,
        stonesWeightMg: 800,
        status: ProductStatus.available,
        category: 'حلق',
        makingChargePerGram: 68.0,
      ),

      // قلادات - عيار 21
      GoldProduct(
        code: 'PEND-001',
        barcode: '1234567890140',
        name: 'قلادة ذهب عيار 21 - كلاسيك',
        karat: Karat.k21,
        grossWeightMg: 8000,
        stonesWeightMg: 500,
        status: ProductStatus.available,
        category: 'قلادات',
        makingChargePerGram: 50.0,
      ),
      GoldProduct(
        code: 'PEND-002',
        barcode: '1234567890141',
        name: 'قلادة ذهب عيار 21 - موديل هندي',
        karat: Karat.k21,
        grossWeightMg: 10000,
        stonesWeightMg: 800,
        status: ProductStatus.available,
        category: 'قلادات',
        makingChargePerGram: 55.0,
      ),

      // قلادات - عيار 18
      GoldProduct(
        code: 'PEND-003',
        barcode: '1234567890142',
        name: 'قلادة ذهب عيار 18 - بحجر كريم',
        karat: Karat.k18,
        grossWeightMg: 12000,
        stonesWeightMg: 2000,
        status: ProductStatus.available,
        category: 'قلادات',
        makingChargePerGram: 65.0,
      ),

      // طقم كامل
      GoldProduct(
        code: 'SET-001',
        barcode: '1234567890143',
        name: 'طقم ذهب عيار 21 (سلسلة + حلق)',
        karat: Karat.k21,
        grossWeightMg: 20000,
        stonesWeightMg: 1000,
        status: ProductStatus.available,
        category: 'أطقم',
        makingChargePerGram: 60.0,
      ),
      GoldProduct(
        code: 'SET-002',
        barcode: '1234567890144',
        name: 'طقم ذهب عيار 18 (سلسلة + حلق + خاتم)',
        karat: Karat.k18,
        grossWeightMg: 25000,
        stonesWeightMg: 2000,
        status: ProductStatus.available,
        category: 'أطقم',
        makingChargePerGram: 70.0,
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
      final results = _products.where((p) => p.code == code);
      product = results.isNotEmpty ? results.first : null;
    } else if (barcode != null) {
      final results = _products.where((p) => p.barcode == barcode);
      product = results.isNotEmpty ? results.first : null;
    }

    if (product == null) {
      return {'success': false, 'error': 'المنتج غير موجود'};
    }

    return {'success': true, 'data': product.toJson()};
  }

  /// الحصول على جميع المنتجات
  Future<Map<String, dynamic>> getAllProducts({
    Karat? karat,
    int? limit,
  }) async {
    await _client.get(
      '/products',
      queryParams: {
        if (karat != null) 'karat': karat.name,
        if (limit != null) 'limit': limit.toString(),
      },
    );

    var filtered = _products;

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

    final results = _invoices.where((i) => i['id'] == invoiceId);
    final invoice = results.isNotEmpty ? results.first : null;

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
      final results = _products.where((p) => p.code == item.product.code);
      final product = results.isNotEmpty ? results.first : null;
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
