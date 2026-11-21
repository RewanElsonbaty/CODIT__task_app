import 'package:codit/core/localization/gold_sales_strings.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/gold_sales/domain/gold_sale_calculator.dart';
import 'package:codit/features/gold_sales/domain/gold_sale_models.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_cubit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// قسم البدل (Trade-in/Exchange)
/// 
/// **الحساب:**
/// 1. الوزن الصافي = الوزن القائم - وزن الفصوص
/// 2. الوزن بعد الخصم = الوزن الصافي × (1 - نسبة الخصم)
/// 3. قيمة البدل = الوزن بعد الخصم × سعر الشراء
/// 4. يُطرح من إجمالي الفاتورة
/// 
class ExchangeSection extends StatelessWidget {
  const ExchangeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoldSaleCubit, GoldSaleState>(
      builder: (context, state) {
        if (state is! InvoiceBuilding) return const SizedBox.shrink();

        final invoice = state.invoice;
        final hasExchange = invoice.payments.any(
          (p) => p.exchangeWeightMg != null,
        );

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
                      AppColors.warningDark,
                      AppColors.warningLight,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warningDark.withOpacity(0.3),
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
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      GoldSalesStrings.exchange,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (hasExchange)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'مضاف',
                          style: TextStyle(
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
                    if (hasExchange) ...[
                      // عرض البدل المضاف
                      _buildExchangeDisplay(context, invoice),
                      const SizedBox(height: 12),
                      // زر الحذف
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _removeExchange(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.errorDark, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete, color: AppColors.errorDark),
                          label: const Text(
                            'حذف البدل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.errorDark,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // زر إضافة البدل
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddExchangeDialog(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.warningDark, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle, color: AppColors.warningDark),
                          label: const Text(
                            'إضافة بدل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.warningDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'قيمة البدل تُطرح من الإجمالي',
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

  Widget _buildExchangeDisplay(BuildContext context, GoldSaleInvoice invoice) {
    final exchangePayment = invoice.payments.firstWhere(
      (p) => p.exchangeWeightMg != null,
    );

    final weightGrams = exchangePayment.exchangeWeightMg! / 1000;
    final pricePerGram = exchangePayment.exchangePricePerGramPiastres! / 100;
    final totalValue = exchangePayment.amountPiastres / 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningDark),
      ),
      child: Column(
        children: [
          _buildInfoRow('الوزن', '${weightGrams.toStringAsFixed(3)} ${GoldSalesStrings.gram}'),
          const SizedBox(height: 8),
          _buildInfoRow('سعر الشراء', '${pricePerGram.toStringAsFixed(2)} ${GoldSalesStrings.egp}'),
          const Divider(height: 24, color: AppColors.warningDark),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'قيمة البدل',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warningDark,
                ),
              ),
              Text(
                '${totalValue.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warningDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddExchangeDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<GoldSaleCubit>(),
        child: const _AddExchangeDialog(),
      ),
    );
  }

  void _removeExchange(BuildContext context) {
    final cubit = context.read<GoldSaleCubit>();
    final state = cubit.state;
    
    if (state is! InvoiceBuilding) return;

    // البحث عن index الدفعة اللي فيها البدل
    final index = state.invoice.payments.indexWhere(
      (p) => p.exchangeWeightMg != null,
    );

    if (index != -1) {
      cubit.removePayment(index);
    }
  }
}

class _AddExchangeDialog extends StatefulWidget {
  const _AddExchangeDialog();

  @override
  State<_AddExchangeDialog> createState() => _AddExchangeDialogState();
}

class _AddExchangeDialogState extends State<_AddExchangeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _grossWeightController;
  late final TextEditingController _stoneWeightController;
  late final TextEditingController _buyPriceController;
  late final TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _grossWeightController = TextEditingController();
    _stoneWeightController = TextEditingController(text: '0');
    _buyPriceController = TextEditingController();
    _discountController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _grossWeightController.dispose();
    _stoneWeightController.dispose();
    _buyPriceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                            AppColors.warningDark.withOpacity(0.3),
                            AppColors.warningDark.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.swap_horiz, color: AppColors.warningDark),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'إضافة بدل',
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

                // Gross weight
                _buildTextField(
                  controller: _grossWeightController,
                  label: 'الوزن القائم (جرام)',
                  hint: 'مثال: 15.500',
                ),
                const SizedBox(height: 16),

                // Stone weight
                _buildTextField(
                  controller: _stoneWeightController,
                  label: 'وزن الفصوص (جرام)',
                  hint: 'اختياري',
                ),
                const SizedBox(height: 16),

                // Buy price
                _buildTextField(
                  controller: _buyPriceController,
                  label: 'سعر الشراء للجرام (جنيه)',
                  hint: 'مثال: 3800',
                ),
                const SizedBox(height: 16),

                // Discount
                _buildTextField(
                  controller: _discountController,
                  label: 'خصم الوزن (%)',
                  hint: 'اختياري - يُطبق على الوزن',
                ),
                const SizedBox(height: 8),
                
                // شرح الخصم
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.infoSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.infoDark, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'خصم الوزن يُطبق قبل حساب القيمة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Preview calculation
                _buildPreview(),
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
                        onPressed: _addExchange,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.warningDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(GoldSalesStrings.add),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
      ],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.warningDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.warningDark.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.warningDark, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        final num = double.tryParse(value);
        if (num == null || num < 0) {
          return 'يجب إدخال رقم صحيح';
        }
        return null;
      },
      onChanged: (_) => setState(() {}), // Refresh preview
    );
  }

  Widget _buildPreview() {
    final grossWeight = double.tryParse(_grossWeightController.text) ?? 0;
    final stoneWeight = double.tryParse(_stoneWeightController.text) ?? 0;
    final buyPrice = double.tryParse(_buyPriceController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;

    if (grossWeight <= 0 || buyPrice <= 0) {
      return const SizedBox.shrink();
    }

    // حساب باستخدام الـ Calculator
    try {
      final input = ExchangeInput(
        grossMg: (grossWeight * 1000).round(),
        stoneMg: (stoneWeight * 1000).round(),
        buyPricePerGramPiastres: (buyPrice * 100).round(),
        discountPercent: Decimal.parse(discount.toString()),
      );

      final result = GoldSaleCalculator.calculateExchange(input);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.warningDark.withOpacity(0.2),
              AppColors.warningDark.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warningDark),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الوزن الصافي',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                Text(
                  '${(result.netMg / 1000).toStringAsFixed(3)} جرام',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
            if (discount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'خصم الوزن',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  Text(
                    '${(result.discountMg / 1000).toStringAsFixed(3)} جرام',
                    style: const TextStyle(fontSize: 13, color: AppColors.successLight),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الوزن بعد الخصم',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  Text(
                    '${(result.netAfterDiscountMg / 1000).toStringAsFixed(3)} جرام',
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ],
            const Divider(height: 24, color: AppColors.warningDark),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'قيمة البدل',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warningDark,
                  ),
                ),
                Text(
                  '${(result.exchangeValuePiastres / 100).toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warningDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'خطأ في الحساب: $e',
          style: const TextStyle(fontSize: 12, color: AppColors.errorLight),
        ),
      );
    }
  }

  void _addExchange() {
    if (!_formKey.currentState!.validate()) return;

    final grossWeight = double.parse(_grossWeightController.text);
    final stoneWeight = double.tryParse(_stoneWeightController.text) ?? 0;
    final buyPrice = double.parse(_buyPriceController.text);
    final discount = double.tryParse(_discountController.text) ?? 0;

    try {
      // حساب قيمة البدل
      final input = ExchangeInput(
        grossMg: (grossWeight * 1000).round(),
        stoneMg: (stoneWeight * 1000).round(),
        buyPricePerGramPiastres: (buyPrice * 100).round(),
        discountPercent: Decimal.parse(discount.toString()),
      );

      final result = GoldSaleCalculator.calculateExchange(input);

      // إضافة كـ payment
      final cubit = context.read<GoldSaleCubit>();
      cubit.addExchangePayment(
        exchangeWeightMg: result.netAfterDiscountMg,
        exchangePricePerGramPiastres: (buyPrice * 100).round(),
        exchangeValuePiastres: result.exchangeValuePiastres,
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $e', textDirection: TextDirection.rtl),
          backgroundColor: AppColors.errorDark,
        ),
      );
    }
  }
}
