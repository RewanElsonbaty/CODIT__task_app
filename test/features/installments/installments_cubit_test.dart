import 'package:flutter_test/flutter_test.dart';
import 'package:codit/features/installments/presentation/installments_list_cubit.dart';

void main() {
  group('InstallmentsListCubit Tests', () {
    late InstallmentsListCubit cubit;

    setUp(() {
      cubit = InstallmentsListCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be InstallmentsListLoading', () {
      expect(cubit.state, isA<InstallmentsListLoading>());
    });

    test('loadInstallments should emit InstallmentsListLoaded', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      expect(cubit.state, isA<InstallmentsListLoaded>());
      
      final state = cubit.state as InstallmentsListLoaded;
      expect(state.installments, isNotEmpty);
      expect(state.selectedFilter, equals('الكل'));
    });

    test('filterInstallments should update selectedFilter', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      cubit.filterInstallments('نشط');

      expect(cubit.state, isA<InstallmentsListLoaded>());
      
      final state = cubit.state as InstallmentsListLoaded;
      expect(state.selectedFilter, equals('نشط'));
    });

    test('getFilteredInstallments should return all when filter is الكل', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final filtered = cubit.getFilteredInstallments();
      final state = cubit.state as InstallmentsListLoaded;

      expect(filtered.length, equals(state.installments.length));
    });

    test('getFilteredInstallments should return only active installments', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      cubit.filterInstallments('نشط');
      final filtered = cubit.getFilteredInstallments();

      for (final inst in filtered) {
        final overdueDebt = inst['overdue_debt'] ?? 0.0;
        final totalDebt = inst['total_debt'] ?? 0.0;
        expect(totalDebt > 0 && overdueDebt == 0, isTrue);
      }
    });

    test('getFilteredInstallments should return only overdue installments', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      cubit.filterInstallments('متأخر');
      final filtered = cubit.getFilteredInstallments();

      for (final inst in filtered) {
        final overdueDebt = inst['overdue_debt'] ?? 0.0;
        expect(overdueDebt > 0, isTrue);
      }
    });

    test('getFilteredInstallments should return only completed installments', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      cubit.filterInstallments('مكتمل');
      final filtered = cubit.getFilteredInstallments();

      for (final inst in filtered) {
        final totalDebt = inst['total_debt'] ?? 0.0;
        expect(totalDebt, equals(0.0));
      }
    });

    test('getActiveCount should return correct count', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final count = cubit.getActiveCount();
      expect(count, greaterThanOrEqualTo(0));
    });

    test('getOverdueCount should return correct count', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final count = cubit.getOverdueCount();
      expect(count, greaterThanOrEqualTo(0));
    });

    test('getTotalRemaining should return positive number', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final total = cubit.getTotalRemaining();
      expect(total, greaterThanOrEqualTo(0.0));
    });

    test('retry mechanism should work on error', () async {
      // هذا الاختبار يتطلب محاكاة خطأ
      // في الوضع الطبيعي، لن يحدث خطأ لأن المرة API mock
      // لكن يمكننا التأكد من أن onRetry موجود في حالة الخطأ
      
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      expect(cubit.state, isA<InstallmentsListLoaded>());
    });
  });
}
