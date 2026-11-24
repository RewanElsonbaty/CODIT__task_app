import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
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
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.goldenNeon.withOpacity(0.3),
                    AppColors.goldenNeon.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
              ),
              child: Icon(
                Icons.home,
                color: AppColors.goldenNeon,
                size: ResponsiveUtils.iconSize(context),
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, factor: 1.5)),
            Text(
              'الرئيسية',
              style: TextStyle(
                fontSize: ResponsiveUtils.textSizeLarge(context),
              ),
            ),
          ],
        ),
        actions: [
          const NotificationIconButton(),
          SizedBox(width: ResponsiveUtils.spacing(context)),
          TextButton.icon(
            onPressed: () async {
              try {
                await context.read<AuthenticationCubit>().logout();
                if (context.mounted) context.go('/login');
              } catch (e) {
                ExceptionHandler.logException(e);
                if (context.mounted) {
                  ExceptionHandler.showErrorSnackBar(context, e);
                }
              }
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
              size: ResponsiveUtils.iconSize(context) * 0.8,
            ),
            label: Text(
              'خروج',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveUtils.textSizeMedium(context),
              ),
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context)),
        ],
      ),
      body: ResponsiveContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveUtils.horizontalPadding(context),
                ResponsiveUtils.verticalPadding(context),
                ResponsiveUtils.horizontalPadding(context),
                0,
              ),
              child: HomeSessionHeader(
                shopName: session.shopName ?? '',
                userName: session.userName ?? '',
              ),
            ),
            const Expanded(child: HomeMenuList()),
          ],
        ),
      ),
    );
  }
}