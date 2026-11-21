/// Gold POS Calculator Engine
/// يستخدم Integer Math لتجنب أخطاء الـ Floating Point
/// 
/// الوحدات:
/// - الوزن: مليجرام (mg)
/// - المبلغ: قرش (piastres) - 1 جنيه = 100 قرش
/// 
/// التقريب:
/// - نصف قرش أو أكثر → يطلع للقرش اللي فوق
/// - أقل من نصف قرش → ينزل للقرش اللي تحت

class GoldCalculator {
  /// حساب الوزن الصافي
  /// الوزن الصافي = الوزن القائم - وزن الفصوص
  static int calculateNetWeight({
    required int grossWeightMg,
    required int stonesWeightMg,
  }) {
    if (grossWeightMg <= 0) {
      throw ArgumentError('الوزن القائم يجب أن يكون أكبر من صفر');
    }
    
    if (stonesWeightMg < 0) {
      throw ArgumentError('وزن الفصوص لا يمكن أن يكون سالباً');
    }
    
    if (stonesWeightMg >= grossWeightMg) {
      throw ArgumentError('وزن الفصوص لا يمكن أن يساوي أو يزيد عن الوزن القائم');
    }
    
    return grossWeightMg - stonesWeightMg;
  }
  
  /// حساب قيمة الذهب
  /// قيمة الذهب = (الوزن الصافي ÷ 1000) × سعر الجرام
  /// النتيجة بالقرش
  static int calculateGoldValue({
    required int netWeightMg,
    required int pricePerGramPiastres,
  }) {
    if (netWeightMg <= 0) {
      throw ArgumentError('الوزن الصافي يجب أن يكون أكبر من صفر');
    }
    
    if (pricePerGramPiastres <= 0) {
      throw ArgumentError('سعر الجرام يجب أن يكون أكبر من صفر');
    }
    
    // حساب بالقرش: (وزن_بالمليجرام × سعر_الجرام_بالقرش) ÷ 1000
    // نضرب × 2 قبل القسمة عشان نقدر نقرب صح
    final valueX2 = (netWeightMg * pricePerGramPiastres * 2);
    final result = (valueX2 + 1000) ~/ 2000; // التقريب لأقرب قرش
    
    return result;
  }
  
  /// حساب المصنعية (لكل جرام)
  /// المصنعية = (الوزن الصافي ÷ 1000) × سعر المصنعية للجرام
  static int calculateMakingChargePerGram({
    required int netWeightMg,
    required int makingChargePerGramPiastres,
  }) {
    if (netWeightMg <= 0) {
      throw ArgumentError('الوزن الصافي يجب أن يكون أكبر من صفر');
    }
    
    if (makingChargePerGramPiastres < 0) {
      throw ArgumentError('سعر المصنعية لا يمكن أن يكون سالباً');
    }
    
    final valueX2 = (netWeightMg * makingChargePerGramPiastres * 2);
    final result = (valueX2 + 1000) ~/ 2000;
    
    return result;
  }
  
  /// حساب المصنعية (مبلغ ثابت)
  static int calculateMakingChargeFixed({
    required int fixedAmountPiastres,
  }) {
    if (fixedAmountPiastres < 0) {
      throw ArgumentError('المصنعية الثابتة لا يمكن أن تكون سالبة');
    }
    
    return fixedAmountPiastres;
  }
  
  /// حساب الخصم على المصنعية
  /// الخصم = المصنعية × نسبة الخصم
  static int calculateDiscount({
    required int makingChargePiastres,
    required int discountPercentage,
  }) {
    if (makingChargePiastres < 0) {
      throw ArgumentError('المصنعية لا يمكن أن تكون سالبة');
    }
    
    if (discountPercentage < 0 || discountPercentage > 100) {
      throw ArgumentError('نسبة الخصم يجب أن تكون بين 0 و 100');
    }
    
    // الخصم = (المصنعية × النسبة) ÷ 100
    // نضرب × 2 للتقريب
    final discountX2 = (makingChargePiastres * discountPercentage * 2);
    final result = (discountX2 + 100) ~/ 200;
    
    return result;
  }
  
