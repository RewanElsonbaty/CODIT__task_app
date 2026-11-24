import 'package:flutter/material.dart';

/// Responsive Layout System
/// للتعامل مع الموبايل والتابلت بشكل احترافي
class ResponsiveUtils {
  /// Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check Device Type
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Get Responsive Value
  static T valueWhen<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Get Screen Width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get Screen Height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get Horizontal Padding
  static double horizontalPadding(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
  }

  /// Get Vertical Padding
  static double verticalPadding(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  /// Get Card Width
  static double cardWidth(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: width(context) - 32,
      tablet: width(context) * 0.8,
      desktop: 600.0,
    );
  }

  /// Get Grid Columns
  static int gridColumns(BuildContext context) {
    return valueWhen(context: context, mobile: 2, tablet: 3, desktop: 4);
  }

  /// Get Font Scale
  static double fontScale(BuildContext context) {
    return valueWhen(context: context, mobile: 1.0, tablet: 1.1, desktop: 1.2);
  }

  /// Get Spacing (for old code compatibility)
  static double spacing(BuildContext context, {double factor = 1.0}) {
    return valueWhen(
      context: context,
      mobile: 8.0 * factor,
      tablet: 12.0 * factor,
      desktop: 16.0 * factor,
    );
  }

  /// Get Radius
  static double radius(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
  }

  /// Icon Size
  static double iconSize(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  /// Button Height
  static double buttonHeight(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
    );
  }

  /// Text Size helpers
  static double textSizeSmall(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 12.0,
      tablet: 13.0,
      desktop: 14.0,
    );
  }

  static double textSizeMedium(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );
  }

  static double textSizeLarge(BuildContext context) {
    return valueWhen(
      context: context,
      mobile: 16.0,
      tablet: 18.0,
      desktop: 20.0,
    );
  }
}

/// Responsive Widget Builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isMobile) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile =
            constraints.maxWidth < ResponsiveUtils.mobileBreakpoint;
        return builder(context, isMobile);
      },
    );
  }
}

/// Responsive Container
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? ResponsiveUtils.cardWidth(context),
      ),
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.horizontalPadding(context),
            vertical: ResponsiveUtils.verticalPadding(context),
          ),
      margin: margin,
      child: child,
    );
  }
}

/// Responsive Row/Column
class ResponsiveLayout extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const ResponsiveLayout({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: children,
      );
    }
  }
}
