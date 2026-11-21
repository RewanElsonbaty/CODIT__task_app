import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/auth_models.dart';

/// Service for handling push notifications and deep linking
/// 
/// This service:
/// - Requests notification permissions
/// - Handles foreground, background, and terminated state notifications
/// - Prevents duplicate navigation from the same notification
/// - Extracts notification payload for deep linking
class NotificationService {
  final FirebaseMessaging _messaging;
  
  // Track opened notifications to prevent duplicates
  final Set<String> _openedNotificationIds = {};
  
  // Stream controller for notification payloads
  final _notificationController =
      StreamController<NotificationPayload>.broadcast();

  /// Stream of notification payloads for deep linking
  Stream<NotificationPayload> get onNotificationTap =>
      _notificationController.stream;

  NotificationService(this._messaging);

  /// Initialize notification service
  /// 
  /// This should be called early in app initialization, ideally before
  /// showing the UI.
  Future<void> initialize() async {
    try {
      debugPrint('[Notifications] Initializing...');

      // Request permission
      final settings = await _requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('[Notifications] Permission denied');
        return;
      }

      debugPrint('[Notifications] Permission granted');

      // Get FCM token
      final token = await _getFcmToken();
      if (token != null) {
        debugPrint('[Notifications] FCM Token obtained (not logged for security)');
        // TODO: Send token to server
      }

      // Handle different notification states
      _setupForegroundHandler();
      _setupBackgroundHandler();
      await _handleInitialMessage();

      debugPrint('[Notifications] Initialization complete');
    } catch (e) {
      debugPrint('[Notifications] Initialization error: $e');
    }
  }

  /// Request notification permission
  Future<NotificationSettings> _requestPermission() async {
    return await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Get FCM token
  Future<String?> _getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('[Notifications] Error getting FCM token: $e');
      return null;
    }
  }

  /// Setup handler for foreground messages
  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[Notifications] Foreground message received');
      debugPrint('[Notifications] Title: ${message.notification?.title}');
      debugPrint('[Notifications] Body: ${message.notification?.body}');
      
      // Show local notification (optional)
      // For now, we'll just log it
      _logNotificationData(message.data);
    });
  }

  /// Setup handler for background/terminated messages that are tapped
  void _setupBackgroundHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[Notifications] Background message opened');
      _handleNotificationTap(message);
    });
  }

  /// Handle initial message when app is opened from terminated state
  Future<void> _handleInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[Notifications] Initial message found (app opened from notification)');
      _handleNotificationTap(initialMessage);
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    final notificationId = message.messageId ?? '';
    
    // Check if this notification was already opened
    if (_openedNotificationIds.contains(notificationId)) {
      debugPrint('[Notifications] Notification already opened: $notificationId');
      return;
    }

    // Mark as opened
    _openedNotificationIds.add(notificationId);
    
    // Extract payload
    final payload = _extractPayload(message);
    if (payload != null) {
      debugPrint('[Notifications] Emitting payload: ${payload.type} - ${payload.id}');
      _notificationController.add(payload);
    } else {
      debugPrint('[Notifications] Could not extract payload from message');
    }
  }

  /// Extract notification payload from message
  NotificationPayload? _extractPayload(RemoteMessage message) {
    try {
      final data = message.data;
      
      // Extract type and id from notification data
      final type = data['type'] as String?;
      final id = data['id'] as String?;
      
      if (type == null || id == null) {
        debugPrint('[Notifications] Missing type or id in notification data');
        return null;
      }

      return NotificationPayload(
        type: type,
        id: id,
        data: data,
      );
    } catch (e) {
      debugPrint('[Notifications] Error extracting payload: $e');
      return null;
    }
  }

  /// Log notification data (for debugging)
  void _logNotificationData(Map<String, dynamic> data) {
    debugPrint('[Notifications] Data:');
    data.forEach((key, value) {
      debugPrint('  $key: $value');
    });
  }

  /// Clear opened notifications tracking (e.g., on logout)
  void clearOpenedNotifications() {
    debugPrint('[Notifications] Clearing opened notifications tracking');
    _openedNotificationIds.clear();
  }

  /// Dispose resources
  void dispose() {
    _notificationController.close();
  }
}

/// Top-level function for handling background messages
/// 
/// This must be a top-level function, not a class method.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[Notifications] Background message handler called');
  debugPrint('[Notifications] Message ID: ${message.messageId}');
  // Additional background processing can be done here
}