  /// حساب الضريبة (14%)
  /// الضريبة = (المصنعية بعد الخصم) × 0.14
  static int calculateTax({
    required int makingChargeAfterDiscountPiastres,
  }) {
    if (makingChargeAfterDiscountPiastres < 0) {
      throw ArgumentError('المصنعية بعد الخصم لا يمكن أن تكون سالبة');
    }
    
    // الضريبة = (المصنعية_بعد_الخصم × 14) ÷ 100
    // نضرب × 2 للتقريب
    final taxX2 = (makingChargeAfterDiscountPiastres * 14 * 2);
    final result = (taxX2 + 100) ~/ 200;
    
    return result;
  }
  
  /// حساب قيمة البدل (Trade-in)
  /// 1. تطبيق خصم الوزن أولاً (تقريب لأقرب مليجرام)
  /// 2. حساب القيمة = (الوزن_بعد_الخصم ÷ 1000) × سعر_الشراء
  static int calculateTradeInValue({
    required int tradeInWeightMg,
    required int tradeInDiscountPercentage,
    required int buyBackPricePerGramPiastres,
  }) {
    if (tradeInWeightMg < 0) {
      throw ArgumentError('وزن البدل لا يمكن أن يكون سالباً');
    }
    
    if (tradeInWeightMg == 0) {
      return 0;
    }
    
    if (tradeInDiscountPercentage < 0 || tradeInDiscountPercentage > 100) {
      throw ArgumentError('نسبة خصم البدل يجب أن تكون بين 0 و 100');
    }
    
    if (buyBackPricePerGramPiastres < 0) {
      throw ArgumentError('سعر شراء البدل لا يمكن أن يكون سالباً');
    }
    
    // 1. حساب الوزن بعد الخصم (تقريب لأقرب مليجرام)
    final weightAfterDiscountX2 = tradeInWeightMg * (100 - tradeInDiscountPercentage) * 2;
    final weightAfterDiscount = (weightAfterDiscountX2 + 100) ~/ 200;
    
    // 2. حساب القيمة
    final valueX2 = (weightAfterDiscount * buyBackPricePerGramPiastres * 2);
    final result = (valueX2 + 1000) ~/ 2000;
    
    return result;
  }
  
  /// حساب إجمالي سطر واحد في الفاتورة
  static LineItemTotal calculateLineTotal({
    required int grossWeightMg,
    required int stonesWeightMg,
    required int pricePerGramPiastres,
    required int makingChargePerGramPiastres,
    int? makingChargeFixedPiastres,
    required int discountPercentage,
  }) {
    // 1. الوزن الصافي
    final netWeight = calculateNetWeight(
      grossWeightMg: grossWeightMg,
      stonesWeightMg: stonesWeightMg,
    );
    
    // 2. قيمة الذهب
    final goldValue = calculateGoldValue(
      netWeightMg: netWeight,
      pricePerGramPiastres: pricePerGramPiastres,
    );
    
    // 3. المصنعية
    final makingCharge = makingChargeFixedPiastres ??
        calculateMakingChargePerGram(
          netWeightMg: netWeight,
          makingChargePerGramPiastres: makingChargePerGramPiastres,
        );
    
    // 4. الخصم
    final discount = calculateDiscount(
      makingChargePiastres: makingCharge,
      discountPercentage: discountPercentage,
    );
    
    // 5. المصنعية بعد الخصم
    final makingChargeAfterDiscount = makingCharge - discount;
    
    // 6. الضريبة
    final tax = calculateTax(
      makingChargeAfterDiscountPiastres: makingChargeAfterDiscount,
    );
    
    // 7. الإجمالي
    final total = goldValue + makingChargeAfterDiscount + tax;
    
    return LineItemTotal(
      netWeightMg: netWeight,
      goldValuePiastres: goldValue,
      makingChargePiastres: makingCharge,
      discountPiastres: discount,
      makingChargeAfterDiscountPiastres: makingChargeAfterDiscount,
      taxPiastres: tax,
      totalPiastres: total,
    );
  }
  
