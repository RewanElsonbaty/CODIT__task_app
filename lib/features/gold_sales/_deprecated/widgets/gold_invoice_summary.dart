import 'package:codit/core/localization/gold_sales_strings.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_cubit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoldInvoiceSummary extends StatelessWidget {
  const GoldInvoiceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoldSaleCubit, GoldSaleState>(
      builder: (context, state) {
        if (state is! InvoiceBuilding) return const SizedBox.shrink();

        final invoice = state.invoice;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.card,
                AppColors.background,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
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
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.infoDark,
                      AppColors.infoLight,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.infoDark.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calculate,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        GoldSalesStrings.invoiceSummary,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Price lock toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () => context.read<GoldSaleCubit>().togglePriceLock(),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                invoice.lockedPrices ? Icons.lock : Icons.lock_open,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                invoice.lockedPrices ? 'مقفل' : 'غير مقفل',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Summary details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      label: GoldSalesStrings.subtotal,
                      value: invoice.subtotal,
                    ),
                    if (invoice.totalDiscount > 0) ...[
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        label: GoldSalesStrings.totalDiscount,
                        value: invoice.totalDiscount,
                        valueColor: AppColors.successLight,
                        prefix: '-',
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      label: '${GoldSalesStrings.totalTax} (14%)',
                      value: (invoice.grandTotalPiastres - invoice.subtotalPiastres + invoice.totalDiscountPiastres) / 100,
                    ),
                    
                    // Seller discount
                    if (invoice.sellerDiscountPercent > Decimal.zero) ...[
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        label: '${GoldSalesStrings.sellerDiscount} (${invoice.sellerDiscountPercent}%)',
                        value: (Decimal.fromInt(invoice.grandTotalPiastres) * invoice.sellerDiscountPercent / Decimal.fromInt(100)).toDouble() / 100,
                        valueColor: AppColors.successLight,
                        prefix: '-',
                      ),
                    ],
                    
                    Divider(height: 24, thickness: 2, color: AppColors.border.withOpacity(0.3)),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.3),
                            AppColors.primary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
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
                                  color: AppColors.primary.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                GoldSalesStrings.grandTotal,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${_calculateFinalTotal(invoice).toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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
        );
      },
    );
  }

  double _calculateFinalTotal(invoice) {
    final subtotal = invoice.grandTotalPiastres / 100;
    if (invoice.sellerDiscountPercent <= Decimal.zero) {
      return subtotal;
    }
    final discountDecimal = Decimal.fromInt(invoice.grandTotalPiastres) * 
        invoice.sellerDiscountPercent / 
        Decimal.fromInt(100);
    final discountAmount = discountDecimal.toDouble() / 100;
    return subtotal - discountAmount;
  }

  Widget _buildSummaryRow({
    required String label,
    required double value,
    Color? valueColor,
    String? prefix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${prefix ?? ''}${value.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
