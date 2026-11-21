import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/home/presentation/widgets/home_menu_list.dart';
import 'package:codit/features/home/presentation/widgets/home_session_header.dart';
import 'package:codit/features/notifications/presentation/widgets/notification_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthenticationCubit>().session;
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
                Icons.home,
                color: AppColors.goldenNeon,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('الرئيسية'),
          ],
        ),
        actions: [
          const NotificationIconButton(),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () async {
              await context.read<AuthenticationCubit>().logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            label: const Text('خروج', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: HomeSessionHeader(
              shopName: session.shopName ?? '',
              userName: session.userName ?? '',
            ),
          ),
          const Expanded(child: HomeMenuList()),
        ],
      ),
    );
  }
}