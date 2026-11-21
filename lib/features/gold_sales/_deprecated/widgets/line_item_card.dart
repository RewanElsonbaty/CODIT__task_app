import 'package:codit/core/localization/gold_sales_strings.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/gold_sales/domain/gold_sale_models.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decimal/decimal.dart';

enum ProductStatus {
  available,
  sold,
  reserved,
  workshop,
  transit,
}

extension ProductStatusExtension on ProductStatus {
  String get label {
    switch (this) {
      case ProductStatus.available:
        return 'متاح';
      case ProductStatus.sold:
        return 'مباع';
      case ProductStatus.reserved:
        return 'محجوز';
      case ProductStatus.workshop:
        return 'في الورشة';
      case ProductStatus.transit:
        return 'في الطريق';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductStatus.available:
        return Icons.check_circle;
      case ProductStatus.sold:
        return Icons.block;
      case ProductStatus.reserved:
        return Icons.bookmark;
      case ProductStatus.workshop:
        return Icons.construction;
      case ProductStatus.transit:
        return Icons.local_shipping;
    }
  }

  Color get color {
    switch (this) {
      case ProductStatus.available:
        return AppColors.successLight;
      case ProductStatus.sold:
        return AppColors.errorLight;
      case ProductStatus.reserved:
        return AppColors.warningLight;
      case ProductStatus.workshop:
        return AppColors.infoLight;
      case ProductStatus.transit:
        return Colors.orange;
    }
  }

  bool get isBlocked => this != ProductStatus.available;
}

class LineItemCard extends StatelessWidget {
  const LineItemCard({
    super.key,
    required this.item,
    required this.index,
    this.status = ProductStatus.available,
  });

  final InvoiceLineItem item;
  final int index;
  final ProductStatus status;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppColors.card,
              AppColors.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.goldenNeon,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldenGlow.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Item number badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.grade, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'عيار ${item.karat}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            if (status.isBlocked) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: status.color.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: status.color),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(status.icon, size: 12, color: status.color),
                                    const SizedBox(width: 4),
                                    Text(
                                      status.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: status.color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    tooltip: GoldSalesStrings.remove,
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Weight info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.scale,
                          label: GoldSalesStrings.weight,
                          value: '${item.weight.toStringAsFixed(3)} ${GoldSalesStrings.gram}',
                        ),
                        Divider(height: 16, color: AppColors.border.withOpacity(0.3)),
                        _buildDetailRow(
                          icon: Icons.auto_awesome,
                          label: GoldSalesStrings.stonesWeight,
                          value: '${item.stonesWeight.toStringAsFixed(3)} ${GoldSalesStrings.gram}',
                        ),
                        Divider(height: 16, color: AppColors.border.withOpacity(0.3)),
                        _buildDetailRow(
                          icon: Icons.balance,
                          label: GoldSalesStrings.netWeight,
                          value: '${(item.netMg / 1000).toStringAsFixed(3)} ${GoldSalesStrings.gram}',
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pricing details
                  _buildDetailRow(
                    icon: Icons.payments,
                    label: GoldSalesStrings.goldPrice,
                    value: '${item.goldPricePerGram.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.build_circle,
                    label: GoldSalesStrings.workmanship,
                    value: item.workmanshipPerGram
                        ? '${(item.workmanshipPerGramPiastres / 100).toStringAsFixed(2)} ${GoldSalesStrings.egp}/${GoldSalesStrings.gram}'
                        : '${(item.fixedWorkmanshipPiastres / 100).toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                  ),
                  if (item.discountPercent > Decimal.zero) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      icon: Icons.local_offer,
                      label: GoldSalesStrings.discount,
                      value: '${item.discountPercent}${GoldSalesStrings.percent}',
                      valueColor: AppColors.successLight,
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Calculated values
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.infoDark.withOpacity(0.3),
                          AppColors.infoDark.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.infoLight.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.monetization_on,
                          label: 'قيمة الذهب',
                          value: '${(item.goldValuePiastres / 100).toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                        ),
                        Divider(height: 16, color: AppColors.border.withOpacity(0.3)),
                        _buildDetailRow(
                          icon: Icons.construction,
                          label: 'قيمة المصنعية',
                          value: '${(item.workmanshipPiastres / 100).toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                        ),
                        if (item.discountPiastres > 0) ...[
                          Divider(height: 16, color: AppColors.border.withOpacity(0.3)),
                          _buildDetailRow(
                            icon: Icons.discount,
                            label: 'الخصم',
                            value: '${(item.discountPiastres / 100).toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                            valueColor: AppColors.successLight,
                          ),
                        ],
                        Divider(height: 16, color: AppColors.border.withOpacity(0.3)),
                        _buildDetailRow(
                          icon: Icons.account_balance,
                          label: GoldSalesStrings.tax,
                          value: '${(item.taxPiastres / 100).toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Total
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.receipt_long,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              GoldSalesStrings.lineTotal,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${item.totalPrice.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: highlight ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (highlight ? AppColors.primary : Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warningLight, size: 28),
            SizedBox(width: 12),
            Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          GoldSalesStrings.confirmRemoveItem,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(GoldSalesStrings.cancel, style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.errorDark),
            child: const Text(GoldSalesStrings.remove),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<GoldSaleCubit>().removeLineItem(index);
    }
  }
}
