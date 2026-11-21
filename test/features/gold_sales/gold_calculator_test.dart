import 'package:codit/features/gold_sales/domain/gold_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoldCalculator - Integer Math Precision Tests', () {
    test('حالة الاختبار المحددة في التاسك', () {
      // المدخلات:
      // الوزن القائم: 4500 مليجرام
      // الفصوص: 300 مليجرام
      // سعر الجرام: 4200 جنيه = 420000 قرش
      // المصنعية: 120 جنيه للجرام = 12000 قرش
      // الخصم: 10%
      
      final result = GoldCalculator.calculateLineTotal(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        pricePerGramPiastres: 420000,
        makingChargePerGramPiastres: 12000,
        discountPercentage: 10,
      );
      
      // التوقعات:
      // الوزن الصافي = 4500 - 300 = 4200 مليجرام = 4.2 جرام
      expect(result.netWeightMg, 4200);
      expect(result.netWeightGrams, 4.2);
      
      // قيمة الذهب = 4.2 × 4200 = 17,640 جنيه
      expect(result.goldValue, 17640.0);
      
      // المصنعية = 4.2 × 120 = 504 جنيه
      expect(result.makingCharge, 504.0);
      
      // الخصم = 504 × 10% = 50.4 جنيه
      expect(result.discount, 50.4);
      
      // المصنعية بعد الخصم = 504 - 50.4 = 453.6 جنيه
      expect(result.makingChargeAfterDiscount, 453.6);
      
      // الضريبة = 453.6 × 14% = 63.504 → 63.50 جنيه (التقريب)
      expect(result.tax, 63.50);
      
      // الإجمالي = 17,640 + 453.6 + 63.50 = 18,157.10 جنيه
      expect(result.total, 18157.10);
      
      print('✅ Test Case Passed!');
      print('النتيجة النهائية: ${result.total} جنيه');
    });
    
    test('حساب الوزن الصافي', () {
      final netWeight = GoldCalculator.calculateNetWeight(
        grossWeightMg: 5000,
        stonesWeightMg: 200,
      );
      
      expect(netWeight, 4800);
    });
    
    test('حساب قيمة الذهب', () {
      // 5 جرام × 4000 جنيه = 20,000 جنيه
      final goldValue = GoldCalculator.calculateGoldValue(
        netWeightMg: 5000,
        pricePerGramPiastres: 400000,
      );
      
      expect(goldValue, 2000000); // 20,000 جنيه = 2,000,000 قرش
    });
    
    test('حساب المصنعية (لكل جرام)', () {
      // 3 جرام × 100 جنيه = 300 جنيه
      final makingCharge = GoldCalculator.calculateMakingChargePerGram(
        netWeightMg: 3000,
        makingChargePerGramPiastres: 10000,
      );
      
      expect(makingCharge, 30000); // 300 جنيه = 30,000 قرش
    });
    
    test('حساب الخصم', () {
      // 500 جنيه × 15% = 75 جنيه
      final discount = GoldCalculator.calculateDiscount(
        makingChargePiastres: 50000,
        discountPercentage: 15,
      );
      
      expect(discount, 7500); // 75 جنيه = 7,500 قرش
    });
    
    test('حساب الضريبة 14%', () {
      // 1000 جنيه × 14% = 140 جنيه
      final tax = GoldCalculator.calculateTax(
        makingChargeAfterDiscountPiastres: 100000,
      );
      
      expect(tax, 14000); // 140 جنيه = 14,000 قرش
    });
    
    test('حساب قيمة البدل (Trade-in)', () {
      // وزن: 10 جرام
      // خصم: 5%
      // الوزن بعد الخصم: 10 × 95% = 9.5 جرام
      // سعر الشراء: 3800 جنيه للجرام
      // القيمة: 9.5 × 3800 = 36,100 جنيه
      
      final tradeInValue = GoldCalculator.calculateTradeInValue(
        tradeInWeightMg: 10000,
        tradeInDiscountPercentage: 5,
        buyBackPricePerGramPiastres: 380000,
      );
      
      expect(tradeInValue, 3610000); // 36,100 جنيه = 3,610,000 قرش
    });
    
    test('تقريب نصف القرش للأعلى', () {
      // حالة: 100.5 جنيه يجب أن تصير 101 جنيه
      // المصنعية: 201 قرش (2.01 جنيه)
      // الخصم: 50% = 100.5 قرش
      // التقريب: 101 قرش
      
      final discount = GoldCalculator.calculateDiscount(
        makingChargePiastres: 201,
        discountPercentage: 50,
      );
      
      expect(discount, 101); // يتقرب للأعلى
    });
    
    test('تقريب أقل من نصف القرش للأسفل', () {
      // حالة: 100.4 قرش يجب أن تصير 100 قرش
      // المصنعية: 1004 قرش
      // الخصم: 10% = 100.4 قرش
      // التقريب: 100 قرش
      
      final discount = GoldCalculator.calculateDiscount(
        makingChargePiastres: 1004,
        discountPercentage: 10,
      );
      
      expect(discount, 100); // يتقرب للأسفل
    });
    
    test('حساب فاتورة كاملة مع قطعتين وبدل', () {
      // القطعة الأولى
      final item1 = GoldCalculator.calculateLineTotal(
        grossWeightMg: 5000,
        stonesWeightMg: 200,
        pricePerGramPiastres: 400000,
        makingChargePerGramPiastres: 10000,
        discountPercentage: 5,
      );
      
      // القطعة الثانية
      final item2 = GoldCalculator.calculateLineTotal(
        grossWeightMg: 3000,
        stonesWeightMg: 100,
        pricePerGramPiastres: 400000,
        makingChargePerGramPiastres: 15000,
        discountPercentage: 10,
      );
      
      // حساب الإجمالي مع البدل
      final invoice = GoldCalculator.calculateInvoiceTotal(
        lineItems: [item1, item2],
        tradeInWeightMg: 10000,
        tradeInDiscountPercentage: 5,
        buyBackPricePerGramPiastres: 380000,
      );
      
      // التحقق من وجود قيمة بدل
      expect(invoice.tradeInValuePiastres, greaterThan(0));
      
      // الإجمالي النهائي = الإجمالي الفرعي - البدل
      expect(
        invoice.grandTotalPiastres,
        invoice.subtotalPiastres - invoice.tradeInValuePiastres,
      );
      
      print('إجمالي الفاتورة: ${invoice.grandTotal} جنيه');
      print('البدل: ${invoice.tradeInValue} جنيه');
      print('الصافي: ${invoice.grandTotal} جنيه');
    });
  });
  
  group('GoldCalculator - Validation Tests', () {
    test('رفض الوزن القائم صفر أو سالب', () {
      expect(
        () => GoldCalculator.calculateNetWeight(
          grossWeightMg: 0,
          stonesWeightMg: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
      
      expect(
        () => GoldCalculator.calculateNetWeight(
          grossWeightMg: -100,
          stonesWeightMg: 0,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    
    test('رفض وزن الفصوص أكبر من أو يساوي الوزن القائم', () {
      expect(
        () => GoldCalculator.calculateNetWeight(
          grossWeightMg: 5000,
          stonesWeightMg: 5000,
        ),
        throwsA(isA<ArgumentError>()),
      );
      
      expect(
        () => GoldCalculator.calculateNetWeight(
          grossWeightMg: 5000,
          stonesWeightMg: 6000,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
    
    test('رفض نسبة خصم خارج النطاق 0-100', () {
      expect(
        () => GoldCalculator.calculateDiscount(
          makingChargePiastres: 10000,
          discountPercentage: -5,
        ),
        throwsA(isA<ArgumentError>()),
      );
      
      expect(
        () => GoldCalculator.calculateDiscount(
          makingChargePiastres: 10000,
          discountPercentage: 150,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
