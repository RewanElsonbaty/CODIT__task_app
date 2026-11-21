import 'package:codit/core/localization/gold_sales_strings.dart';
import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/features/gold_sales/domain/gold_sale_models.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoldSaleCubit, GoldSaleState>(
      builder: (context, state) {
        if (state is! InvoiceBuilding) return const SizedBox.shrink();

        final invoice = state.invoice;
        final remaining = invoice.remainingPiastres / 100;

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
              color: AppColors.successDark.withOpacity(0.3),
              width: 2,
            ),
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
                        Icons.payments,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      GoldSalesStrings.paymentMethods,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Payment status
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: remaining > 0
                            ? AppColors.warningSurface
                            : remaining < 0
                                ? AppColors.errorSurface
                                : AppColors.successSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: remaining > 0
                              ? AppColors.warningDark
                              : remaining < 0
                                  ? AppColors.errorDark
                                  : AppColors.successDark,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                remaining == 0
                                    ? Icons.check_circle
                                    : remaining > 0
                                        ? Icons.pending
                                        : Icons.error,
                                color: remaining > 0
                                    ? AppColors.warningDark
                                    : remaining < 0
                                        ? AppColors.errorDark
                                        : AppColors.successDark,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                GoldSalesStrings.remaining,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: remaining > 0
                                      ? AppColors.warningLight
                                      : remaining < 0
                                          ? AppColors.errorLight
                                          : AppColors.successLight,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${remaining.abs().toStringAsFixed(2)} ${GoldSalesStrings.egp}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: remaining > 0
                                  ? AppColors.warningLight
                                  : remaining < 0
                                      ? AppColors.errorLight
                                      : AppColors.successLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment list
                    if (invoice.payments.isNotEmpty) ...[
                      ...invoice.payments.asMap().entries.map((entry) {
                        return _PaymentTile(
                          payment: entry.value,
                          index: entry.key,
                        );
                      }),
                      const SizedBox(height: 12),
                    ],

                    // Add payment button
                    if (remaining > 0)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddPaymentDialog(context, remaining),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.primary, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle, color: AppColors.primary),
                          label: const Text(
                            GoldSalesStrings.addPayment,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
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

  Future<void> _showAddPaymentDialog(BuildContext context, double remaining) async {
    await showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<GoldSaleCubit>(),
        child: _AddPaymentDialog(maxAmount: remaining),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.payment,
    required this.index,
  });

  final PaymentLine payment;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getPaymentIcon(payment.method),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPaymentMethodName(payment.method),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (payment.reference != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    payment.reference!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${payment.amount.toStringAsFixed(2)} ${GoldSalesStrings.egp}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.errorLight,
            tooltip: GoldSalesStrings.remove,
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.payments;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.transfer:
        return Icons.account_balance;
      case PaymentMethod.check:
        return Icons.receipt;
    }
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return GoldSalesStrings.cash;
      case PaymentMethod.card:
        return GoldSalesStrings.card;
      case PaymentMethod.transfer:
        return GoldSalesStrings.transfer;
      case PaymentMethod.check:
        return GoldSalesStrings.check;
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          GoldSalesStrings.confirmRemovePayment,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              GoldSalesStrings.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
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
      context.read<GoldSaleCubit>().removePayment(index);
    }
  }
}

class _AddPaymentDialog extends StatefulWidget {
  const _AddPaymentDialog({required this.maxAmount});

  final double maxAmount;

  @override
  State<_AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<_AddPaymentDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _referenceController;
  PaymentMethod _selectedMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.maxAmount.toStringAsFixed(2),
    );
    _referenceController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
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
                        AppColors.primary.withOpacity(0.3),
                        AppColors.primary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.payments, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    GoldSalesStrings.addPayment,
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

            // Payment method selection
            const Text(
              'طريقة الدفع',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PaymentMethod.values.map((method) {
                final isSelected = _selectedMethod == method;
                return ChoiceChip(
                  label: Text(_getMethodName(method)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedMethod = method);
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: GoldSalesStrings.amount,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                suffixText: GoldSalesStrings.egp,
                suffixStyle: const TextStyle(color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                helperText: 'المتبقي: ${widget.maxAmount.toStringAsFixed(2)} ج',
                helperStyle: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),

            // Reference (optional)
            TextField(
              controller: _referenceController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: GoldSalesStrings.reference,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                hintText: 'اختياري',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
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
                    onPressed: _addPayment,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
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
    );
  }

  String _getMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return GoldSalesStrings.cash;
      case PaymentMethod.card:
        return GoldSalesStrings.card;
      case PaymentMethod.transfer:
        return GoldSalesStrings.transfer;
      case PaymentMethod.check:
        return GoldSalesStrings.check;
    }
  }

  void _addPayment() {
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      _showError(GoldSalesStrings.invalidPrice);
      return;
    }

    if (amount > widget.maxAmount) {
      _showError(GoldSalesStrings.paymentExceedsTotal);
      return;
    }

    final cubit = context.read<GoldSaleCubit>();
    cubit.addPayment(
      amount: amount,
      method: _selectedMethod,
      reference: _referenceController.text.trim().isEmpty
          ? null
          : _referenceController.text.trim(),
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        backgroundColor: AppColors.errorDark,
      ),
    );
  }
}
