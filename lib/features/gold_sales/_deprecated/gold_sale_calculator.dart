import 'package:decimal/decimal.dart';

/// حاسبة بيع الذهب - منفصلة تماماً عن الواجهة
/// جميع الحسابات بالمليجرام والقروش لتجنب أخطاء الكسور
class GoldSaleCalculator {
  // ثوابت
  static const int piastresPerPound = 100;
  static const int mgPerGram = 1000;
  static final Decimal taxRate = Decimal.parse('0.14'); // 14%

  /// حساب سطر قطعة ذهب
  static LineCalculationResult calculateLine(GoldLineInput input) {
    // 1. حساب الوزن الصافي
    final netMg = input.grossMg - input.stoneMg;
    if (netMg <= 0) {
      throw ArgumentError('الوزن الصافي يجب أن يكون أكبر من صفر');
    }

    // 2. حساب قيمة الذهب (بالقرش)
    // الوزن بالجرام * السعر بالقرش
    final goldValueDecimal = _mgToGrams(netMg) * 
        Decimal.fromInt(input.pricePerGramPiastres);
    final goldValuePiastres = _roundToNearestPiaster(goldValueDecimal);

    // 3. حساب المصنعية (بالقرش)
    int workmanshipPiastres;
    if (input.workmanshipPerGram) {
      // مصنعية للجرام
      final workmanshipDecimal = _mgToGrams(netMg) * 
          Decimal.fromInt(input.workmanshipPerGramPiastres);
      workmanshipPiastres = _roundToNearestPiaster(workmanshipDecimal);
    } else {
      // مصنعية ثابتة
      workmanshipPiastres = input.fixedWorkmanshipPiastres;
    }

    // 4. حساب الخصم (على المصنعية فقط)
    final discountDecimal = Decimal.fromInt(workmanshipPiastres) * 
        input.discountPercent / Decimal.fromInt(100);
    final discountPiastres = _roundToNearestPiaster(Decimal.parse(discountDecimal.toString()));

    // 5. المصنعية بعد الخصم
    final workmanshipAfterDiscountPiastres = 
        workmanshipPiastres - discountPiastres;

    // 6. حساب الضريبة (14% على المصنعية بعد الخصم)
    final taxDecimal = Decimal.fromInt(workmanshipAfterDiscountPiastres) * taxRate;
    final taxPiastres = _roundToNearestPiaster(taxDecimal);

    // 7. الإجمالي
    final totalPiastres = goldValuePiastres + 
        workmanshipAfterDiscountPiastres + 
        taxPiastres;

    return LineCalculationResult(
      netMg: netMg,
      goldValuePiastres: goldValuePiastres,
      workmanshipPiastres: workmanshipPiastres,
      discountPiastres: discountPiastres,
      workmanshipAfterDiscountPiastres: workmanshipAfterDiscountPiastres,
      taxPiastres: taxPiastres,
      totalPiastres: totalPiastres,
    );
  }

  /// حساب البدل (Exchange)
  static ExchangeCalculationResult calculateExchange(ExchangeInput input) {
    // 1. حساب الوزن الصافي
    final netMg = input.grossMg - input.stoneMg;
    if (netMg <= 0) {
      throw ArgumentError('وزن البدل الصافي يجب أن يكون أكبر من صفر');
    }

    // 2. حساب الوزن بعد الخصم (نقرب للمليجرام الأول)
    final discountDecimal = Decimal.fromInt(netMg) * 
        input.discountPercent / Decimal.fromInt(100);
    final roundedDiscount = discountDecimal.round();
    final discountMg = int.parse(roundedDiscount.toString().split('.')[0]);
    final netAfterDiscountMg = netMg - discountMg;

    // 3. حساب قيمة البدل بسعر الشراء (نقرب للقرش)
    final exchangeValueDecimal = _mgToGrams(netAfterDiscountMg) * 
        Decimal.fromInt(input.buyPricePerGramPiastres);
    final exchangeValuePiastres = _roundToNearestPiaster(exchangeValueDecimal);

    return ExchangeCalculationResult(
      netMg: netMg,
      discountMg: discountMg,
      netAfterDiscountMg: netAfterDiscountMg,
      exchangeValuePiastres: exchangeValuePiastres,
    );
  }

  /// حساب الفاتورة الكاملة
  static InvoiceCalculationResult calculateInvoice({
    required List<LineCalculationResult> lines,
    ExchangeCalculationResult? exchange,
  }) {
    // جمع السطور (كل سطر مقرّب بالفعل)
    final totalPiastres = lines.fold<int>(
      0,
      (sum, line) => sum + line.totalPiastres,
    );

    // طرح البدل
    final exchangePiastres = exchange?.exchangeValuePiastres ?? 0;
    final netPiastres = totalPiastres - exchangePiastres;

    return InvoiceCalculationResult(
      totalPiastres: totalPiastres,
      exchangePiastres: exchangePiastres,
      netPiastres: netPiastres,
    );
  }

