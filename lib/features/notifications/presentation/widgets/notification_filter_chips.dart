import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/notifications/domain/notification_models.dart';
import 'package:codit/features/notifications/presentation/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is! NotificationsLoaded) return const SizedBox();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: NotificationFilter.values.map((filter) {
                final isSelected = state.filter == filter;
                
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    label: Text(filter.label),
                    selected: isSelected,
                    onSelected: (_) {
                      context.read<NotificationsCubit>().applyFilter(filter);
                    },
                    backgroundColor: AppColors.card,
                    selectedColor: AppColors.goldenNeon.withOpacity(0.3),
                    checkmarkColor: AppColors.goldenNeon,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.goldenNeon : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.goldenNeon : AppColors.border.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
