import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Notification model
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String title,
    required String body,
    required NotificationType type,
    required DateTime timestamp,
    @Default(false) bool isRead,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

/// Notification types
enum NotificationType {
  @JsonValue('approval_request')
  approvalRequest,

  @JsonValue('approval_response')
  approvalResponse,

  @JsonValue('sale_completed')
  saleCompleted,

  @JsonValue('installment_due')
  installmentDue,

  @JsonValue('installment_collected')
  installmentCollected,

  @JsonValue('price_update')
  priceUpdate,

  @JsonValue('branch_alert')
  branchAlert,

  @JsonValue('system_alert')
  systemAlert,

  @JsonValue('general')
  general;

  String get label {
    switch (this) {
      case NotificationType.approvalRequest:
        return 'طلب موافقة';
      case NotificationType.approvalResponse:
        return 'رد على الموافقة';
      case NotificationType.saleCompleted:
        return 'عملية بيع';
      case NotificationType.installmentDue:
        return 'قسط مستحق';
      case NotificationType.installmentCollected:
        return 'تحصيل قسط';
      case NotificationType.priceUpdate:
        return 'تحديث الأسعار';
      case NotificationType.branchAlert:
        return 'تنبيه فرع';
      case NotificationType.systemAlert:
        return 'تنبيه النظام';
      case NotificationType.general:
        return 'عام';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.approvalRequest:
        return Icons.approval;
      case NotificationType.approvalResponse:
        return Icons.check_circle;
      case NotificationType.saleCompleted:
        return Icons.shopping_cart;
      case NotificationType.installmentDue:
        return Icons.schedule;
      case NotificationType.installmentCollected:
        return Icons.payment;
      case NotificationType.priceUpdate:
        return Icons.trending_up;
      case NotificationType.branchAlert:
        return Icons.store;
      case NotificationType.systemAlert:
        return Icons.warning;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.approvalRequest:
        return const Color(0xFFFFC107); // warning
      case NotificationType.approvalResponse:
        return const Color(0xFF4CAF50); // success
      case NotificationType.saleCompleted:
        return const Color(0xFF2196F3); // info
      case NotificationType.installmentDue:
        return const Color(0xFFFF9800); // orange
      case NotificationType.installmentCollected:
        return const Color(0xFF4CAF50); // success
      case NotificationType.priceUpdate:
        return const Color(0xFF9C27B0); // purple
      case NotificationType.branchAlert:
        return const Color(0xFF9C27B0); // purple
      case NotificationType.systemAlert:
        return const Color(0xFFF44336); // error
      case NotificationType.general:
        return const Color(0xFF607D8B); // grey
    }
  }
}

/// Notification filter
enum NotificationFilter {
  all,
  unread,
  approvals,
  sales,
  installments,
  system;

  String get label {
    switch (this) {
      case NotificationFilter.all:
        return 'الكل';
      case NotificationFilter.unread:
        return 'غير مقروءة';
      case NotificationFilter.approvals:
        return 'الموافقات';
      case NotificationFilter.sales:
        return 'المبيعات';
      case NotificationFilter.installments:
        return 'الأقساط';
      case NotificationFilter.system:
        return 'النظام';
    }
  }
}
