import 'package:codit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({super.key, required this.label, this.variant = BadgeVariant.neutral});

  final String label;
  final BadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      BadgeVariant.success => (AppColors.success.withValues(alpha: 0.15), AppColors.success),
      BadgeVariant.warning => (AppColors.warningSurface, AppColors.warning),
      BadgeVariant.error => (AppColors.error.withValues(alpha: 0.12), AppColors.error),
      BadgeVariant.neutral => (Colors.grey.shade200, Colors.grey.shade800),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

enum BadgeVariant { success, warning, error, neutral }