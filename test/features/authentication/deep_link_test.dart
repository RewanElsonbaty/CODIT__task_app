import 'package:codit/core/deep_linking/deep_link_handler.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

// Mocks
class MockAuthenticationCubit extends Mock implements AuthenticationCubit {}
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late DeepLinkHandler handler;
  late MockAuthenticationCubit mockAuthCubit;
  late MockGoRouter mockRouter;

  setUp(() {
    mockAuthCubit = MockAuthenticationCubit();
    mockRouter = MockGoRouter();
    handler = DeepLinkHandler(mockAuthCubit);
  });

  group('DeepLinkHandler - Pending Links', () {
    test('يحفظ pending link عند محاولة الوصول بدون تسجيل دخول', () async {
      // Arrange
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());

      // Act
      await handler.handleLink('codit://approval/123', mockRouter);

      // Assert - لا يحاول التوجيه لأن المستخدم غير مسجل دخول
      verifyNever(() => mockRouter.go(any()));
    });

    test('يتعامل مع pending link بعد تسجيل الدخول', () {
      // Arrange - حفظ pending link أولاً
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());
      handler.handleLink('codit://approval/123', mockRouter);

      // Act - تسجيل الدخول ثم معالجة pending link
      handler.handlePendingLink(mockRouter);

      // Assert - الآن يتم التوجيه
      verify(() => mockRouter.go('/approvals/123')).called(1);
    });

    test('يمسح pending link', () {
      // Arrange
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());
      handler.handleLink('codit://approval/123', mockRouter);

      // Act
      handler.clearPending();
      handler.handlePendingLink(mockRouter);

      // Assert - لا يتم التوجيه بعد المسح
      verifyNever(() => mockRouter.go(any()));
    });

    test('يتعامل مع pending link مرة واحدة فقط', () {
      // Arrange
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());
      handler.handleLink('codit://approval/123', mockRouter);

      // Act - استدعاء handlePendingLink مرتين
      handler.handlePendingLink(mockRouter);
      handler.handlePendingLink(mockRouter);

      // Assert - التوجيه يحدث مرة واحدة فقط
      verify(() => mockRouter.go('/approvals/123')).called(1);
    });
  });

  group('DeepLinkHandler - Link Parsing', () {
    test('يحلل approval deep link بشكل صحيح', () async {
      // Arrange
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());

      // Act
      await handler.handleLink('codit://approval/abc-123', mockRouter);

      // الـ handler يحفظ الـ link لأن المستخدم غير مسجل دخول
      handler.handlePendingLink(mockRouter);

      // Assert
      verify(() => mockRouter.go('/approvals/abc-123')).called(1);
    });

    test('يتجاهل deep links بصيغة غير معروفة', () async {
      // Arrange
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());

      // Act
      await handler.handleLink('codit://unknown/path', mockRouter);
      handler.handlePendingLink(mockRouter);

      // Assert - لا يتم التوجيه للروابط غير المعروفة
      verifyNever(() => mockRouter.go(any()));
    });
  });
}
