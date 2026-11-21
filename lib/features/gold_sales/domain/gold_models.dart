import 'package:equatable/equatable.dart';

/// حالة القطعة في المخزون
enum ProductStatus {
  available,    // متاحة للبيع
  sold,         // مباعة
  reserved,     // محجوزة
  inWorkshop,   // في الورشة
  inTransit;    // في الطريق
  
  String get displayName {
    switch (this) {
      case ProductStatus.available:
        return 'متاحة';
      case ProductStatus.sold:
        return 'مباعة';
      case ProductStatus.reserved:
        return 'محجوزة';
      case ProductStatus.inWorkshop:
        return 'في الورشة';
      case ProductStatus.inTransit:
        return 'في الطريق';
    }
  }
  
  bool get canSell => this == ProductStatus.available;
}

/// نوع المصنعية
enum MakingChargeType {
  perGram,    // لكل جرام
  fixed;      // مبلغ ثابت
  
  String get displayName {
    switch (this) {
      case MakingChargeType.perGram:
        return 'لكل جرام';
      case MakingChargeType.fixed:
        return 'مبلغ ثابت';
    }
  }
}

/// طريقة الدفع
enum PaymentMethod {
  cash,
  card,
  transfer,
  check;
  
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'نقداً';
      case PaymentMethod.card:
        return 'بطاقة';
      case PaymentMethod.transfer:
        return 'تحويل بنكي';
      case PaymentMethod.check:
        return 'شيك';
    }
  }
}

/// العيار
enum Karat {
  k18,
  k21,
  k24;
  
  String get displayName {
    switch (this) {
      case Karat.k18:
        return '18 قيراط';
      case Karat.k21:
        return '21 قيراط';
      case Karat.k24:
        return '24 قيراط';
    }
  }
  
  int get value {
    switch (this) {
      case Karat.k18:
        return 18;
      case Karat.k21:
        return 21;
      case Karat.k24:
        return 24;
    }
  }
}

/// قطعة ذهب
class GoldProduct extends Equatable {
  final String code;
  final String name;
  final String barcode;
  final int grossWeightMg;        // الوزن القائم بالمليجرام
  final int stonesWeightMg;       // وزن الفصوص بالمليجرام
  final Karat karat;
  final ProductStatus status;
  final String? imageUrl;
  
  const GoldProduct({
    required this.code,
    required this.name,
    required this.barcode,
    required this.grossWeightMg,
    required this.stonesWeightMg,
    required this.karat,
    required this.status,
    this.imageUrl,
  });
  
  int get netWeightMg => grossWeightMg - stonesWeightMg;
  double get netWeightGrams => netWeightMg / 1000.0;
  double get grossWeightGrams => grossWeightMg / 1000.0;
  double get stonesWeightGrams => stonesWeightMg / 1000.0;
  
  @override
  List<Object?> get props => [
        code,
        name,
        barcode,
        grossWeightMg,
        stonesWeightMg,
        karat,
        status,
        imageUrl,
      ];
  
