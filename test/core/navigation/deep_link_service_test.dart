// ignore_for_file: unused_import, body_might_complete_normally_nullable, unused_local_variable
// DEPRECATED TEST: Uses old navigation structure

import 'package:codit/core/navigation/deep_link_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late DeepLinkService service;
  late MockGoRouter router;

  setUp(() {
    router = MockGoRouter();
    service = DeepLinkService(router);
    
    // تسجيل الدخول بشكل افتراضي
    service.onLogin();
  });

  group('Deep Link Service Tests', () {
    test('معالجة لينك صحيح للموافقات', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      final result = await service.handleNotificationLink(
        'codit://notification?type=approval&id=APR-123',
      );

      expect(result, true);
      verify(() => router.push('/approvals/details/APR-123')).called(1);
    });

    test('معالجة لينك صحيح للأقساط', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      final result = await service.handleNotificationLink(
        'codit://notification?type=installment&id=CUST-456',
      );

      expect(result, true);
      verify(() => router.push('/installments/customer/CUST-456')).called(1);
    });

    test('معالجة لينك صحيح لبيع الذهب', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      final result = await service.handleNotificationLink(
        'codit://notification?type=gold_sale&id=INV-789',
      );

      expect(result, true);
      verify(() => router.push('/gold-sales/invoice/INV-789')).called(1);
    });

    test('معالجة لينك صحيح لتنبيه الفرع', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      final result = await service.handleNotificationLink(
        'codit://notification?type=branch_alert&id=BR-A',
      );

      expect(result, true);
      verify(() => router.push('/branch-monitoring?branch=BR-A')).called(1);
    });

    test('رفض لينك غير صحيح', () async {
      final result = await service.handleNotificationLink('invalid-link');

      expect(result, false);
      verifyNever(() => router.push(any()));
    });

    test('رفض لينك بدون type', () async {
      final result = await service.handleNotificationLink(
        'codit://notification?id=APR-123',
      );

      expect(result, false);
      verifyNever(() => router.push(any()));
    });

    test('رفض لينك بدون id', () async {
      final result = await service.handleNotificationLink(
        'codit://notification?type=approval',
      );

      expect(result, false);
      verifyNever(() => router.push(any()));
    });

    test('رفض type غير معروف', () async {
      final result = await service.handleNotificationLink(
        'codit://notification?type=unknown&id=123',
      );

      expect(result, false);
      verifyNever(() => router.push(any()));
    });

    test('منع تكرار نفس اللينك', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      final link = 'codit://notification?type=approval&id=APR-123';

      // المحاولة الأولى: ناجحة
      final result1 = await service.handleNotificationLink(link);
      expect(result1, true);

      // المحاولة الثانية: مرفوضة (duplicate)
      final result2 = await service.handleNotificationLink(link);
      expect(result2, false);

      // التحقق من أن push تم مرة واحدة فقط
      verify(() => router.push('/approvals/details/APR-123')).called(1);
    });

    test('منع معالجة لينك أثناء الخروج', () async {
      // تسجيل الخروج
      service.onLogout();

      final result = await service.handleNotificationLink(
        'codit://notification?type=approval&id=APR-123',
      );

      expect(result, false);
      verifyNever(() => router.push(any()));
    });

    test('السماح بمعالجة بعد تسجيل الدخول مجدداً', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      // تسجيل الخروج
      service.onLogout();

      // محاولة فتح لينك: مرفوض
      var result = await service.handleNotificationLink(
        'codit://notification?type=approval&id=APR-123',
      );
      expect(result, false);

      // تسجيل الدخول مجدداً
      service.onLogin();

      // محاولة فتح لينك: مقبول
      result = await service.handleNotificationLink(
        'codit://notification?type=approval&id=APR-123',
      );
      expect(result, true);

      verify(() => router.push('/approvals/details/APR-123')).called(1);
    });

    test('reset: مسح الحالة بالكامل', () async {
      when(() => router.push(any())).thenAnswer((_) async {});

      final link = 'codit://notification?type=approval&id=APR-123';

      // فتح لينك
      await service.handleNotificationLink(link);

      // reset
      service.reset();

      // محاولة فتح نفس اللينك: مقبول (لأن reset مسح الـ cache)
      final result = await service.handleNotificationLink(link);
      expect(result, true);

      // التحقق من أن push تم مرتين
      verify(() => router.push('/approvals/details/APR-123')).called(2);
    });

    test('منع معالجة متزامنة لعدة لينكات', () async {
      when(() => router.push(any())).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 100)),
      );

      final link1 = 'codit://notification?type=approval&id=APR-1';
      final link2 = 'codit://notification?type=approval&id=APR-2';

      // بدء معالجة اللينك الأول (بطيئة)
      final future1 = service.handleNotificationLink(link1);

      // محاولة معالجة اللينك الثاني قبل انتهاء الأول: مرفوض
      final result2 = await service.handleNotificationLink(link2);
      expect(result2, false);

      // انتظار انتهاء الأول
      final result1 = await future1;
      expect(result1, true);

      // الآن يمكن معالجة اللينك الثاني
      final result3 = await service.handleNotificationLink(link2);
      expect(result3, true);

      verify(() => router.push('/approvals/details/APR-1')).called(1);
      verify(() => router.push('/approvals/details/APR-2')).called(1);
    });
  });
}
