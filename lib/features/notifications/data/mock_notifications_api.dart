import 'dart:math';
import '../../../core/data/mock_api_client.dart';
import '../domain/notification_models.dart';

/// Mock Notifications API
/// 
/// يدير جميع أنواع الإشعارات في النظام
class MockNotificationsApi {
  final MockApiClient _client = MockApiClient();
  final Random _random = Random();

  // قاعدة بيانات الإشعارات
  final List<Map<String, dynamic>> _notifications = [];
  
  // عداد للإشعارات
  int _notificationCounter = 1000;

  MockNotificationsApi() {
    _initializeMockData();
  }

  /// تهيئة البيانات التجريبية
  void _initializeMockData() {
    final now = DateTime.now();
    
    _notifications.addAll([
      // إشعار طلب موافقة جديد
      {
        'id': 'notif_001',
        'title': 'طلب موافقة جديد',
        'body': 'طلب موافقة على خصم 15% من فاطمة حسن',
        'type': 'approval_request',
        'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'isRead': false,
        'data': {
          'requestId': 'req_001',
          'requestType': 'discount',
        },
        'actionUrl': '/approvals/req_001',
      },
      
      // إشعار قسط مستحق
      {
        'id': 'notif_002',
        'title': 'قسط مستحق اليوم',
        'body': 'قسط أحمد محمود - 5,000 جنيه',
        'type': 'installment_due',
        'timestamp': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'isRead': false,
        'data': {
          'customerId': 'cust_001',
          'contractId': 'cont_001',
          'amount': 5000.0,
        },
        'actionUrl': '/installments',
      },
      
      // إشعار موافقة تمت
      {
        'id': 'notif_003',
        'title': 'تمت الموافقة على طلبك',
        'body': 'تمت الموافقة على طلب الخصم #REQ-456',
        'type': 'approval_response',
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
        'isRead': true,
        'data': {
          'requestId': 'req_456',
          'approved': true,
        },
        'actionUrl': '/approvals/req_456',
      },
    ]);
    
    _notificationCounter = 1003;
  }

  /// إنشاء إشعار جديد
  Future<AppNotification> createNotification({
    required String title,
    required String body,
    required NotificationType type,
    required String userId, // المستخدم المستهدف
    Map<String, dynamic>? data,
    String? actionUrl,
  }) async {
    await _client.post(
      '/notifications',
      body: {
        'title': title,
        'body': body,
        'type': type.toJsonValue(),
        'userId': userId,
        'data': data,
        'actionUrl': actionUrl,
      },
      canFail: true,
    );

    final notificationId = 'notif_${_notificationCounter.toString().padLeft(6, '0')}';
    _notificationCounter++;

    final notification = {
      'id': notificationId,
      'title': title,
      'body': body,
      'type': type.toJsonValue(),
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
      'userId': userId,
      'data': data,
      'actionUrl': actionUrl,
    };

    _notifications.insert(0, notification); // أحدث إشعار في الأول

    return AppNotification.fromJson(notification);
  }

  /// إشعار طلب تقسيط جديد (للمالك)
  Future<AppNotification> notifyInstallmentRequestCreated({
    required String ownerId,
    required String requestNumber,
    required String customerName,
    required double amount,
    required String branchName,
    required String requestId,
  }) async {
    return createNotification(
      title: 'طلب تقسيط جديد',
      body: 'طلب $requestNumber من $branchName\n'
            'العميل: $customerName - ${amount.toStringAsFixed(0)} جنيه',
      type: NotificationType.approvalRequest,
      userId: ownerId,
      data: {
        'requestId': requestId,
        'requestNumber': requestNumber,
        'customerName': customerName,
        'amount': amount,
        'branchName': branchName,
      },
      actionUrl: '/installment-requests',
    );
  }

  /// إشعار موافقة على طلب تقسيط (للمدير)
  Future<AppNotification> notifyInstallmentRequestApproved({
    required String managerId,
    required String requestNumber,
    required String customerName,
    required String requestId,
  }) async {
    return createNotification(
      title: 'تمت الموافقة على طلب التقسيط ✓',
      body: 'طلب $requestNumber\n'
            'العميل: $customerName',
      type: NotificationType.approvalResponse,
      userId: managerId,
      data: {
        'requestId': requestId,
        'requestNumber': requestNumber,
        'approved': true,
      },
      actionUrl: '/installment-requests',
    );
  }

  /// إشعار رفض طلب تقسيط (للمدير)
  Future<AppNotification> notifyInstallmentRequestRejected({
    required String managerId,
    required String requestNumber,
    required String customerName,
    required String rejectionReason,
    required String requestId,
  }) async {
    return createNotification(
      title: 'تم رفض طلب التقسيط ✗',
      body: 'طلب $requestNumber - $customerName\n'
            'السبب: $rejectionReason',
      type: NotificationType.approvalResponse,
      userId: managerId,
      data: {
        'requestId': requestId,
        'requestNumber': requestNumber,
        'approved': false,
        'rejectionReason': rejectionReason,
      },
      actionUrl: '/installment-requests',
    );
  }

