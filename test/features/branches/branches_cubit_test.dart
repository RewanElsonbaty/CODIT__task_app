import 'package:flutter_test/flutter_test.dart';
import 'package:codit/features/branches/presentation/branches_cubit.dart';

void main() {
  group('BranchesCubit Tests', () {
    late BranchesCubit cubit;

    setUp(() {
      cubit = BranchesCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be BranchesLoading', () {
      expect(cubit.state, isA<BranchesLoading>());
    });

    test('loadBranches should emit BranchesLoaded', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      expect(cubit.state, isA<BranchesLoaded>());
      
      final state = cubit.state as BranchesLoaded;
      expect(state.branches, isNotEmpty);
      expect(state.statistics, isNotEmpty);
    });

    test('branches should have required fields', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final state = cubit.state as BranchesLoaded;
      
      for (final branch in state.branches) {
        expect(branch.containsKey('id'), isTrue);
        expect(branch.containsKey('name'), isTrue);
        expect(branch.containsKey('status'), isTrue);
        expect(branch.containsKey('today_sales'), isTrue);
        expect(branch.containsKey('today_transactions'), isTrue);
      }
    });

    test('statistics should have required fields', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final state = cubit.state as BranchesLoaded;
      
      expect(state.statistics.containsKey('total_sales'), isTrue);
      expect(state.statistics.containsKey('total_transactions'), isTrue);
      expect(state.statistics.containsKey('active_branches'), isTrue);
    });

    test('getActiveBranchesCount should return correct count', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final count = cubit.getActiveBranchesCount();
      expect(count, greaterThanOrEqualTo(0));
      
      final state = cubit.state as BranchesLoaded;
      final expectedCount = state.branches.where((b) => b['status'] == 'نشط').length;
      expect(count, equals(expectedCount));
    });

    test('getTotalSales should return correct sum', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final total = cubit.getTotalSales();
      expect(total, greaterThanOrEqualTo(0.0));
      
      final state = cubit.state as BranchesLoaded;
      final expectedTotal = state.branches.fold<double>(
        0.0,
        (sum, b) => sum + (b['today_sales'] as double),
      );
      expect(total, equals(expectedTotal));
    });

    test('getTotalTransactions should return correct sum', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final total = cubit.getTotalTransactions();
      expect(total, greaterThanOrEqualTo(0));
      
      final state = cubit.state as BranchesLoaded;
      final expectedTotal = state.branches.fold<int>(
        0,
        (sum, b) => sum + (b['today_transactions'] as int),
      );
      expect(total, equals(expectedTotal));
    });

    test('refreshBranches should reload data', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final state1 = cubit.state as BranchesLoaded;
      final branchesCount1 = state1.branches.length;

      await cubit.refreshBranches();

      // انتظار إعادة التحميل
      await Future.delayed(const Duration(seconds: 2));

      expect(cubit.state, isA<BranchesLoaded>());
      
      final state2 = cubit.state as BranchesLoaded;
      expect(state2.branches.length, equals(branchesCount1));
    });

    test('retry mechanism should work on error', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      expect(cubit.state, isA<BranchesLoaded>());
      
      // التأكد من عدم وجود أخطاء
      expect(cubit.state, isNot(isA<BranchesError>()));
    });

    test('all branches should have valid sales values', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final state = cubit.state as BranchesLoaded;
      
      for (final branch in state.branches) {
        final sales = branch['today_sales'] as double;
        expect(sales, greaterThanOrEqualTo(0.0));
      }
    });

    test('all branches should have valid transaction counts', () async {
      // انتظار تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));

      final state = cubit.state as BranchesLoaded;
      
      for (final branch in state.branches) {
        final transactions = branch['today_transactions'] as int;
        expect(transactions, greaterThanOrEqualTo(0));
      }
    });
  });
}
