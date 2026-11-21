import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/notifications/domain/notification_models.dart';
import 'package:codit/features/notifications/presentation/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.errorDark,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        context.read<NotificationsCubit>().deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم حذف الإشعار', textDirection: TextDirection.rtl),
            backgroundColor: AppColors.successDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.card,
              AppColors.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? AppColors.border.withOpacity(0.3)
                : AppColors.goldenNeon,
            width: notification.isRead ? 1 : 2,
          ),
          boxShadow: notification.isRead
              ? []
              : [
                  BoxShadow(
                    color: AppColors.goldenGlow.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _handleNotificationTap(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              notification.type.color.withOpacity(0.3),
                              notification.type.color.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          notification.type.icon,
                          color: notification.type.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Type & Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  notification.type.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: notification.type.color,
                                  ),
                                ),
                                if (!notification.isRead) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.goldenNeon,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.goldenGlow.withOpacity(0.5),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatTimestamp(notification.timestamp),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // More menu
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: AppColors.card,
                        itemBuilder: (context) => [
                          if (!notification.isRead)
                            PopupMenuItem(
                              value: 'mark_read',
                              child: Row(
                                children: [
                                  const Icon(Icons.done, color: AppColors.successLight, size: 18),
                                  const SizedBox(width: 12),
                                  const Text('تعليم كمقروء', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete, color: AppColors.errorLight, size: 18),
                                const SizedBox(width: 12),
                                const Text('حذف', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          final cubit = context.read<NotificationsCubit>();
                          if (value == 'mark_read') {
                            cubit.markAsRead(notification.id);
                          } else if (value == 'delete') {
                            cubit.deleteNotification(notification.id);
                          }
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Body
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 14,
                      color: notification.isRead
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  
                  // Image (if available)
                  if (notification.imageUrl != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        notification.imageUrl!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                  ],
                  
                  // Action button (if available)
                  if (notification.actionUrl != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _handleAction(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: notification.type.color),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(Icons.arrow_back, size: 18, color: notification.type.color),
                        label: Text(
                          'عرض التفاصيل',
                          style: TextStyle(
                            color: notification.type.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context) {
    // Mark as read
    if (!notification.isRead) {
      context.read<NotificationsCubit>().markAsRead(notification.id);
    }
    
    // Handle navigation based on type
    _handleAction(context);
  }

  void _handleAction(BuildContext context) {
    // TODO: Implement navigation based on notification type and data
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'فتح ${notification.type.label}',
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: notification.type.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return timeago.format(timestamp, locale: 'ar');
  }
}
