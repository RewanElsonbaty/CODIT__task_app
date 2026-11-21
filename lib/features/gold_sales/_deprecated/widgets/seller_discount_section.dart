import 'package:codit/core/localization/gold_sales_strings.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_cubit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// قسم خصم البائع (Seller Discount)
/// 
/// **المتطلبات:**
/// 1. خصم حتى 10% → مسموح مباشرة
/// 2. خصم أكثر من 10% → يحتاج موافقة
/// 3. يُطبق على الإجمالي النهائي
/// 
class SellerDiscountSection extends StatelessWidget {
  const SellerDiscountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoldSaleCubit, GoldSaleState>(
      builder: (context, state) {
        if (state is! InvoiceBuilding) return const SizedBox.shrink();

        final invoice = state.invoice;
        final hasDiscount = invoice.sellerDiscountPercent > Decimal.zero;

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
                      AppColors.successDark,
                      AppColors.successLight,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.successDark.withOpacity(0.3),
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
                        Icons.discount,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      GoldSalesStrings.sellerDiscount,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (hasDiscount)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${invoice.sellerDiscountPercent}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (hasDiscount) ...[
                      // عرض الخصم المطبق
                      _buildDiscountDisplay(invoice),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showEditDiscountDialog(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: AppColors.primary, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.edit, color: AppColors.primary),
                              label: const Text(
                                'تعديل',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _removeDiscount(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: AppColors.errorDark, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.delete, color: AppColors.errorDark),
                              label: const Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.errorDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // زر إضافة الخصم
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showEditDiscountDialog(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.successDark, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle, color: AppColors.successDark),
                          label: const Text(
                            'إضافة خصم البائع',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'خصم البائع يُطبق على الإجمالي الكلي',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiscountDisplay(invoice) {
    final discountPercent = invoice.sellerDiscountPercent.toDouble();
    final subtotal = invoice.grandTotalPiastres / 100;
    final discountAmount = subtotal * discountPercent / 100;
    final finalTotal = subtotal - discountAmount;
    final needsApproval = invoice.sellerDiscountPercent > Decimal.fromInt(10);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: needsApproval ? AppColors.warningDark : AppColors.successDark,
        ),
      ),
      child: Column(
        children: [
          if (needsApproval) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.warningDark, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'هذا الخصم يتجاوز 10٪ ويحتاج موافقة المدير',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'نسبة الخصم',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              Text(
                '$discountPercent%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'قيمة الخصم',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              Text(
                '${discountAmount.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successLight,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.successDark),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي بعد الخصم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successDark,
                ),
              ),
              Text(
                '${finalTotal.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDiscountDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<GoldSaleCubit>(),
        child: const _EditDiscountDialog(),
      ),
    );
  }

  void _removeDiscount(BuildContext context) {
    context.read<GoldSaleCubit>().updateSellerDiscount(0);
  }
}

class _EditDiscountDialog extends StatefulWidget {
  const _EditDiscountDialog();

  @override
  State<_EditDiscountDialog> createState() => _EditDiscountDialogState();
}

class _EditDiscountDialogState extends State<_EditDiscountDialog> {
  late final TextEditingController _discountController;
  bool _needsApproval = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<GoldSaleCubit>();
    final state = cubit.state;
    
    final currentDiscount = state is InvoiceBuilding
        ? state.invoice.sellerDiscountPercent.toDouble()
        : 0.0;
    
    _discountController = TextEditingController(
      text: currentDiscount > 0 ? currentDiscount.toStringAsFixed(1) : '',
    );
    _needsApproval = currentDiscount > 10;
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.successDark.withOpacity(0.3),
                        AppColors.successDark.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.discount, color: AppColors.successDark),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'خصم البائع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Discount input
            TextField(
              controller: _discountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: 'نسبة الخصم',
                suffixText: '%',
                suffixStyle: const TextStyle(
                  color: AppColors.successDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                hintText: 'مثال: 5',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.successDark),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.successDark.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.successDark, width: 2),
                ),
              ),
              onChanged: (value) {
                final discount = double.tryParse(value) ?? 0;
                setState(() {
                  _needsApproval = discount > 10;
                });
              },
            ),
            const SizedBox(height: 16),

            // Quick buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [5.0, 10.0, 15.0, 20.0].map((discount) {
                return ActionChip(
                  label: Text('$discount%'),
                  onPressed: () {
                    _discountController.text = discount.toStringAsFixed(1);
                    setState(() {
                      _needsApproval = discount > 10;
                    });
                  },
                  backgroundColor: AppColors.successSurface,
                  labelStyle: const TextStyle(
                    color: AppColors.successLight,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Warning if > 10%
            if (_needsApproval) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warningDark),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.warningDark, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'هذا الخصم يتجاوز 10٪ ويحتاج موافقة المدير قبل إتمام البيع',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Preview
            BlocBuilder<GoldSaleCubit, GoldSaleState>(
              builder: (context, state) {
                if (state is! InvoiceBuilding) return const SizedBox.shrink();

                final discount = double.tryParse(_discountController.text) ?? 0;
                final subtotal = state.invoice.grandTotalPiastres / 100;
                final discountAmount = subtotal * discount / 100;
                final finalTotal = subtotal - discountAmount;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.successDark.withOpacity(0.2),
                        AppColors.successDark.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.successDark),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي الأصلي',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          Text(
                            '${subtotal.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'قيمة الخصم',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          Text(
                            '${discountAmount.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(fontSize: 13, color: AppColors.successLight),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: AppColors.successDark),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي بعد الخصم',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successDark,
                            ),
                          ),
                          Text(
                            '${finalTotal.toStringAsFixed(2)} ج.م',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      GoldSalesStrings.cancel,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _applyDiscount,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.successDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_needsApproval ? 'تطبيق (يحتاج موافقة)' : 'تطبيق الخصم'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyDiscount() {
    final discount = double.tryParse(_discountController.text) ?? 0;

    if (discount < 0 || discount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('نسبة الخصم يجب أن تكون بين 0 و 100', textDirection: TextDirection.rtl),
          backgroundColor: AppColors.errorDark,
        ),
      );
      return;
    }

    context.read<GoldSaleCubit>().updateSellerDiscount(discount);
    Navigator.pop(context);
  }
}