  /// إشعار موعد دفع قسط (للمالك والمدير)
  Future<List<AppNotification>> notifyInstallmentPaymentDue({
    required List<String> recipientIds, // [ownerId, managerId]
    required String customerName,
    required double amount,
    required DateTime dueDate,
    required String contractId,
  }) async {
    final notifications = <AppNotification>[];

    for (final userId in recipientIds) {
      final notification = await createNotification(
        title: 'موعد دفع قسط',
        body: 'قسط $customerName\n'
              '${amount.toStringAsFixed(0)} جنيه - ${_formatDate(dueDate)}',
        type: NotificationType.installmentDue,
        userId: userId,
        data: {
          'contractId': contractId,
          'customerName': customerName,
          'amount': amount,
          'dueDate': dueDate.toIso8601String(),
        },
        actionUrl: '/installments',
      );
      notifications.add(notification);
    }

    return notifications;
  }

  /// إشعار تحصيل قسط (للمالك والمدير)
  Future<List<AppNotification>> notifyInstallmentCollected({
    required List<String> recipientIds,
    required String customerName,
    required double amount,
    required String contractId,
  }) async {
    final notifications = <AppNotification>[];

    for (final userId in recipientIds) {
      final notification = await createNotification(
        title: 'تم تحصيل قسط ✓',
        body: 'تم تحصيل قسط $customerName\n'
              '${amount.toStringAsFixed(0)} جنيه',
        type: NotificationType.installmentCollected,
        userId: userId,
        data: {
          'contractId': contractId,
          'customerName': customerName,
          'amount': amount,
        },
        actionUrl: '/installments',
      );
      notifications.add(notification);
    }

    return notifications;
  }

  /// إشعار قسط متأخر (للمالك والمدير)
  Future<List<AppNotification>> notifyInstallmentOverdue({
    required List<String> recipientIds,
    required String customerName,
    required double amount,
    required int daysOverdue,
    required String contractId,
  }) async {
    final notifications = <AppNotification>[];

    for (final userId in recipientIds) {
      final notification = await createNotification(
        title: 'قسط متأخر ⚠️',
        body: 'قسط $customerName متأخر $daysOverdue يوم\n'
              '${amount.toStringAsFixed(0)} جنيه',
        type: NotificationType.systemAlert,
        userId: userId,
        data: {
          'contractId': contractId,
          'customerName': customerName,
          'amount': amount,
          'daysOverdue': daysOverdue,
        },
        actionUrl: '/installments',
      );
      notifications.add(notification);
    }

    return notifications;
  }

  /// إشعار موافقة عامة (للموافقات العادية)
  Future<AppNotification> notifyApprovalRequest({
    required String userId,
    required String title,
    required String body,
    required String requestId,
  }) async {
    return createNotification(
      title: title,
      body: body,
      type: NotificationType.approvalRequest,
      userId: userId,
      data: {'requestId': requestId},
      actionUrl: '/approvals/$requestId',
    );
  }

  /// إشعار رد موافقة عامة
  Future<AppNotification> notifyApprovalResponse({
    required String userId,
    required String title,
    required String body,
    required bool approved,
    required String requestId,
  }) async {
    return createNotification(
      title: title,
      body: body,
      type: NotificationType.approvalResponse,
      userId: userId,
      data: {
        'requestId': requestId,
        'approved': approved,
      },
      actionUrl: '/approvals/$requestId',
    );
  }

  /// الحصول على جميع إشعارات مستخدم
  Future<List<AppNotification>> getUserNotifications(String userId) async {
    await _client.get('/notifications/user/$userId');

    final userNotifications = _notifications
        .where((n) => n['userId'] == userId || n['userId'] == null) // null = للجميع
        .toList();

    return userNotifications.map((n) => AppNotification.fromJson(n)).toList();
  }

  /// الحصول على الإشعارات غير المقروءة
  Future<List<AppNotification>> getUnreadNotifications(String userId) async {
    await _client.get('/notifications/user/$userId/unread');

    final unread = _notifications
        .where((n) => 
            (n['userId'] == userId || n['userId'] == null) &&
            n['isRead'] == false)
        .toList();

    return unread.map((n) => AppNotification.fromJson(n)).toList();
  }

  /// عدد الإشعارات غير المقروءة
  Future<int> getUnreadCount(String userId) async {
    await _client.get('/notifications/user/$userId/unread/count');

    return _notifications
        .where((n) => 
            (n['userId'] == userId || n['userId'] == null) &&
            n['isRead'] == false)
        .length;
  }

  /// وضع علامة مقروء على إشعار
  Future<void> markAsRead(String notificationId) async {
    await _client.patch(
      '/notifications/$notificationId/read',
      body: {'isRead': true},
    );

    final notification = _notifications.firstWhere(
      (n) => n['id'] == notificationId,
      orElse: () => throw Exception('الإشعار غير موجود'),
    );

    notification['isRead'] = true;
  }

  /// وضع علامة مقروء على جميع إشعارات مستخدم
  Future<void> markAllAsRead(String userId) async {
    await _client.patch(
      '/notifications/user/$userId/read-all',
      body: {'isRead': true},
    );

    for (final notification in _notifications) {
      if (notification['userId'] == userId || notification['userId'] == null) {
        notification['isRead'] = true;
      }
    }
  }

  /// حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    await _client.delete('/notifications/$notificationId');

    _notifications.removeWhere((n) => n['id'] == notificationId);
  }

  /// حذف جميع إشعارات مستخدم
  Future<void> deleteAllUserNotifications(String userId) async {
    await _client.delete('/notifications/user/$userId');

    _notifications.removeWhere((n) => n['userId'] == userId);
  }

  /// مسح البيانات (للاختبار)
  void clearData() {
    _notifications.clear();
    _notificationCounter = 1000;
    _initializeMockData();
  }

  /// تنسيق التاريخ
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
