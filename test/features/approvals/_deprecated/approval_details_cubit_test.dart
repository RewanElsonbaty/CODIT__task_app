import 'package:bloc_test/bloc_test.dart';
import 'package:codit/features/approvals/data/approval_repository.dart';
import 'package:codit/features/approvals/domain/approval_models.dart';
import 'package:codit/features/approvals/presentation/approval_details_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApprovalRepository extends Mock implements ApprovalRepository {}

class FakeApprovalDecision extends Fake implements ApprovalDecision {}

void main() {
  late ApprovalDetailsCubit cubit;
  late MockApprovalRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeApprovalDecision());
  });

  setUp(() {
    repository = MockApprovalRepository();
    cubit = ApprovalDetailsCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('Approval Details Cubit Tests', () {
    final testApproval = ApprovalDetail(
      id: 'APR-123',
      requestNumber: 'REQ-2024-001',
      version: 1,
      employeeId: 'EMP-001',
      employeeName: 'أحمد محمد',
      branchId: 'BR-001',
      branchName: 'الفرع الرئيسي',
      amountPiastres: 50000, // 500 جنيه
      reason: 'عميل دائم',
      operationDetails: {'discount_percent': 15},
      createdAt: DateTime(2024, 1, 1),
      status: ApprovalStatus.pending,
    );

    test('الحالة الابتدائية', () {
      expect(cubit.state, isA<ApprovalDetailsInitial>());
    });

    blocTest<ApprovalDetailsCubit, ApprovalDetailsState>(
      'تحميل تفاصيل الموافقة بنجاح',
      build: () {
        when(() => repository.fetchApprovalDetail('APR-123'))
            .thenAnswer((_) async => testApproval);
        return cubit;
      },
      act: (cubit) => cubit.loadApproval('APR-123'),
      expect: () => [
        isA<ApprovalDetailsLoading>(),
        isA<ApprovalDetailsLoaded>()
            .having((s) => s.approval.id, 'approval.id', 'APR-123')
            .having((s) => s.approval.employeeName, 'approval.employeeName', 'أحمد محمد'),
      ],
      verify: (_) {
        verify(() => repository.fetchApprovalDetail('APR-123')).called(1);
      },
    );

    blocTest<ApprovalDetailsCubit, ApprovalDetailsState>(
      'فشل تحميل الموافقة مع retry (3 محاولات)',
      build: () {
        when(() => repository.fetchApprovalDetail('APR-123'))
            .thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => cubit.loadApproval('APR-123'),
      // سيحاول 3 مرات + الأولى = 4 loading states
      wait: const Duration(seconds: 15), // الانتظار للـ retries
      verify: (_) {
        // التحقق من 4 محاولات (1 أصلية + 3 retries)
        verify(() => repository.fetchApprovalDetail('APR-123')).called(4);
      },
    );

    blocTest<ApprovalDetailsCubit, ApprovalDetailsState>(
      'الموافقة على الطلب بنجاح',
      build: () {
        when(() => repository.refreshApprovalDetail('APR-123'))
            .thenAnswer((_) async => testApproval);
        when(() => repository.sendDecision(any()))
            .thenAnswer((_) async => testApproval.copyWith(status: ApprovalStatus.approved));
        return cubit;
      },
      seed: () => ApprovalDetailsLoaded(approval: testApproval),
      act: (cubit) => cubit.approve(),
      expect: () => [
        isA<ApprovalDetailsLoaded>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ApprovalDetailsDecisionSent>()
            .having((s) => s.wasApproved, 'wasApproved', true),
      ],
      verify: (_) {
        verify(() => repository.sendDecision(any())).called(1);
      },
    );

    blocTest<ApprovalDetailsCubit, ApprovalDetailsState>(
      'رفض الطلب بنجاح',
      build: () {
        when(() => repository.refreshApprovalDetail('APR-123'))
            .thenAnswer((_) async => testApproval);
        when(() => repository.sendDecision(any()))
            .thenAnswer((_) async => testApproval.copyWith(status: ApprovalStatus.rejected));
        return cubit;
      },
      seed: () => ApprovalDetailsLoaded(approval: testApproval),
      act: (cubit) => cubit.reject('غير مناسب'),
      expect: () => [
        isA<ApprovalDetailsLoaded>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ApprovalDetailsDecisionSent>()
            .having((s) => s.wasApproved, 'wasApproved', false),
      ],
      verify: (_) {
        verify(() => repository.sendDecision(any())).called(1);
      },
    );

    blocTest<ApprovalDetailsCubit, ApprovalDetailsState>(
      'معالجة النتيجة غير المؤكدة (UnknownDecisionException)',
      build: () {
        when(() => repository.refreshApprovalDetail('APR-123'))
            .thenAnswer((_) async => testApproval);
        when(() => repository.sendDecision(any()))
            .thenThrow(UnknownDecisionException('الاتصال انقطع'));
        return cubit;
      },
      seed: () => ApprovalDetailsLoaded(approval: testApproval),
      act: (cubit) => cubit.approve(),
      expect: () => [
        isA<ApprovalDetailsLoaded>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ApprovalDetailsUnknownResult>()
            .having((s) => s.message, 'message', contains('الاتصال انقطع')),
      ],
    );

    blocTest<ApprovalDetailsCubit, ApprovalDetailsState>(
      'refresh: تحديث التفاصيل',
      build: () {
        when(() => repository.fetchApprovalDetail('APR-123'))
            .thenAnswer((_) async => testApproval);
        return cubit;
      },
      seed: () => ApprovalDetailsLoaded(approval: testApproval),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<ApprovalDetailsLoading>(),
        isA<ApprovalDetailsLoaded>(),
      ],
      verify: (_) {
        verify(() => repository.fetchApprovalDetail('APR-123')).called(1);
      },
    );
  });
}
