import 'package:codit/core/di/injection.dart';
import 'package:codit/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app smoke', (tester) async {
    await configureDependencies();
    await tester.pumpWidget(const CoditApp());
    await tester.pump();
    // Login screen should show login text
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
