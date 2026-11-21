import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../data/mock_auth_api.dart';
import 'widgets/logout_dialog.dart';

/// شاشة إدارة الجلسات
class SessionManagementScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> currentUser;

  const SessionManagementScreen({
    super.key,
    required this.userId,
    required this.currentUser,
  });

  @override
  State<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  final _api = MockAuthApi();
  bool _isLoading = false;

  Future<void> _logout() async {
    final confirmed = await LogoutDialog.show(context);
    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      // In real app, get session_id from storage
      const sessionId = 'current_session_id';
      await _api.logout(sessionId);

      if (mounted) {
        // Navigate to login
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الخروج بنجاح'),
            backgroundColor: AppColors.successDark,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تسجيل الخروج: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'إدارة الحساب',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Info Card
            _buildUserInfoCard(isMobile),

            const SizedBox(height: 16),

            // Session Info Card
            _buildSessionInfoCard(isMobile),

            const SizedBox(height: 16),

            // Permissions Card
            _buildPermissionsCard(isMobile),

            const SizedBox(height: 24),

            // Actions
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenNeon.withOpacity(0.1),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldenNeon.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.goldenNeon.withOpacity(0.3),
                  AppColors.goldenNeon.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: isMobile ? 48 : 64,
              color: AppColors.goldenNeon,
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            widget.currentUser['full_name'] ?? 'User',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Username
          Text(
            widget.currentUser['username'] ?? '',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary),
            ),
            child: Text(
              _getRoleDisplayName(widget.currentUser['role'] ?? ''),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfoCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldenNeon.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'معلومات الجلسة',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),

          _buildInfoRow('الفرع', widget.currentUser['branch_id'] ?? 'N/A'),
          const SizedBox(height: 12),
          _buildInfoRow('معرف المستخدم', widget.userId),
          const SizedBox(height: 12),
          _buildInfoRow(
            'وقت تسجيل الدخول',
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'الجهاز',
            'device_${DateTime.now().millisecondsSinceEpoch}',
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsCard(bool isMobile) {
    final permissions =
        widget.currentUser['permissions'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldenNeon.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'الصلاحيات',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),

          if (permissions.contains('all'))
            _buildPermissionItem('جميع الصلاحيات', true)
          else
            ...permissions.map((permission) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildPermissionItem(
                  _getPermissionDisplayName(permission.toString()),
                  true,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Change Password
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/change-password',
              arguments: widget.userId,
            );
          },
          icon: const Icon(Icons.lock_reset),
          label: const Text('تغيير كلمة المرور'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: AppColors.primary, width: 2),
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Logout
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _logout,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.logout),
          label: Text(_isLoading ? 'جاري تسجيل الخروج...' : 'تسجيل الخروج'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionItem(String permission, bool granted) {
    return Row(
      children: [
        Icon(
          granted ? Icons.check_circle : Icons.cancel,
          color: granted ? AppColors.successDark : AppColors.errorDark,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            permission,
            style: TextStyle(
              color: granted ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'مدير النظام';
      case 'branch_manager':
        return 'مدير الفرع';
      case 'cashier':
        return 'كاشير';
      default:
        return role;
    }
  }

  String _getPermissionDisplayName(String permission) {
    switch (permission) {
      case 'sales':
        return 'المبيعات';
      case 'installments':
        return 'الأقساط';
      case 'approvals':
        return 'الموافقات';
      case 'monitoring':
        return 'المراقبة';
      case 'all':
        return 'جميع الصلاحيات';
      default:
        return permission;
    }
  }
}
