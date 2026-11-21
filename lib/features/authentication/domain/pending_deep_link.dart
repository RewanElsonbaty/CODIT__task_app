class PendingDeepLink {
  PendingDeepLink._();

  static String? notificationId;
  static String? resourceId;
  static String? type;

  static void setApproval({required String id, required String notificationId}) {
    PendingDeepLink.notificationId = notificationId;
    PendingDeepLink.resourceId = id;
    type = 'approval_request';
  }

  static void clear() {
    notificationId = null;
    resourceId = null;
    type = null;
  }

  static bool get hasIntent => resourceId != null;
}