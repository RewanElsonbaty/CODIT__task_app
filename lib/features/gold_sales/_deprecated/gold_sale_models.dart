import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

/// Product item status in inventory
enum ProductStatus {
  available,
  sold,
  reserved,
  workshop,
  transit,
}

/// Gold product item with inventory tracking
class GoldProduct extends Equatable {
  const GoldProduct({
    required this.code,
    required this.barcode,
    required this.grossMg,
    required this.stoneMg,
    required this.karat,
    required this.category,
    required this.status,
  });

  final String code;
  final String? barcode;
  final int grossMg;
  final int stoneMg;
  final int karat;
  final String category;
  final ProductStatus status;

  int get netMg => grossMg - stoneMg;

  @override
  List<Object?> get props => [code, barcode, grossMg, stoneMg, karat, category, status];
}

/// Payment method for invoice
enum PaymentMethod {
  cash,
  card,
  transfer,
  check,
}

/// Payment line in invoice
class PaymentLine extends Equatable {
  const PaymentLine({
    required this.method,
    required this.amountPiastres,
    this.exchangeWeightMg,
    this.exchangePricePerGramPiastres,
    this.reference,
  });

  final PaymentMethod method;
  final int amountPiastres;
  final int? exchangeWeightMg; // For exchange payment
  final int? exchangePricePerGramPiastres; // Buy price for exchange
  final String? reference; // Reference number or notes

  // UI convenience property
  double get amount => amountPiastres / 100.0;

  @override
  List<Object?> get props => [method, amountPiastres, exchangeWeightMg, exchangePricePerGramPiastres, reference];
}

/// Invoice line item
class InvoiceLineItem extends Equatable {
  const InvoiceLineItem({
    required this.productCode,
    required this.grossMg,
    required this.stoneMg,
    required this.karat,
    required this.pricePerGramPiastres,
    required this.workmanshipPerGramPiastres,
    required this.fixedWorkmanshipPiastres,
    required this.workmanshipPerGram,
    required this.discountPercent,
    required this.netMg,
    required this.goldValuePiastres,
    required this.workmanshipPiastres,
    required this.discountPiastres,
    required this.taxPiastres,
    required this.lineTotalPiastres,
  });

  final String productCode;
  final int grossMg;
  final int stoneMg;
  final int karat;
  final int pricePerGramPiastres;
  final int workmanshipPerGramPiastres;
  final int fixedWorkmanshipPiastres;
  final bool workmanshipPerGram;
  final Decimal discountPercent;

  // Calculated values
  final int netMg;
  final int goldValuePiastres;
  final int workmanshipPiastres;
  final int discountPiastres;
  final int taxPiastres;
  final int lineTotalPiastres;

  // UI convenience properties
  String get productName => productCode; // يمكن تحسينه لاحقاً
  double get weight => grossMg / 1000.0; // Convert mg to grams
  double get stonesWeight => stoneMg / 1000.0;
  double get goldPricePerGram => pricePerGramPiastres / 100.0;
  double get workmanship => workmanshipPerGram 
      ? (workmanshipPerGramPiastres / 100.0)
      : (fixedWorkmanshipPiastres / 100.0);
  double get totalPrice => lineTotalPiastres / 100.0;
  int get carat => karat; // Alias for UI convenience
  ProductStatus get status => ProductStatus.available; // Default - can be enhanced

  @override
  List<Object?> get props => [
        productCode,
        grossMg,
        stoneMg,
        karat,
        pricePerGramPiastres,
        workmanshipPerGramPiastres,
        fixedWorkmanshipPiastres,
        workmanshipPerGram,
        discountPercent,
        netMg,
        goldValuePiastres,
        workmanshipPiastres,
        discountPiastres,
        taxPiastres,
        lineTotalPiastres,
      ];
}

/// Complete gold sale invoice
class GoldSaleInvoice extends Equatable {
  const GoldSaleInvoice({
    required this.id,
    required this.lines,
    required this.payments,
    required this.subtotalPiastres,
    required this.totalDiscountPiastres,
    required this.totalTaxPiastres,
    required this.grandTotalPiastres,
    required this.sellerDiscountPercent,
    required this.createdAt,
    required this.lockedPrices,
  });

  final String id;
  final List<InvoiceLineItem> lines;
  final List<PaymentLine> payments;
  final int subtotalPiastres;
  final int totalDiscountPiastres;
  final int totalTaxPiastres;
  final int grandTotalPiastres;
  final Decimal sellerDiscountPercent;
  final DateTime createdAt;
  final bool lockedPrices; // If true, prices don't update

  int get totalPaidPiastres => payments.fold(0, (sum, p) => sum + p.amountPiastres);
  int get remainingPiastres => grandTotalPiastres - totalPaidPiastres;
  bool get isFullyPaid => remainingPiastres == 0;

  // UI convenience properties
  List<InvoiceLineItem> get lineItems => lines;
  double get subtotal => subtotalPiastres / 100.0;
  double get totalDiscount => totalDiscountPiastres / 100.0;
  double get netTotal => grandTotalPiastres / 100.0;
  double get totalPaid => totalPaidPiastres / 100.0;
  bool get needsApprovalForDiscount => sellerDiscountPercent > Decimal.parse('10.0');

  @override
  List<Object?> get props => [
        id,
        lines,
        payments,
        subtotalPiastres,
        totalDiscountPiastres,
        totalTaxPiastres,
        grandTotalPiastres,
        sellerDiscountPercent,
        createdAt,
        lockedPrices,
      ];

  GoldSaleInvoice copyWith({
    String? id,
    List<InvoiceLineItem>? lines,
    List<PaymentLine>? payments,
    int? subtotalPiastres,
    int? totalDiscountPiastres,
    int? totalTaxPiastres,
    int? grandTotalPiastres,
    Decimal? sellerDiscountPercent,
    DateTime? createdAt,
    bool? lockedPrices,
  }) {
    return GoldSaleInvoice(
      id: id ?? this.id,
      lines: lines ?? this.lines,
      payments: payments ?? this.payments,
      subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
      totalDiscountPiastres: totalDiscountPiastres ?? this.totalDiscountPiastres,
      totalTaxPiastres: totalTaxPiastres ?? this.totalTaxPiastres,
      grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
      sellerDiscountPercent: sellerDiscountPercent ?? this.sellerDiscountPercent,
      createdAt: createdAt ?? this.createdAt,
      lockedPrices: lockedPrices ?? this.lockedPrices,
    );
  }
}