  factory GoldProduct.fromJson(Map<String, dynamic> json) {
    return GoldProduct(
      code: json['code'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      grossWeightMg: json['gross_weight_mg'] as int,
      stonesWeightMg: json['stones_weight_mg'] as int,
      karat: Karat.values.byName(json['karat'] as String),
      status: ProductStatus.values.byName(json['status'] as String),
      imageUrl: json['image_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'barcode': barcode,
      'gross_weight_mg': grossWeightMg,
      'stones_weight_mg': stonesWeightMg,
      'karat': karat.name,
      'status': status.name,
      'image_url': imageUrl,
    };
  }
}

/// سطر في الفاتورة
class InvoiceLineItem extends Equatable {
  final String id;
  final GoldProduct product;
  final int pricePerGramPiastres;           // سعر الجرام بالقرش
  final MakingChargeType makingChargeType;
  final int makingChargePerGramPiastres;    // لكل جرام
  final int? makingChargeFixedPiastres;     // ثابت
  final int discountPercentage;             // نسبة الخصم (0-100)
  
  // الحسابات (من Calculator)
  final int netWeightMg;
  final int goldValuePiastres;
  final int makingChargePiastres;
  final int discountPiastres;
  final int makingChargeAfterDiscountPiastres;
  final int taxPiastres;
  final int totalPiastres;
  
  const InvoiceLineItem({
    required this.id,
    required this.product,
    required this.pricePerGramPiastres,
    required this.makingChargeType,
    required this.makingChargePerGramPiastres,
    this.makingChargeFixedPiastres,
    required this.discountPercentage,
    required this.netWeightMg,
    required this.goldValuePiastres,
    required this.makingChargePiastres,
    required this.discountPiastres,
    required this.makingChargeAfterDiscountPiastres,
    required this.taxPiastres,
    required this.totalPiastres,
  });
  
  // للعرض
  double get pricePerGram => pricePerGramPiastres / 100.0;
  double get makingChargePerGram => makingChargePerGramPiastres / 100.0;
  double get makingChargeFixed => (makingChargeFixedPiastres ?? 0) / 100.0;
  double get goldValue => goldValuePiastres / 100.0;
  double get makingCharge => makingChargePiastres / 100.0;
  double get discount => discountPiastres / 100.0;
  double get makingChargeAfterDiscount => makingChargeAfterDiscountPiastres / 100.0;
  double get tax => taxPiastres / 100.0;
  double get total => totalPiastres / 100.0;
  
  @override
  List<Object?> get props => [
        id,
        product,
        pricePerGramPiastres,
        makingChargeType,
        makingChargePerGramPiastres,
        makingChargeFixedPiastres,
        discountPercentage,
        netWeightMg,
        goldValuePiastres,
        makingChargePiastres,
        discountPiastres,
        makingChargeAfterDiscountPiastres,
        taxPiastres,
        totalPiastres,
      ];
  
  InvoiceLineItem copyWith({
    int? pricePerGramPiastres,
    int? makingChargePerGramPiastres,
    int? makingChargeFixedPiastres,
    int? discountPercentage,
    int? netWeightMg,
    int? goldValuePiastres,
    int? makingChargePiastres,
    int? discountPiastres,
    int? makingChargeAfterDiscountPiastres,
    int? taxPiastres,
    int? totalPiastres,
  }) {
    return InvoiceLineItem(
      id: id,
      product: product,
      pricePerGramPiastres: pricePerGramPiastres ?? this.pricePerGramPiastres,
      makingChargeType: makingChargeType,
      makingChargePerGramPiastres: makingChargePerGramPiastres ?? this.makingChargePerGramPiastres,
      makingChargeFixedPiastres: makingChargeFixedPiastres ?? this.makingChargeFixedPiastres,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      netWeightMg: netWeightMg ?? this.netWeightMg,
      goldValuePiastres: goldValuePiastres ?? this.goldValuePiastres,
      makingChargePiastres: makingChargePiastres ?? this.makingChargePiastres,
      discountPiastres: discountPiastres ?? this.discountPiastres,
      makingChargeAfterDiscountPiastres: makingChargeAfterDiscountPiastres ?? this.makingChargeAfterDiscountPiastres,
      taxPiastres: taxPiastres ?? this.taxPiastres,
      totalPiastres: totalPiastres ?? this.totalPiastres,
    );
  }
}

/// بدل (Trade-in)
class TradeInItem extends Equatable {
  final int weightMg;                    // الوزن بالمليجرام
  final int discountPercentage;          // خصم الوزن
  final int buyBackPricePerGramPiastres; // سعر الشراء بالقرش
  final int valuePiastres;               // القيمة المحسوبة
  
  const TradeInItem({
    required this.weightMg,
    required this.discountPercentage,
    required this.buyBackPricePerGramPiastres,
    required this.valuePiastres,
  });
  
  double get weightGrams => weightMg / 1000.0;
  double get buyBackPricePerGram => buyBackPricePerGramPiastres / 100.0;
  double get value => valuePiastres / 100.0;
  
  @override
  List<Object?> get props => [
        weightMg,
        discountPercentage,
        buyBackPricePerGramPiastres,
        valuePiastres,
      ];
}

/// دفعة
class Payment extends Equatable {
  final String id;
  final PaymentMethod method;
  final int amountPiastres;
  final String? reference;
  
  const Payment({
    required this.id,
    required this.method,
    required this.amountPiastres,
    this.reference,
  });
  
  double get amount => amountPiastres / 100.0;
  
  @override
  List<Object?> get props => [id, method, amountPiastres, reference];
}

/// فاتورة بيع
class GoldInvoice extends Equatable {
  final String id;
  final DateTime createdAt;
  final List<InvoiceLineItem> lineItems;
  final TradeInItem? tradeIn;
  final List<Payment> payments;
  
  // الحسابات الإجمالية
  final int totalGoldValuePiastres;
  final int totalMakingChargePiastres;
  final int totalDiscountPiastres;
  final int totalTaxPiastres;
  final int subtotalPiastres;
  final int tradeInValuePiastres;
  final int grandTotalPiastres;
  final int paidPiastres;
  final int remainingPiastres;
  
  final bool isDraft;
  final bool isComplete;
  
  const GoldInvoice({
    required this.id,
    required this.createdAt,
    required this.lineItems,
    this.tradeIn,
    required this.payments,
    required this.totalGoldValuePiastres,
    required this.totalMakingChargePiastres,
    required this.totalDiscountPiastres,
    required this.totalTaxPiastres,
    required this.subtotalPiastres,
    required this.tradeInValuePiastres,
    required this.grandTotalPiastres,
    required this.paidPiastres,
    required this.remainingPiastres,
    required this.isDraft,
    required this.isComplete,
  });
  
  // للعرض
  double get totalGoldValue => totalGoldValuePiastres / 100.0;
  double get totalMakingCharge => totalMakingChargePiastres / 100.0;
  double get totalDiscount => totalDiscountPiastres / 100.0;
  double get totalTax => totalTaxPiastres / 100.0;
  double get subtotal => subtotalPiastres / 100.0;
  double get tradeInValue => tradeInValuePiastres / 100.0;
  double get grandTotal => grandTotalPiastres / 100.0;
  double get paid => paidPiastres / 100.0;
  double get remaining => remainingPiastres / 100.0;
  
  bool get needsApproval {
    // يحتاج موافقة لو أي سطر فيه خصم أكتر من 10%
    return lineItems.any((item) => item.discountPercentage > 10);
  }
  
  bool get canComplete {
    // يمكن إتمامها لو المدفوع يساوي أو أكبر من المطلوب
    return paidPiastres >= grandTotalPiastres;
  }
  
  @override
  List<Object?> get props => [
        id,
        createdAt,
        lineItems,
        tradeIn,
        payments,
        totalGoldValuePiastres,
        totalMakingChargePiastres,
        totalDiscountPiastres,
        totalTaxPiastres,
        subtotalPiastres,
        tradeInValuePiastres,
        grandTotalPiastres,
        paidPiastres,
        remainingPiastres,
        isDraft,
        isComplete,
      ];
  
  GoldInvoice copyWith({
    List<InvoiceLineItem>? lineItems,
    TradeInItem? tradeIn,
    List<Payment>? payments,
    int? totalGoldValuePiastres,
    int? totalMakingChargePiastres,
    int? totalDiscountPiastres,
    int? totalTaxPiastres,
    int? subtotalPiastres,
    int? tradeInValuePiastres,
    int? grandTotalPiastres,
    int? paidPiastres,
    int? remainingPiastres,
    bool? isDraft,
    bool? isComplete,
  }) {
    return GoldInvoice(
      id: id,
      createdAt: createdAt,
      lineItems: lineItems ?? this.lineItems,
      tradeIn: tradeIn ?? this.tradeIn,
      payments: payments ?? this.payments,
      totalGoldValuePiastres: totalGoldValuePiastres ?? this.totalGoldValuePiastres,
      totalMakingChargePiastres: totalMakingChargePiastres ?? this.totalMakingChargePiastres,
      totalDiscountPiastres: totalDiscountPiastres ?? this.totalDiscountPiastres,
      totalTaxPiastres: totalTaxPiastres ?? this.totalTaxPiastres,
      subtotalPiastres: subtotalPiastres ?? this.subtotalPiastres,
      tradeInValuePiastres: tradeInValuePiastres ?? this.tradeInValuePiastres,
      grandTotalPiastres: grandTotalPiastres ?? this.grandTotalPiastres,
      paidPiastres: paidPiastres ?? this.paidPiastres,
      remainingPiastres: remainingPiastres ?? this.remainingPiastres,
      isDraft: isDraft ?? this.isDraft,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

/// سعر الذهب الحالي
class GoldPrice {
  final Karat karat;
  final int pricePerGramPiastres;
  final DateTime updatedAt;
  
  const GoldPrice({
    required this.karat,
    required this.pricePerGramPiastres,
    required this.updatedAt,
  });
  
  double get pricePerGram => pricePerGramPiastres / 100.0;
}
