import 'package:codit/core/theme/app_colors.dart';
import 'package:codit/core/widgets/app_loading.dart';
import 'package:codit/features/installments/presentation/collection_form_cubit.dart';
import 'package:codit/features/installments/presentation/widgets/balance_summary_card.dart';
import 'package:codit/features/installments/presentation/widgets/debt_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/installment_models.dart';

/// نموذج توزيع المبلغ على مديونية واحدة
class DebtAllocation {
  final String debtId;
  final double debtOriginal;
  final double debtRemaining;
  final double allocatedAmount;
  final bool willBePaid;
  final double remainingAfter;

  const DebtAllocation({
    required this.debtId,
    required this.debtOriginal,
    required this.debtRemaining,
    required this.allocatedAmount,
    required this.willBePaid,
    required this.remainingAfter,
  });
}

class CollectionFormBody extends StatefulWidget {
  final CustomerDebt customer;

  const CollectionFormBody({super.key, required this.customer});

  @override
  State<CollectionFormBody> createState() => _CollectionFormBodyState();
}

class _CollectionFormBodyState extends State<CollectionFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();

  String _paymentMethod = 'cash';
  DateTime _selectedDate = DateTime.now();
  List<DebtAllocation> _allocations = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _amountController.addListener(_calculateAllocation);
  }

  @override
  void dispose() {
    _amountController.removeListener(_calculateAllocation);
    _amountController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _calculateAllocation() {
    final text = _amountController.text;
    if (text.isEmpty) {
      setState(() {
        _allocations = [];
      });
      return;
    }

    final amount = double.tryParse(text);
    if (amount == null || amount <= 0) {
      setState(() {
        _allocations = [];
      });
      return;
    }

    // نحسب التوزيع التلقائي للمبلغ على المديونيات
    setState(() {
      _allocations = _distributeAmount(amount, widget.customer.debts);
    });
  }

  List<DebtAllocation> _distributeAmount(double amount, List<Debt> debts) {
    final allocations = <DebtAllocation>[];
    var remainingAmount = amount;

    // نرتب المديونيات حسب تاريخ الاستحقاق (الأقدم أولاً)
    final sortedDebts = [...debts]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    for (final debt in sortedDebts) {
      if (remainingAmount <= 0 || debt.isPaid) {
        allocations.add(
          DebtAllocation(
            debtId: debt.id,
            debtOriginal: debt.original,
            debtRemaining: debt.remaining,
            allocatedAmount: 0,
            willBePaid: debt.isPaid,
            remainingAfter: debt.remaining,
          ),
        );
        continue;
      }

      final debtRemaining = debt.remaining;
      final allocatedToThisDebt = remainingAmount >= debtRemaining
          ? debtRemaining
          : remainingAmount;

      allocations.add(
        DebtAllocation(
          debtId: debt.id,
          debtOriginal: debt.original,
          debtRemaining: debtRemaining,
          allocatedAmount: allocatedToThisDebt,
          willBePaid: allocatedToThisDebt >= debtRemaining,
          remainingAfter: debtRemaining - allocatedToThisDebt,
        ),
      );

      remainingAmount -= allocatedToThisDebt;
    }

    return allocations;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.card,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionFormCubit, CollectionFormState>(
      builder: (context, state) {
        if (state is CollectionFormLoading) {
          return const AppLoading();
        }

        if (state is CollectionFormError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.errorDark),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: AppColors.errorDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CollectionFormCubit>().loadCustomerDebts(
                      widget.customer.customerId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is! CollectionFormReady &&
            state is! CollectionFormSubmitting) {
          return const SizedBox.shrink();
        }

        final data = state is CollectionFormReady ? state.data : {};
        final debts =
            (data['debts'] as List<dynamic>?)
                ?.map((e) => Debt.fromJson(e as Map<String, dynamic>))
                .toList() ??
            widget.customer.debts;

        final maxCollectible =
            (data['max_collectible_piastres'] as int?) ??
            widget.customer.remainingPiastres;
        final maxCollectibleEGP = maxCollectible / 100.0;

        final isSubmitting = state is CollectionFormSubmitting;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // بيانات العميل
                _buildCustomerInfoCard(),
                const SizedBox(height: 16),

                // ملخص الرصيد
                BalanceSummaryCard(
                  totalDebt: widget.customer.totalDebt,
                  paid: widget.customer.paid,
                  remaining: widget.customer.remaining,
                  maxCollectible: maxCollectibleEGP,
                ),
                const SizedBox(height: 16),

                // قائمة المديونيات
                _buildDebtsSection(debts),
                const SizedBox(height: 24),

                // نموذج التحصيل
                _buildCollectionFormCard(maxCollectibleEGP, isSubmitting),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customer.customerName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      widget.customer.phone,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtsSection(List<Debt> debts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.infoDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppColors.infoLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'المديونيات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.infoDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${debts.length} مديونية',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.infoLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...debts.map((debt) => DebtItemCard(debt: debt)),
      ],
    );
  }

  Widget _buildCollectionFormCard(double maxCollectibleEGP, bool isSubmitting) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.successDark.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.successDark, AppColors.successLight],
                  ),
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
                'بيانات التحصيل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // مبلغ التحصيل
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            enabled: !isSubmitting,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'مبلغ التحصيل',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              hintText: 'أدخل المبلغ بالجنيه',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon: const Icon(
                Icons.money,
                color: AppColors.successLight,
              ),
              suffixText: 'ج.م',
              suffixStyle: const TextStyle(
                color: AppColors.successLight,
                fontWeight: FontWeight.bold,
              ),
              helperText:
                  'الحد الأقصى: ${maxCollectibleEGP.toStringAsFixed(2)} ج.م',
              helperStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.successDark.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.successLight,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.errorDark),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال المبلغ';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'المبلغ غير صالح';
              }
              if (amount > maxCollectibleEGP) {
                return 'المبلغ يتجاوز الحد المسموح';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // معاينة توزيع التحصيل
          if (_allocations.isNotEmpty) ...[
            _buildAllocationPreview(),
            const SizedBox(height: 16),
          ],

          // طريقة الدفع
          IgnorePointer(
            ignoring: isSubmitting,
            child: DropdownButtonFormField<String>(
              value: _paymentMethod,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: AppColors.card,
              decoration: InputDecoration(
                labelText: 'طريقة الدفع',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.payment, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'cash', child: Text('نقداً')),
                DropdownMenuItem(value: 'card', child: Text('بطاقة')),
                DropdownMenuItem(value: 'transfer', child: Text('تحويل بنكي')),
                DropdownMenuItem(value: 'check', child: Text('شيك')),
              ],
              onChanged: isSubmitting
                  ? null
                  : (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
            ),
          ),
          const SizedBox(height: 16),

          // تاريخ التحصيل
          IgnorePointer(
            ignoring: isSubmitting,
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'تاريخ التحصيل',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.calendar_today,
                  color: AppColors.infoLight,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.infoLight.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.infoLight,
                    width: 2,
                  ),
                ),
              ),
              onTap: isSubmitting ? null : () => _selectDate(context),
            ),
          ),
          const SizedBox(height: 16),

          // ملاحظات
          IgnorePointer(
            ignoring: isSubmitting,
            child: TextFormField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                hintText: 'أضف أي ملاحظات إضافية...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.note,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // زر التحصيل
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : _submitCollection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successDark,
                disabledBackgroundColor: AppColors.successDark.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'تسجيل التحصيل',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationPreview() {
    final totalAllocated = _allocations.fold<double>(
      0,
      (sum, a) => sum + a.allocatedAmount,
    );
    final closedDebtsCount = _allocations
        .where((a) => a.willBePaid && !a.debtRemaining.isNegative)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.infoDark.withOpacity(0.3), AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldenNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.infoLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: AppColors.infoLight,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'معاينة التوزيع',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              if (closedDebtsCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successDark.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.successLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.successLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$closedDebtsCount مديونية ستُقفل',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.successLight,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          const Divider(color: AppColors.textSecondary, height: 1),
          const SizedBox(height: 12),

          // قائمة توزيع المديونيات
          ..._allocations.asMap().entries.map((entry) {
            final index = entry.key;
            final allocation = entry.value;

            if (allocation.allocatedAmount <= 0) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _allocations.length - 1 ? 10 : 0,
              ),
              child: _buildAllocationItem(allocation, index + 1),
            );
          }).toList(),

          const SizedBox(height: 12),
          const Divider(color: AppColors.textSecondary, height: 1),
          const SizedBox(height: 12),

          // ملخص التوزيع
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'إجمالي التحصيل:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${totalAllocated.toStringAsFixed(2)} ج.م',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.successLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationItem(DebtAllocation allocation, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: allocation.willBePaid
              ? AppColors.successLight.withOpacity(0.5)
              : AppColors.warningDark.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: allocation.willBePaid
                      ? AppColors.successDark
                      : AppColors.warningDark,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'مديونية #${allocation.debtId.substring(allocation.debtId.length - 6)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: allocation.willBePaid
                      ? AppColors.successDark.withOpacity(0.3)
                      : AppColors.warningDark.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  allocation.willBePaid ? 'ستُقفل' : 'جزئي',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: allocation.willBePaid
                        ? AppColors.successLight
                        : AppColors.warningLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المتبقي قبل:',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${allocation.debtRemaining.toStringAsFixed(2)} ج',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سيُدفع:',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${allocation.allocatedAmount.toStringAsFixed(2)} ج',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المتبقي بعد:',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${allocation.remainingAfter.toStringAsFixed(2)} ج',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: allocation.willBePaid
                            ? AppColors.successLight
                            : AppColors.warningLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitCollection() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    final amountPiastres = (amount * 100).round();

    context.read<CollectionFormCubit>().submitCollection(
      customerId: widget.customer.customerId,
      customerName: widget.customer.customerName,
      amountPiastres: amountPiastres,
      paymentMethod: _paymentMethod,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
  }
}