  /// حساب إجمالي الفاتورة (مع البدل)
  static InvoiceTotal calculateInvoiceTotal({
    required List<LineItemTotal> lineItems,
    int? tradeInWeightMg,
    int? tradeInDiscountPercentage,
    int? buyBackPricePerGramPiastres,
  }) {
    // 1. جمع الأسطر
    int totalGoldValue = 0;
    int totalMakingCharge = 0;
    int totalDiscount = 0;
    int totalTax = 0;
    int subtotal = 0;
    
    for (final item in lineItems) {
      totalGoldValue += item.goldValuePiastres;
      totalMakingCharge += item.makingChargePiastres;
      totalDiscount += item.discountPiastres;
      totalTax += item.taxPiastres;
      subtotal += item.totalPiastres;
    }
    
    // 2. قيمة البدل
    int tradeInValue = 0;
    if (tradeInWeightMg != null &&
        tradeInWeightMg > 0 &&
        buyBackPricePerGramPiastres != null) {
      tradeInValue = calculateTradeInValue(
        tradeInWeightMg: tradeInWeightMg,
        tradeInDiscountPercentage: tradeInDiscountPercentage ?? 0,
        buyBackPricePerGramPiastres: buyBackPricePerGramPiastres,
      );
    }
    
    // 3. المبلغ النهائي
    final grandTotal = subtotal - tradeInValue;
    
    return InvoiceTotal(
      totalGoldValuePiastres: totalGoldValue,
      totalMakingChargePiastres: totalMakingCharge,
      totalDiscountPiastres: totalDiscount,
      totalTaxPiastres: totalTax,
      subtotalPiastres: subtotal,
      tradeInValuePiastres: tradeInValue,
      grandTotalPiastres: grandTotal,
    );
  }
}

/// نتيجة حساب سطر واحد
class LineItemTotal {
  final int netWeightMg;
  final int goldValuePiastres;
  final int makingChargePiastres;
  final int discountPiastres;
  final int makingChargeAfterDiscountPiastres;
  final int taxPiastres;
  final int totalPiastres;
  
  const LineItemTotal({
    required this.netWeightMg,
    required this.goldValuePiastres,
    required this.makingChargePiastres,
    required this.discountPiastres,
    required this.makingChargeAfterDiscountPiastres,
    required this.taxPiastres,
    required this.totalPiastres,
  });
  
  /// تحويل للعرض (بالجنيه)
  double get netWeightGrams => netWeightMg / 1000.0;
  double get goldValue => goldValuePiastres / 100.0;
  double get makingCharge => makingChargePiastres / 100.0;
  double get discount => discountPiastres / 100.0;
  double get makingChargeAfterDiscount => makingChargeAfterDiscountPiastres / 100.0;
  double get tax => taxPiastres / 100.0;
  double get total => totalPiastres / 100.0;
}

/// نتيجة حساب الفاتورة الكاملة
class InvoiceTotal {
  final int totalGoldValuePiastres;
  final int totalMakingChargePiastres;
  final int totalDiscountPiastres;
  final int totalTaxPiastres;
  final int subtotalPiastres;
  final int tradeInValuePiastres;
  final int grandTotalPiastres;
  
  const InvoiceTotal({
    required this.totalGoldValuePiastres,
    required this.totalMakingChargePiastres,
    required this.totalDiscountPiastres,
    required this.totalTaxPiastres,
    required this.subtotalPiastres,
    required this.tradeInValuePiastres,
    required this.grandTotalPiastres,
  });
  
  /// تحويل للعرض (بالجنيه)
  double get totalGoldValue => totalGoldValuePiastres / 100.0;
  double get totalMakingCharge => totalMakingChargePiastres / 100.0;
  double get totalDiscount => totalDiscountPiastres / 100.0;
  double get totalTax => totalTaxPiastres / 100.0;
  double get subtotal => subtotalPiastres / 100.0;
  double get tradeInValue => tradeInValuePiastres / 100.0;
  double get grandTotal => grandTotalPiastres / 100.0;
}
