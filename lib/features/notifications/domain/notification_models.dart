import 'package:flutter/material.dart';

/// Notification model
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
    this.imageUrl,
    this.actionUrl,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.fromJsonValue(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toJsonValue(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
    };
  }
}

/// Notification types
enum NotificationType {
  approvalRequest,
  approvalResponse,
  saleCompleted,
  installmentDue,
  installmentCollected,
  priceUpdate,
  branchAlert,
  systemAlert,
  general;

  String toJsonValue() {
    switch (this) {
      case NotificationType.approvalRequest:
        return 'approval_request';
      case NotificationType.approvalResponse:
        return 'approval_response';
      case NotificationType.saleCompleted:
        return 'sale_completed';
      case NotificationType.installmentDue:
        return 'installment_due';
      case NotificationType.installmentCollected:
        return 'installment_collected';
      case NotificationType.priceUpdate:
        return 'price_update';
      case NotificationType.branchAlert:
        return 'branch_alert';
      case NotificationType.systemAlert:
        return 'system_alert';
      case NotificationType.general:
        return 'general';
    }
  }

  static NotificationType fromJsonValue(String value) {
    switch (value) {
      case 'approval_request':
        return NotificationType.approvalRequest;
      case 'approval_response':
        return NotificationType.approvalResponse;
      case 'sale_completed':
        return NotificationType.saleCompleted;
      case 'installment_due':
        return NotificationType.installmentDue;
      case 'installment_collected':
        return NotificationType.installmentCollected;
      case 'price_update':
        return NotificationType.priceUpdate;
      case 'branch_alert':
        return NotificationType.branchAlert;
      case 'system_alert':
        return NotificationType.systemAlert;
      default:
        return NotificationType.general;
    }
  }

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