  /// Validation: التحقق من صحة المدخلات
  static void validateLineInput(GoldLineInput input) {
    if (input.grossMg <= 0) {
      throw ArgumentError('الوزن القائم يجب أن يكون أكبر من صفر');
    }
    if (input.stoneMg < 0) {
      throw ArgumentError('وزن الفصوص لا يمكن أن يكون سالب');
    }
    if (input.stoneMg >= input.grossMg) {
      throw ArgumentError('وزن الفصوص يجب أن يكون أقل من الوزن القائم');
    }
    if (input.pricePerGramPiastres <= 0) {
      throw ArgumentError('سعر الجرام يجب أن يكون أكبر من صفر');
    }
    if (input.discountPercent < Decimal.zero || 
        input.discountPercent > Decimal.fromInt(100)) {
      throw ArgumentError('نسبة الخصم يجب أن تكون بين 0 و 100');
    }
  }

  /// Validation: التحقق من خصم البائع (حد أقصى 10%)
  static bool isSellerDiscountValid(Decimal discountPercent) {
    return discountPercent <= Decimal.fromInt(10);
  }

  /// Validation: التحقق من الدفعات
  static bool arePaymentsValid(int totalPiastres, List<int> payments) {
    final sum = payments.fold<int>(0, (a, b) => a + b);
    return sum == totalPiastres;
  }

  // ========== Helper Methods ==========

  /// تحويل من مليجرام إلى جرام (Decimal)
  static Decimal _mgToGrams(int mg) {
    // نستخدم parse مباشرةً بدل division عشان نتجنب Rational
    final grams = mg / mgPerGram; // double division
    return Decimal.parse(grams.toString());
  }

  /// تقريب لأقرب قرش
  /// لو نصف قرش أو أكثر → يطلع للقرش اللي بعده
  static int _roundToNearestPiaster(Decimal value) {
    // نستخدم round() اللي بيقرب 0.5 للأعلى
    final rounded = value.round();
    return int.parse(rounded.toString().split('.')[0]);
  }
}

// ========== Input Models ==========

/// مدخلات سطر قطعة ذهب
class GoldLineInput {
  GoldLineInput({
    required this.grossMg,
    required this.stoneMg,
    required this.pricePerGramPiastres,
    required this.workmanshipPerGramPiastres,
    this.fixedWorkmanshipPiastres = 0,
    required this.workmanshipPerGram,
    required this.discountPercent,
  });

  final int grossMg;                      // الوزن القائم (مليجرام)
  final int stoneMg;                      // وزن الفصوص (مليجرام)
  final int pricePerGramPiastres;         // سعر الجرام (قرش)
  final int workmanshipPerGramPiastres;   // المصنعية للجرام (قرش)
  final int fixedWorkmanshipPiastres;     // المصنعية الثابتة (قرش)
  final bool workmanshipPerGram;          // true = للجرام, false = ثابتة
  final Decimal discountPercent;          // نسبة الخصم (0-100)
}

/// مدخلات البدل
class ExchangeInput {
  ExchangeInput({
    required this.grossMg,
    required this.stoneMg,
    required this.buyPricePerGramPiastres,
    required this.discountPercent,
  });

  final int grossMg;                      // الوزن القائم (مليجرام)
  final int stoneMg;                      // وزن الفصوص (مليجرام)
  final int buyPricePerGramPiastres;      // سعر الشراء للجرام (قرش)
  final Decimal discountPercent;          // نسبة الخصم (0-100)
}

// ========== Result Models ==========

/// نتيجة حساب سطر
class LineCalculationResult {
  const LineCalculationResult({
    required this.netMg,
    required this.goldValuePiastres,
    required this.workmanshipPiastres,
    required this.discountPiastres,
    required this.workmanshipAfterDiscountPiastres,
    required this.taxPiastres,
    required this.totalPiastres,
  });

  final int netMg;                              // الوزن الصافي (مليجرام)
  final int goldValuePiastres;                  // قيمة الذهب (قرش)
  final int workmanshipPiastres;                // المصنعية قبل الخصم (قرش)
  final int discountPiastres;                   // الخصم (قرش)
  final int workmanshipAfterDiscountPiastres;   // المصنعية بعد الخصم (قرش)
  final int taxPiastres;                        // الضريبة (قرش)
  final int totalPiastres;                      // الإجمالي (قرش)
}

/// نتيجة حساب البدل
class ExchangeCalculationResult {
  const ExchangeCalculationResult({
    required this.netMg,
    required this.discountMg,
    required this.netAfterDiscountMg,
    required this.exchangeValuePiastres,
  });

  final int netMg;                    // الوزن الصافي (مليجرام)
  final int discountMg;               // الخصم (مليجرام)
  final int netAfterDiscountMg;       // الوزن بعد الخصم (مليجرام)
  final int exchangeValuePiastres;    // قيمة البدل (قرش)
}

/// نتيجة حساب الفاتورة
class InvoiceCalculationResult {
  const InvoiceCalculationResult({
    required this.totalPiastres,
    required this.exchangePiastres,
    required this.netPiastres,
  });

  final int totalPiastres;      // الإجمالي (قرش)
  final int exchangePiastres;   // البدل (قرش)
  final int netPiastres;        // الصافي (قرش)
}
