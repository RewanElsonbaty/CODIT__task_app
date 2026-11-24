import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// لوحة تحكم المدير - فقط للـ admin
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المالك'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.goldenNeon,
                    AppColors.goldenNeon.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.admin_panel_settings, size: 48, color: Colors.black),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً مالك النظام',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'الوصول الكامل لكل شيء - أنت المالك',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // القسم 1: العمليات
            _buildSectionTitle('💼 العمليات'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.shopping_cart,
                  title: 'بيع الذهب',
                  subtitle: 'Gold POS',
                  color: AppColors.goldenNeon,
                  onTap: () => context.go('/gold'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.approval,
                  title: 'الموافقات',
                  subtitle: 'Approvals',
                  color: Colors.blue,
                  onTap: () => context.go('/approvals'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.payment,
                  title: 'الأقساط',
                  subtitle: 'Installments',
                  color: Colors.green,
                  onTap: () => context.go('/installments'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.business,
                  title: 'الفروع',
                  subtitle: 'Branches',
                  color: Colors.purple,
                  onTap: () => context.go('/branches'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // القسم 2: التقارير والإحصائيات (خاص بالمدير)
            _buildSectionTitle('📊 التقارير والإحصائيات'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.people,
                  title: 'تقارير الموظفين',
                  subtitle: 'Staff Reports',
                  color: Colors.orange,
                  onTap: () => context.go('/admin/staff-reports'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.analytics,
                  title: 'تحليلات المبيعات',
                  subtitle: 'Sales Analytics',
                  color: Colors.teal,
                  onTap: () => context.go('/admin/sales-analytics'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.trending_up,
                  title: 'الأداء اليومي',
                  subtitle: 'Daily Performance',
                  color: Colors.indigo,
                  onTap: () => context.go('/admin/daily-performance'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.inventory,
                  title: 'جرد المخزون',
                  subtitle: 'Inventory',
                  color: Colors.brown,
                  onTap: () => context.go('/admin/inventory'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // القسم 3: الإدارة (خاص بالمدير)
            _buildSectionTitle('⚙️ الإدارة والإعدادات'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.person_add,
                  title: 'إدارة المستخدمين',
                  subtitle: 'User Management',
                  color: Colors.red,
                  onTap: () => context.go('/admin/users'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.security,
                  title: 'الصلاحيات',
                  subtitle: 'Permissions',
                  color: Colors.deepOrange,
                  onTap: () => context.go('/admin/permissions'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.settings,
                  title: 'الإعدادات',
                  subtitle: 'Settings',
                  color: Colors.blueGrey,
                  onTap: () => context.go('/admin/settings'),
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.history,
                  title: 'سجل الأنشطة',
                  subtitle: 'Activity Log',
                  color: Colors.cyan,
                  onTap: () => context.go('/admin/activity-log'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Stats
            _buildSectionTitle('📈 إحصائيات سريعة'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'المبيعات اليوم',
                    '125,000 ج.م',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'الموظفين النشطين',
                    '12 موظف',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'العمليات اليوم',
                    '45 عملية',
                    Icons.shopping_bag,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'الأقساط المستحقة',
                    '8 قسط',
                    Icons.schedule,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
