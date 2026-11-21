import 'dart:convert';

import 'package:codit/core/database/app_database.dart';
import 'package:codit/features/gold_sales/domain/gold_sale_models.dart';
import 'package:codit/features/gold_sales/domain/exceptions.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;

class GoldSaleRepository {
  GoldSaleRepository(
    this._dio,
    this._db, {
    required this.accountId,
  });

  final Dio _dio;
  final AppDatabase _db;
  String accountId;

  /// Fetch product by code or barcode
  Future<GoldProduct?> findProduct({String? code, String? barcode}) async {
    if (code == null && barcode == null) {
      throw ArgumentError('يجب تحديد الكود أو الباركود');
    }

    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/gold-products/search',
        queryParameters: {
          'code': code,
          'barcode': barcode,
        }..removeWhere((key, value) => value == null),
      );

      if (res.data == null) return null;
      
      final product = _productFromJson(res.data!);
      
      // التحقق من حالة القطعة
      _validateProductAvailability(product);
      
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Validate that product is available for sale
  void _validateProductAvailability(GoldProduct product) {
    switch (product.status) {
      case ProductStatus.sold:
        throw ProductUnavailableException('القطعة مباعة بالفعل');
      case ProductStatus.reserved:
        throw ProductUnavailableException('القطعة محجوزة لعميل آخر');
      case ProductStatus.workshop:
        throw ProductUnavailableException('القطعة في الورشة للصيانة');
      case ProductStatus.transit:
        throw ProductUnavailableException('القطعة في الطريق بين الفروع');
      case ProductStatus.available:
        // OK للبيع
        return;
    }
  }

  /// Load draft invoice
  Future<GoldSaleInvoice?> loadDraft(String draftId) async {
    final row = await (_db.select(_db.goldDrafts)
          ..where((t) => t.id.equals(draftId) & t.accountId.equals(accountId)))
        .getSingleOrNull();

    if (row == null) return null;

    final json = jsonDecode(row.payloadJson) as Map<String, dynamic>;
    return _invoiceFromJson(json);
  }

  /// Save draft invoice
  Future<void> saveDraft(GoldSaleInvoice invoice) async {
    final json = _invoiceToJson(invoice);
    final payload = jsonEncode(json);

    await _db.into(_db.goldDrafts).insertOnConflictUpdate(
          GoldDraftsCompanion.insert(
            id: invoice.id,
            payloadJson: payload,
            updatedAt: DateTime.now().toUtc(),
            accountId: accountId,
          ),
        );
  }

  /// Delete draft
  Future<void> deleteDraft(String draftId) async {
    await (_db.delete(_db.goldDrafts)
          ..where((t) => t.id.equals(draftId) & t.accountId.equals(accountId)))
        .go();
  }

  /// Submit invoice for finalization (requires approval if needed)
  Future<Map<String, dynamic>> submitInvoice(GoldSaleInvoice invoice) async {
    final json = _invoiceToJson(invoice);

    final res = await _dio.post<Map<String, dynamic>>(
      '/gold-sales/invoices',
      data: json,
    );

    return res.data!;
  }

