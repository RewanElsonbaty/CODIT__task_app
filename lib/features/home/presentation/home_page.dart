import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/utils/responsive_utils.dart';
import 'package:codit/core/utils/exception_handler.dart';
import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/features/auth/domain/models/auth_models.dart';

/// الصفحة الرئيسية - Responsive وClean Architecture
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Extract user info
        AuthUser? user;
        List<String> permissions = [];
        
        if (state is AuthAuthenticated) {
          user = state.user;
          permissions = user.permissions;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context, user),
          body: _buildBody(context, user, permissions),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AuthUser? user) {
    return AppBar(
      backgroundColor: AppColors.card,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 0.75)),
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
          Flexible(
            child: Text(
              'الرئيسية',
              style: TextStyle(
                fontSize: ResponsiveUtils.textSizeLarge(context),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            size: ResponsiveUtils.iconSize(context),
          ),
          onPressed: () => context.go('/notifications'),
          tooltip: 'الإشعارات',
        ),
        IconButton(
          icon: Icon(
            Icons.logout,
            size: ResponsiveUtils.iconSize(context),
          ),
          onPressed: () => _handleLogout(context),
          tooltip: 'تسجيل الخروج',
        ),
        SizedBox(width: ResponsiveUtils.spacing(context)),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AuthUser? user, List<String> permissions) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ResponsiveContainer(
          padding: EdgeInsets.all(ResponsiveUtils.horizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 2)),
              
              // User info header
              _buildUserHeader(context, user),
              
              SizedBox(height: ResponsiveUtils.spacing(context, factor: 3)),
              
              // Menu items based on permissions
              _buildMenuItems(context, permissions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, AuthUser? user) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenNeon.withOpacity(0.1),
            AppColors.card.withOpacity(0.5),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 2),
        border: Border.all(
          color: AppColors.goldenNeon.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: ResponsiveUtils.valueWhen(
              context: context,
              mobile: 32,
              tablet: 40,
              desktop: 48,
            ),
            backgroundColor: AppColors.goldenNeon.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: ResponsiveUtils.valueWhen(
                context: context,
                mobile: 32,
                tablet: 40,
                desktop: 48,
              ),
              color: AppColors.goldenNeon,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context)),
          Text(
            'مرحباً ${user?.name ?? "Guest"}',
            style: TextStyle(
              fontSize: ResponsiveUtils.textSizeLarge(context) * 1.2,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.5)),
          Text(
            user?.roles.firstOrNull ?? 'User',
            style: TextStyle(
              fontSize: ResponsiveUtils.textSizeMedium(context),
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, List<String> permissions) {
    // Helper to check permission
    bool hasPermission(String permission) {
      return permissions.contains('all') || permissions.contains(permission);
    }

    final menuItems = <_MenuItem>[];

    // Admin Dashboard (Owner only)
    if (hasPermission('all')) {
      menuItems.add(_MenuItem(
        title: 'لوحة تحكم المالك',
        subtitle: 'Owner Dashboard',
        icon: Icons.admin_panel_settings,
        route: '/admin',
        color: AppColors.goldenNeon,
      ));
    }

    // Manager Dashboard
    if (hasPermission('staff_management') || hasPermission('approvals')) {
      menuItems.add(_MenuItem(
        title: 'لوحة تحكم المدير',
        subtitle: 'Manager Dashboard',
        icon: Icons.supervisor_account,
        route: '/manager',
        color: AppColors.accent,
      ));
    }

    // Gold Sales
    if (hasPermission('gold_sales') || hasPermission('gold_pos')) {
      menuItems.add(_MenuItem(
        title: 'بيع الذهب',
        subtitle: 'Gold POS',
        icon: Icons.diamond,
        route: '/gold',
        color: AppColors.goldenNeon,
      ));
    }

    // Approvals
    if (hasPermission('approvals') || hasPermission('approval_management')) {
      menuItems.add(_MenuItem(
        title: 'الموافقات',
        subtitle: 'Approvals',
        icon: Icons.approval,
        route: '/approvals',
        color: AppColors.info,
      ));
    }

    // Installments
    if (hasPermission('installments') || hasPermission('payments') || hasPermission('installments_pos')) {
      menuItems.add(_MenuItem(
        title: 'الأقساط',
        subtitle: 'Installments',
        icon: Icons.payment,
        route: '/installments',
        color: AppColors.success,
      ));
    }

    // Branches
    if (hasPermission('branches') || hasPermission('monitoring')) {
      menuItems.add(_MenuItem(
        title: 'مراقبة الفروع',
        subtitle: 'Branch Monitoring',
        icon: Icons.business,
        route: '/branches',
        color: AppColors.warning,
      ));
    }

    // Notifications (all users)
    menuItems.add(_MenuItem(
      title: 'الإشعارات',
      subtitle: 'Notifications',
      icon: Icons.notifications,
      route: '/notifications',
      color: AppColors.primary,
    ));

    return Column(
      children: menuItems.map((item) => _buildMenuItem(context, item)).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, factor: 1.5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 1.5),
        border: Border.all(
          color: item.color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 1.5),
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context) * 1.5),
          onTap: () => context.go(item.route),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 2)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveUtils.spacing(context, factor: 1.5)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        item.color.withOpacity(0.2),
                        item.color.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context)),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: ResponsiveUtils.iconSize(context) * 1.2,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.spacing(context, factor: 2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.textSizeMedium(context) * 1.1,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, factor: 0.25)),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.textSizeSmall(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: item.color.withOpacity(0.5),
                  size: ResponsiveUtils.iconSize(context) * 0.7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    try {
      await context.read<AuthCubit>().logout();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      ExceptionHandler.logException(e);
      if (context.mounted) {
        ExceptionHandler.showErrorSnackBar(context, e);
      }
    }
  }
}

/// Menu item model
class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;

  _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });
}
