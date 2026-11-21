import 'package:codit/features/branch_monitoring/presentation/branch_monitoring_cubit.dart';
import 'package:codit/features/branch_monitoring/presentation/widgets/branch_offline_banner.dart';
import 'package:codit/features/branch_monitoring/presentation/widgets/branch_selector_field.dart';
import 'package:codit/features/branch_monitoring/presentation/widgets/dashboard_metrics_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchDashboardBody extends StatelessWidget {
  const BranchDashboardBody({super.key, required this.state});

  final BranchMonitoringState state;

  @override
  Widget build(BuildContext context) {
    final payload = state.dashboard?.payload;
    
    return Column(
      children: [
        if (state.offline) BranchOfflineBanner(lastUpdate: state.lastUpdate),
        
        BranchSelectorField(
          branchId: state.branchId,
          branches: state.branches,
          onChanged: (id) => context.read<BranchMonitoringCubit>().selectBranch(id),
        ),
        
        if (state.error != null)
          Expanded(
            child: _buildErrorState(context, state.error!),
          )
        else if (payload != null)
          Expanded(
            child: DashboardMetricsList(
              payload: payload,
              lastUpdate: state.lastUpdate,
            ),
          )
        else
          Expanded(
            child: _buildEmptyState(),
          ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BranchMonitoringCubit>().refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد بيانات',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اختر فرعًا لعرض البيانات',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}