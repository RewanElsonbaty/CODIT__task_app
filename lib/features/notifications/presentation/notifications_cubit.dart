import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/notification_models.dart';

part 'notifications_cubit.freezed.dart';

/// Notifications Cubit
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState.loading()) {
    _loadNotifications();
  }

  /// Load notifications (from local storage or API)
  Future<void> _loadNotifications() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data - replace with actual API call
      final notifications = _generateMockNotifications();
      
      emit(NotificationsState.loaded(
        notifications: notifications,
        filter: NotificationFilter.all,
      ));
    } catch (e) {
      emit(NotificationsState.error(message: e.toString()));
    }
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    final updatedNotifications = currentState.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    emit(currentState.copyWith(notifications: updatedNotifications));
  }

  /// Mark all as read
  void markAllAsRead() {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    final updatedNotifications = currentState.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    emit(currentState.copyWith(notifications: updatedNotifications));
  }

  /// Delete notification
  void deleteNotification(String notificationId) {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    final updatedNotifications = currentState.notifications
        .where((n) => n.id != notificationId)
        .toList();

    emit(currentState.copyWith(notifications: updatedNotifications));
  }

  /// Clear all notifications
  void clearAll() {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    emit(currentState.copyWith(notifications: []));
  }

  /// Apply filter
  void applyFilter(NotificationFilter filter) {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    emit(currentState.copyWith(filter: filter));
  }

  /// Get filtered notifications
  List<AppNotification> getFilteredNotifications() {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return [];

    switch (currentState.filter) {
      case NotificationFilter.all:
        return currentState.notifications;
      case NotificationFilter.unread:
        return currentState.notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.approvals:
        return currentState.notifications
            .where((n) =>
                n.type == NotificationType.approvalRequest ||
                n.type == NotificationType.approvalResponse)
            .toList();
      case NotificationFilter.sales:
        return currentState.notifications
            .where((n) => n.type == NotificationType.saleCompleted)
            .toList();
      case NotificationFilter.installments:
        return currentState.notifications
            .where((n) =>
                n.type == NotificationType.installmentDue ||
                n.type == NotificationType.installmentCollected)
            .toList();
      case NotificationFilter.system:
        return currentState.notifications
            .where((n) =>
                n.type == NotificationType.systemAlert ||
                n.type == NotificationType.priceUpdate)
            .toList();
    }
  }

  /// Get unread count
  int getUnreadCount() {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return 0;

    return currentState.notifications.where((n) => !n.isRead).length;
  }

  /// Generate mock notifications for testing
  List<AppNotification> _generateMockNotifications() {
    final now = DateTime.now();
    
    return [
      AppNotification(
        id: '1',
        title: 'طلب موافقة على خصم',
        body: 'يوجد طلب موافقة على خصم 15% من محمد أحمد',
        type: NotificationType.approvalRequest,
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        data: {'approvalId': 'APR-001', 'amount': '15000'},
      ),
      AppNotification(
        id: '2',
        title: 'تمت الموافقة على طلبك',
        body: 'تمت الموافقة على طلب الخصم للعميل أحمد محمود',
        type: NotificationType.approvalResponse,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
        data: {'approvalId': 'APR-002'},
      ),
      AppNotification(
        id: '3',
        title: 'عملية بيع جديدة',
        body: 'تم إتمام عملية بيع بقيمة 25,000 ج.م',
        type: NotificationType.saleCompleted,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
        data: {'invoiceId': 'INV-12345', 'amount': '25000'},
      ),
      AppNotification(
        id: '4',
        title: 'قسط مستحق',
        body: 'قسط العميل سارة أحمد مستحق اليوم - 500 ج.م',
        type: NotificationType.installmentDue,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: false,
        data: {'customerId': 'CUST-001', 'amount': '500'},
      ),
      AppNotification(
        id: '5',
        title: 'تم تحصيل قسط',
        body: 'تم تحصيل قسط بقيمة 1,000 ج.م من العميل خالد محمد',
        type: NotificationType.installmentCollected,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
        data: {'customerId': 'CUST-002', 'amount': '1000'},
      ),
      AppNotification(
        id: '6',
        title: 'تحديث أسعار الذهب',
        body: 'تم تحديث أسعار الذهب - عيار 21: 3,800 ج.م',
        type: NotificationType.priceUpdate,
        timestamp: now.subtract(const Duration(hours: 6)),
        isRead: true,
        data: {'karat21': '3800', 'karat24': '4200'},
      ),
      AppNotification(
        id: '7',
        title: 'تنبيه النظام',
        body: 'سيتم إجراء صيانة على النظام غداً الساعة 2 صباحاً',
        type: NotificationType.systemAlert,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: false,
        data: {'maintenanceDate': '2024-01-15'},
      ),
      AppNotification(
        id: '8',
        title: 'إشعار عام',
        body: 'تم إضافة ميزات جديدة للنظام',
        type: NotificationType.general,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }
}

/// Notifications State
@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;
  
  const factory NotificationsState.loaded({
    required List<AppNotification> notifications,
    required NotificationFilter filter,
  }) = NotificationsLoaded;
  
  const factory NotificationsState.error({
    required String message,
  }) = NotificationsError;
}
