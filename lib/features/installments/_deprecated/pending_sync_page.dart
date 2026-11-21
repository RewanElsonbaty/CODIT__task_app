import 'package:codit/core/di/injection.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/features/installments/presentation/pending_sync_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/pending_sync_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingSyncPage extends StatelessWidget {
  const PendingSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PendingSyncCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.card,
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
                  Icons.sync,
                  size: 24,
                  color: AppColors.goldenNeon,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'العمليات المعلقة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<PendingSyncCubit, PendingSyncState>(
          builder: (context, state) {
            if (state is PendingSyncLoading) {
              return const AppLoading();
            }
            
            if (state is PendingSyncError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.errorDark,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.errorDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PendingSyncCubit>().load(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is! PendingSyncReady) return const SizedBox.shrink();
            
            return PendingSyncBody(
              items: state.items,
              conflictItems: state.conflictItems,
            );
          },
        ),
      ),
    );
  }
}