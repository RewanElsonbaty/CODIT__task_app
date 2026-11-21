import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/notifications/domain/notification_models.dart';
import 'package:codit/features/notifications/presentation/notifications_cubit.dart';
import 'package:codit/features/notifications/presentation/widgets/notification_card.dart';
import 'package:codit/features/notifications/presentation/widgets/notification_filter_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: const _NotificationsPageContent(),
    );
  }
}

class _NotificationsPageContent extends StatelessWidget {
  const _NotificationsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.goldenNeon.withOpacity(0.3),
                    AppColors.goldenNeon.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications_active,
                color: AppColors.goldenNeon,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('الإشعارات'),
          ],
        ),
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is! NotificationsLoaded) return const SizedBox();
              
              final unreadCount = context.read<NotificationsCubit>().getUnreadCount();
              
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppColors.card,
                itemBuilder: (context) => [
                  if (unreadCount > 0)
                    PopupMenuItem(
                      value: 'mark_all_read',
                      child: Row(
                        children: [
                          const Icon(Icons.done_all, color: AppColors.successLight, size: 20),
                          const SizedBox(width: 12),
                          const Text('تعليم الكل كمقروء'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_sweep, color: AppColors.errorLight, size: 20),
                        const SizedBox(width: 12),
                        const Text('حذف الكل'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  final cubit = context.read<NotificationsCubit>();
                  if (value == 'mark_all_read') {
                    cubit.markAllAsRead();
                  } else if (value == 'clear_all') {
                    _showClearAllDialog(context, cubit);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.goldenNeon,
              ),
            );
          }

          if (state is NotificationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.errorLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationsLoaded) {
            final filteredNotifications =
                context.read<NotificationsCubit>().getFilteredNotifications();

            return Column(
              children: [
                // Filter chips
                const NotificationFilterChips(),
                
                // Statistics
                _buildStatistics(context, state),

                // Notifications list
                Expanded(
                  child: filteredNotifications.isEmpty
                      ? _buildEmptyState(context, state.filter)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              notification: filteredNotifications[index],
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, NotificationsLoaded state) {
    final total = state.notifications.length;
    final unread = context.read<NotificationsCubit>().getUnreadCount();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.infoDark.withOpacity(0.3),
            AppColors.infoDark.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.goldenNeon,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.notifications,
              label: 'الإجمالي',
              value: total.toString(),
              color: AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.border.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.mark_email_unread,
              label: 'غير مقروء',
              value: unread.toString(),
              color: AppColors.warningLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, NotificationFilter filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.goldenNeon.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: AppColors.goldenNeon,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            filter == NotificationFilter.all
                ? 'لا توجد إشعارات'
                : 'لا توجد إشعارات في هذا القسم',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم عرض الإشعارات هنا عند وصولها',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearAllDialog(
    BuildContext context,
    NotificationsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warningLight, size: 28),
            const SizedBox(width: 12),
            const Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من حذف جميع الإشعارات؟',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorDark),
            child: const Text('حذف الكل'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      cubit.clearAll();
    }
  }
}
