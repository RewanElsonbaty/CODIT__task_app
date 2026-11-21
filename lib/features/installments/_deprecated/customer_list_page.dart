import 'package:codit/core/di/injection.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/installments/presentation/customer_list_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/customer_list_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomerListCubit>()..loadCustomers(),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  const _CustomerListView();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.people, size: 24, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'تحصيل الأقساط',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: isSmallScreen ? 16 : 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Sync Status Button - responsive
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: isSmallScreen
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/installments/sync-status');
                    },
                    icon: const Icon(Icons.sync, color: Colors.white),
                    tooltip: 'العمليات المعلقة',
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/installments/sync-status');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.infoDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text(
                      'المعلقة',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: const CustomerListBody(),
    );
  }
}
