import 'package:flutter_test/flutter_test.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';

void main() {
  group('Utils Import Test', () {
    test('ResponsiveUtils should be accessible', () {
      expect(ResponsiveUtils.mobileBreakpoint, 600);
      expect(ResponsiveUtils.tabletBreakpoint, 900);
      expect(ResponsiveUtils.desktopBreakpoint, 1200);
    });

    test('ExceptionHandler should be accessible', () {
      expect(ExceptionHandler.getErrorMessage('test'), isNotEmpty);
    });
  });
}
