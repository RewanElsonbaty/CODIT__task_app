import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/theme/app_text_styles.dart';

/// أنواع الحالات المتاحة
enum StatusType {
  success,
  error,
  warning,
  info,
  pending,
}

/// Badge لعرض الحالات المختلفة
/// 
/// مثال:
/// ```dart
/// StatusBadge(
///   label: 'تمت الموافقة',
///   type: StatusType.success,
/// )
/// ```
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.icon,
    this.size = StatusBadgeSize.medium,
  });

  final String label;
  final StatusType type;
  final IconData? icon;
  final StatusBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final padding = _getPadding();
    final fontSize = _getFontSize();
    
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(size == StatusBadgeSize.small ? 6 : 8),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2,
              color: colors.foreground,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.badge.copyWith(
              color: colors.foreground,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
  
  _StatusColors _getColors() {
    return switch (type) {
      StatusType.success => const _StatusColors(
          background: AppColors.successSurface,
          foreground: AppColors.success,
          border: AppColors.successLight,
        ),
      StatusType.error => const _StatusColors(
          background: AppColors.errorSurface,
          foreground: AppColors.error,
          border: AppColors.errorLight,
        ),
      StatusType.warning => const _StatusColors(
          background: AppColors.warningSurface,
          foreground: AppColors.warning,
          border: AppColors.warningLight,
        ),
      StatusType.info => const _StatusColors(
          background: AppColors.infoSurface,
          foreground: AppColors.info,
          border: AppColors.infoLight,
        ),
      StatusType.pending => const _StatusColors(
          background: AppColors.pendingSurface,
          foreground: AppColors.pending,
          border: AppColors.pendingLight,
        ),
    };
  }
  
  EdgeInsets _getPadding() {
    return switch (size) {
      StatusBadgeSize.small => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      StatusBadgeSize.medium => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      StatusBadgeSize.large => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    };
  }
  
  double _getFontSize() {
    return switch (size) {
      StatusBadgeSize.small => 10,
      StatusBadgeSize.medium => 11,
      StatusBadgeSize.large => 12,
    };
  }
}

enum StatusBadgeSize {
  small,
  medium,
  large,
}

class _StatusColors {
  const _StatusColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
  
  final Color background;
  final Color foreground;
  final Color border;
}
