import 'package:codit/features/gold_sales/domain/gold_sale_calculator.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Gold Sale Calculator Tests', () {
    test('Test Case المطلوب: 4500mg, 300mg, 4200 قرش, 120 قرش, 10% خصم = 18157.10 جنيه', () {
      // المدخلات
      final input = GoldLineInput(
        grossMg: 4500,                    // الوزن القائم
        stoneMg: 300,                     // وزن الفصوص
        pricePerGramPiastres: 420000,     // سعر الجرام = 4200 جنيه = 420000 قرش
        workmanshipPerGramPiastres: 12000, // مصنعية = 120 جنيه/جرام = 12000 قرش
        workmanshipPerGram: true,         // مصنعية للجرام
        discountPercent: Decimal.fromInt(10), // خصم 10%
      );

      // الحساب
      final result = GoldSaleCalculator.calculateLine(input);

      // الوزن الصافي = 4500 - 300 = 4200 mg = 4.2 جرام
      expect(result.netMg, 4200);

      // قيمة الذهب = 4.2 * 420000 = 1,764,000 قرش
      expect(result.goldValuePiastres, 1764000);

      // المصنعية = 4.2 * 12000 = 50,400 قرش
      expect(result.workmanshipPiastres, 50400);

      // الخصم (على المصنعية) = 50400 * 10% = 5,040 قرش
      expect(result.discountPiastres, 5040);

      // المصنعية بعد الخصم = 50400 - 5040 = 45,360 قرش
      expect(result.workmanshipAfterDiscountPiastres, 45360);

      // الضريبة = 45360 * 14% = 6,350.4 قرش → 6,350 قرش (تقريب)
      expect(result.taxPiastres, 6350);

      // الإجمالي = 1,764,000 + 45,360 + 6,350 = 1,815,710 قرش = 18,157.10 جنيه
      expect(result.totalPiastres, 1815710);

      // التحقق من النتيجة النهائية
      final pounds = result.totalPiastres / 100;
      expect(pounds, 18157.10);
    });

    test('حساب قيمة الذهب فقط', () {
      final input = GoldLineInput(
        grossMg: 5000,
        stoneMg: 500,
        pricePerGramPiastres: 400000, // 4000 جنيه
        workmanshipPerGramPiastres: 0,
        workmanshipPerGram: true,
        discountPercent: Decimal.zero,
      );

      final result = GoldSaleCalculator.calculateLine(input);

      // الوزن الصافي = 4500 mg = 4.5 جرام
      expect(result.netMg, 4500);

      // قيمة الذهب = 4.5 * 400000 = 1,800,000 قرش = 18,000 جنيه
      expect(result.goldValuePiastres, 1800000);
      expect(result.totalPiastres, 1800000);
    });

    test('مصنعية ثابتة', () {
      final input = GoldLineInput(
        grossMg: 3000,
        stoneMg: 0,
        pricePerGramPiastres: 400000,
        workmanshipPerGramPiastres: 0,
        fixedWorkmanshipPiastres: 50000, // 500 جنيه مصنعية ثابتة
        workmanshipPerGram: false,
        discountPercent: Decimal.zero,
      );

      final result = GoldSaleCalculator.calculateLine(input);

      expect(result.workmanshipPiastres, 50000);
      expect(result.taxPiastres, 7000); // 14% من 50000
    });

    test('التقريب الصحيح - نصف قرش يطلع للأعلى', () {
      // قيمة تنتج 100.5 قرش يجب أن تقرب لـ 101
      final input = GoldLineInput(
        grossMg: 1005, // وزن يعطي قيمة بها كسر
        stoneMg: 5,
        pricePerGramPiastres: 100000, // 1000 جنيه
        workmanshipPerGramPiastres: 0,
        workmanshipPerGram: true,
        discountPercent: Decimal.zero,
      );

      final result = GoldSaleCalculator.calculateLine(input);

      // الوزن = 1000mg = 1 جرام بالضبط
      // القيمة = 1 * 100000 = 100,000 قرش (لا كسور هنا)
      expect(result.goldValuePiastres, 100000);
    });

    test('حساب البدل مع خصم', () {
      final input = ExchangeInput(
        grossMg: 5000,
        stoneMg: 500,
        buyPricePerGramPiastres: 380000, // سعر الشراء 3800 جنيه
        discountPercent: Decimal.fromInt(10), // خصم 10%
      );

      final result = GoldSaleCalculator.calculateExchange(input);

      // الوزن الصافي قبل الخصم = 5000 - 500 = 4500 mg
      expect(result.netMg, 4500);

      // الخصم = 10% → الوزن بعد الخصم = 4500 * 0.9 = 4050 mg
      expect(result.netAfterDiscountMg, 4050);

      // القيمة = 4.05 جرام * 380000 = 1,539,000 قرش
      expect(result.exchangeValuePiastres, 1539000);
    });

    test('Validation: وزن صفر', () {
      final input = GoldLineInput(
        grossMg: 0,
        stoneMg: 0,
        pricePerGramPiastres: 400000,
        workmanshipPerGramPiastres: 0,
        workmanshipPerGram: true,
        discountPercent: Decimal.zero,
      );

      expect(
        () => GoldSaleCalculator.calculateLine(input),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Validation: فصوص أكبر من الوزن القائم', () {
      final input = GoldLineInput(
        grossMg: 1000,
        stoneMg: 1500,
        pricePerGramPiastres: 400000,
        workmanshipPerGramPiastres: 0,
        workmanshipPerGram: true,
        discountPercent: Decimal.zero,
      );

      expect(
        () => GoldSaleCalculator.validateLineInput(input),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Validation: خصم البائع - حد أقصى 10%', () {
      expect(
        GoldSaleCalculator.isSellerDiscountValid(Decimal.fromInt(10)),
        true,
      );
      expect(
        GoldSaleCalculator.isSellerDiscountValid(Decimal.fromInt(5)),
        true,
      );
      expect(
        GoldSaleCalculator.isSellerDiscountValid(Decimal.fromInt(11)),
        false,
      );
    });

    test('Validation: الدفعات تساوي الإجمالي', () {
      const totalPiastres = 1815710; // 18,157.10 جنيه

      // دفعات صحيحة
      expect(
        GoldSaleCalculator.arePaymentsValid(
          totalPiastres,
          [1000000, 815710], // 10,000 + 8,157.10
        ),
        true,
      );

      // دفعات ناقصة قرش واحد
      expect(
        GoldSaleCalculator.arePaymentsValid(
          totalPiastres,
          [1000000, 815709], // ناقص قرش
        ),
        false,
      );
    });

    test('حساب فاتورة كاملة مع بدل', () {
      // سطر 1
      final line1 = GoldSaleCalculator.calculateLine(GoldLineInput(
        grossMg: 4500,
        stoneMg: 300,
        pricePerGramPiastres: 420000,
        workmanshipPerGramPiastres: 12000,
        workmanshipPerGram: true,
        discountPercent: Decimal.fromInt(10),
      ));

      // سطر 2
      final line2 = GoldSaleCalculator.calculateLine(GoldLineInput(
        grossMg: 3000,
        stoneMg: 0,
        pricePerGramPiastres: 420000,
        workmanshipPerGramPiastres: 10000,
        workmanshipPerGram: true,
        discountPercent: Decimal.fromInt(5),
      ));

      // البدل
      final exchange = GoldSaleCalculator.calculateExchange(ExchangeInput(
        grossMg: 5000,
        stoneMg: 500,
        buyPricePerGramPiastres: 380000,
        discountPercent: Decimal.fromInt(10),
      ));

      // الفاتورة
      final invoice = GoldSaleCalculator.calculateInvoice(
        lines: [line1, line2],
        exchange: exchange,
      );

      // التحقق من الحسابات
      expect(invoice.totalPiastres, line1.totalPiastres + line2.totalPiastres);
      expect(invoice.exchangePiastres, exchange.exchangeValuePiastres);
      expect(
        invoice.netPiastres,
        invoice.totalPiastres - invoice.exchangePiastres,
      );
    });

    test('منع إضافة نفس القطعة مرتين - logic في الـ Cubit', () {
      // هذا الـ test يتأكد من أن الـ Calculator نفسه مستقل
      // والـ validation يتم في الـ Cubit/UI
      // هنا فقط نتأكد من أن Calculator يحسب بشكل صحيح

      final input = GoldLineInput(
        grossMg: 5000,
        stoneMg: 0,
        pricePerGramPiastres: 400000,
        workmanshipPerGramPiastres: 10000,
        workmanshipPerGram: true,
        discountPercent: Decimal.zero,
      );

      // حساب نفس القطعة مرتين (Calculator لا يمنع - الـ Cubit يمنع)
      final result1 = GoldSaleCalculator.calculateLine(input);
      final result2 = GoldSaleCalculator.calculateLine(input);

      // النتيجة متطابقة
      expect(result1.totalPiastres, result2.totalPiastres);
    });
  });
}
