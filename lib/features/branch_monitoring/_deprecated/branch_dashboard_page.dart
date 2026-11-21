import 'package:codit/core/di/injection.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/features/branch_monitoring/presentation/branch_monitoring_cubit.dart';
import 'package:codit/features/branch_monitoring/presentation/widgets/branch_dashboard_body.dart';
import 'package:codit/features/branch_monitoring/presentation/widgets/branch_test_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchDashboardPage extends StatelessWidget {
  const BranchDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BranchMonitoringCubit>()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة الفروع'),
          centerTitle: true,
          elevation: 2,
          actions: [
            // Streaming indicator
            BlocBuilder<BranchMonitoringCubit, BranchMonitoringState>(
              builder: (context, state) {
                if (state.streaming) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.3, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                          onEnd: () {
                            // Restart animation
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'مباشر',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Test scenarios button
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => const BranchTestActions(),
                  isScrollControlled: true,
                );
              },
              tooltip: 'سيناريوهات الاختبار',
            ),
            // Refresh button
            BlocBuilder<BranchMonitoringCubit, BranchMonitoringState>(
              builder: (context, state) {
                return IconButton(
                  icon: state.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: state.loading
                      ? null
                      : () {
                          context.read<BranchMonitoringCubit>().refresh();
                        },
                  tooltip: 'تحديث',
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<BranchMonitoringCubit, BranchMonitoringState>(
          builder: (context, state) {
            if (state.loading && state.dashboard == null) {
              return const AppLoading();
            }
            return BranchDashboardBody(state: state);
          },
        ),
      ),
    );
  }
}