  GoldProduct _productFromJson(Map<String, dynamic> json) {
    return GoldProduct(
      code: json['code'] as String,
      barcode: json['barcode'] as String?,
      grossMg: json['gross_mg'] as int,
      stoneMg: json['stone_mg'] as int,
      karat: json['karat'] as int,
      category: json['category'] as String,
      status: ProductStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ProductStatus.available,
      ),
    );
  }

  GoldSaleInvoice _invoiceFromJson(Map<String, dynamic> json) {
    return GoldSaleInvoice(
      id: json['id'] as String,
      lines: (json['lines'] as List<dynamic>)
          .map((l) => _lineItemFromJson(l as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((p) => _paymentFromJson(p as Map<String, dynamic>))
          .toList(),
      subtotalPiastres: json['subtotal_piastres'] as int,
      totalDiscountPiastres: json['total_discount_piastres'] as int,
      totalTaxPiastres: json['total_tax_piastres'] as int,
      grandTotalPiastres: json['grand_total_piastres'] as int,
      sellerDiscountPercent: Decimal.parse(json['seller_discount_percent'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      lockedPrices: json['locked_prices'] as bool? ?? false,
    );
  }

  InvoiceLineItem _lineItemFromJson(Map<String, dynamic> json) {
    return InvoiceLineItem(
      productCode: json['product_code'] as String,
      grossMg: json['gross_mg'] as int,
      stoneMg: json['stone_mg'] as int,
      karat: json['karat'] as int,
      pricePerGramPiastres: json['price_per_gram_piastres'] as int,
      workmanshipPerGramPiastres: json['workmanship_per_gram_piastres'] as int,
      fixedWorkmanshipPiastres: json['fixed_workmanship_piastres'] as int,
      workmanshipPerGram: json['workmanship_per_gram'] as bool,
      discountPercent: Decimal.parse(json['discount_percent'] as String),
      netMg: json['net_mg'] as int,
      goldValuePiastres: json['gold_value_piastres'] as int,
      workmanshipPiastres: json['workmanship_piastres'] as int,
      discountPiastres: json['discount_piastres'] as int,
      taxPiastres: json['tax_piastres'] as int,
      lineTotalPiastres: json['line_total_piastres'] as int,
    );
  }

  PaymentLine _paymentFromJson(Map<String, dynamic> json) {
    return PaymentLine(
      method: PaymentMethod.values.firstWhere((m) => m.name == json['method']),
      amountPiastres: json['amount_piastres'] as int,
      exchangeWeightMg: json['exchange_weight_mg'] as int?,
      exchangePricePerGramPiastres: json['exchange_price_per_gram_piastres'] as int?,
    );
  }

  Map<String, dynamic> _invoiceToJson(GoldSaleInvoice invoice) {
    return {
      'id': invoice.id,
      'lines': invoice.lines.map(_lineItemToJson).toList(),
      'payments': invoice.payments.map(_paymentToJson).toList(),
      'subtotal_piastres': invoice.subtotalPiastres,
      'total_discount_piastres': invoice.totalDiscountPiastres,
      'total_tax_piastres': invoice.totalTaxPiastres,
      'grand_total_piastres': invoice.grandTotalPiastres,
      'seller_discount_percent': invoice.sellerDiscountPercent.toString(),
      'created_at': invoice.createdAt.toIso8601String(),
      'locked_prices': invoice.lockedPrices,
    };
  }

  Map<String, dynamic> _lineItemToJson(InvoiceLineItem line) {
    return {
      'product_code': line.productCode,
      'gross_mg': line.grossMg,
      'stone_mg': line.stoneMg,
      'karat': line.karat,
      'price_per_gram_piastres': line.pricePerGramPiastres,
      'workmanship_per_gram_piastres': line.workmanshipPerGramPiastres,
      'fixed_workmanship_piastres': line.fixedWorkmanshipPiastres,
      'workmanship_per_gram': line.workmanshipPerGram,
      'discount_percent': line.discountPercent.toString(),
      'net_mg': line.netMg,
      'gold_value_piastres': line.goldValuePiastres,
      'workmanship_piastres': line.workmanshipPiastres,
      'discount_piastres': line.discountPiastres,
      'tax_piastres': line.taxPiastres,
      'line_total_piastres': line.lineTotalPiastres,
    };
  }

  Map<String, dynamic> _paymentToJson(PaymentLine payment) {
    return {
      'method': payment.method.name,
      'amount_piastres': payment.amountPiastres,
      if (payment.exchangeWeightMg != null) 'exchange_weight_mg': payment.exchangeWeightMg,
      if (payment.exchangePricePerGramPiastres != null)
        'exchange_price_per_gram_piastres': payment.exchangePricePerGramPiastres,
    };
  }
}
