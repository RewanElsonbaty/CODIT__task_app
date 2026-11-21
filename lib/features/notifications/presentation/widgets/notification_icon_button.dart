import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/notifications/presentation/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final unreadCount = state is NotificationsLoaded
              ? context.read<NotificationsCubit>().getUnreadCount()
              : 0;

          return Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: unreadCount > 0 ? AppColors.goldenNeon : Colors.white,
                ),
                onPressed: () => context.push('/notifications'),
                tooltip: 'الإشعارات',
              ),
              if (unreadCount > 0)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.goldenNeon,
                          AppColors.goldenGlow,
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldenGlow.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
