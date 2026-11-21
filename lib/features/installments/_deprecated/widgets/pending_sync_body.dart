import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/widgets/app_empty_state.dart';
import 'package:codit/features/installments/data/installment_repository.dart';
import 'package:codit/features/installments/domain/installment_models.dart';
import 'package:codit/features/installments/presentation/conflict_resolution_dialog.dart';
import 'package:codit/features/installments/presentation/pending_sync_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/pending_collection_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingSyncBody extends StatelessWidget {
  const PendingSyncBody({
    super.key,
    required this.items,
    this.conflictItems = const [],
  });

  final List<Collection> items;
  final List<Collection> conflictItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sync button and count
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.read<PendingSyncCubit>().retrySync(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.sync, size: 20),
                  label: const Text(
                    'مزامنة الآن',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (items.isNotEmpty || conflictItems.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warningDark,
                        AppColors.warningLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${items.length + conflictItems.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'معلقة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Conflicts section
        if (conflictItems.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.errorDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.errorDark.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.errorDark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: AppColors.errorDark,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تعارضات تحتاج حل',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.errorDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${conflictItems.length} عملية تحتاج مراجعة وحل تعارض',
                        style: TextStyle(
                          color: AppColors.errorDark.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...conflictItems.map((collection) => _buildConflictTile(context, collection)),
          if (items.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Divider(color: AppColors.textSecondary),
            ),
          ],
        ],

        // Regular pending items
        if (items.isEmpty && conflictItems.isEmpty)
          const Expanded(
            child: AppEmptyState(
              icon: Icons.check_circle_outline,
              title: 'جميع العمليات متزامنة!',
              message: 'لا توجد عمليات معلقة في الوقت الحالي',
            ),
          )
        else if (items.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, i) => PendingCollectionTile(
                collection: items[i],
              ),
            ),
          )
        else
          const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  Widget _buildConflictTile(
    BuildContext context,
    Collection collection,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.card,
            AppColors.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.errorDark.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.errorDark.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning,
            color: AppColors.errorDark,
            size: 24,
          ),
        ),
        title: Text(
          collection.customerName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${(collection.amountPiastres / 100.0).toStringAsFixed(2)} ج.م',
              style: const TextStyle(
                color: AppColors.errorDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'تعارض - يحتاج حل',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.errorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showConflictDialog(context, collection),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'حل التعارض',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showConflictDialog(BuildContext context, Collection collection) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConflictResolutionDialog(
        collection: collection,
        onResolve: (resolution) {
          final action = _mapResolution(resolution);
          context.read<PendingSyncCubit>().resolveConflict(collection.id, action);
        },
      ),
    );
  }

  ConflictResolutionAction _mapResolution(ConflictResolution resolution) {
    switch (resolution) {
      case ConflictResolution.retry:
        return ConflictResolutionAction.retry;
      case ConflictResolution.discardLocal:
        return ConflictResolutionAction.discardLocal;
      case ConflictResolution.reviewLater:
        return ConflictResolutionAction.reviewLater;
    }
  }
}