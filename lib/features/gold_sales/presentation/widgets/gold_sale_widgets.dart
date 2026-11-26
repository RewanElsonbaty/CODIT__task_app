import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/gold_models.dart';
import '../gold_sale_cubit.dart';
import 'progressive_add_gold_dialog.dart';

/// الهيدر - رقم الفاتورة والتاريخ
class InvoiceHeader extends StatelessWidget {
  final GoldInvoice invoice;

  const InvoiceHeader({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'رقم الفاتورة',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#${invoice.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                    color: AppColors.goldenNeon,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'التاريخ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(invoice.createdAt),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// قسم البحث عن المنتج
class ProductSearchSection extends StatefulWidget {
  final bool enabled;

  const ProductSearchSection({super.key, this.enabled = true});

  @override
  State<ProductSearchSection> createState() => _ProductSearchSectionState();
}

class _ProductSearchSectionState extends State<ProductSearchSection> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.2),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'إضافة قطعة',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // زر فتح Dialog البحث المتقدم
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.enabled
                  ? () => _showAdvancedSearchDialog(context)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('اختيار من القطع المتاحة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenNeon,
                foregroundColor: Colors.black,
                disabledBackgroundColor: AppColors.border,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'أو',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  enabled: widget.enabled,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'كود القطعة أو الباركود',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(
                      Icons.qr_code,
                      color: AppColors.primary,
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
                        color: AppColors.border.withOpacity(0.3),
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
                  onSubmitted: widget.enabled
                      ? (value) {
                          if (value.isNotEmpty) {
                            // TODO: Search and add product by code
                            _codeController.clear();
                          }
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: widget.enabled
                    ? () {
                        // TODO: Open barcode scanner
                      }
                    : null,
                icon: const Icon(Icons.qr_code_scanner),
                color: AppColors.goldenNeon,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showAdvancedSearchDialog(BuildContext context) async {
    // جلب القطع من API
    final cubit = context.read<GoldSaleCubit>();
    
    // عرض loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldenNeon),
        ),
      ),
    );
    
    try {
      // جلب جميع القطع المتاحة من API
      final products = await cubit.fetchAvailableProducts();
      
      if (!context.mounted) return;
      
      // إغلاق loading
      Navigator.of(context).pop();
      
      if (products.isEmpty) {
        // عرض رسالة عدم وجود قطع متاحة
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('لا توجد قطع متاحة حالياً'),
                ),
              ],
            ),
            backgroundColor: AppColors.warningDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      
      // فتح dialog الاختيار المتقدم
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => ProgressiveAddGoldDialog(
          availableProducts: products,
          onAddItem: (product, quantity) {
            // TODO: Get current gold price from API or settings
            // هنا يجب جلب سعر الذهب الحالي من إعدادات النظام
            final goldPricePerGram = 3500; // مثال: 3500 جنيه للجرام
            
            // إضافة كل قطعة على حدة
            for (int i = 0; i < quantity; i++) {
              cubit.addProduct(
                product: product,
                pricePerGramPiastres: goldPricePerGram * 100, // تحويل لقرش
                makingChargeType: MakingChargeType.perGram,
                makingChargePerGramPiastres: 5000, // 50 جنيه مصنعية للجرام
              );
            }
          },
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      
      // إغلاق loading إذا كان مفتوح
      Navigator.of(context).pop();
      
      // عرض رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('خطأ في الاتصال: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: AppColors.errorDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

/// قائمة الأصناف
class LineItemsList extends StatelessWidget {
  final List<InvoiceLineItem> lineItems;
  final bool enabled;

  const LineItemsList({
    super.key,
    required this.lineItems,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (lineItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لم يتم إضافة أي قطع بعد',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.successDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.list_alt,
                color: AppColors.successLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'الأصناف (${lineItems.length}/2)',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...lineItems.map((item) => _LineItemCard(item: item, enabled: enabled)),
      ],
    );
  }
}

class _LineItemCard extends StatelessWidget {
  final InvoiceLineItem item;
  final bool enabled;

  const _LineItemCard({required this.item, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.card, AppColors.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldenNeon, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الاسم والحذف
          Row(
            children: [
              Expanded(
                child: Text(
                  item.product.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (enabled)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.errorDark,
                  onPressed: () {
                    context.read<GoldSaleCubit>().removeProduct(item.id);
                  },
                ),
            ],
          ),

          const SizedBox(height: 12),

          // التفاصيل
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildDetail(
                'الوزن',
                '${item.product.netWeightGrams.toStringAsFixed(3)} جم',
              ),
              _buildDetail('العيار', item.product.karat.displayName),
              _buildDetail(
                'السعر',
                '${item.pricePerGram.toStringAsFixed(2)} ج',
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),

          // الحسابات
          _buildCalculation('قيمة الذهب', item.goldValue),
          _buildCalculation('المصنعية', item.makingCharge),
          _buildCalculation(
            'الخصم',
            -item.discount,
            color: AppColors.errorDark,
          ),
          _buildCalculation('الضريبة', item.tax),

          const SizedBox(height: 8),
          const Divider(color: AppColors.goldenNeon, height: 1, thickness: 2),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${item.total.toStringAsFixed(2)} ج.م',
                style: const TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculation(String label, double value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} ج.م',
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// قسم البدل
class TradeInSection extends StatelessWidget {
  final TradeInItem? tradeIn;
  final bool enabled;

  const TradeInSection({super.key, this.tradeIn, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tradeIn != null
              ? AppColors.infoDark
              : AppColors.border.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
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
                  Icons.swap_horiz,
                  color: AppColors.infoLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'البدل',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (tradeIn != null && enabled)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: AppColors.errorDark,
                  onPressed: () {
                    context.read<GoldSaleCubit>().removeTradeIn();
                  },
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (tradeIn == null)
            TextButton.icon(
              onPressed: enabled
                  ? () {
                      _showAddTradeInDialog(context);
                    }
                  : null,
              icon: const Icon(Icons.add),
              label: const Text('إضافة بدل'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الوزن',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${tradeIn!.weightGrams.toStringAsFixed(3)} جم',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'سعر الشراء',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${tradeIn!.buyBackPricePerGram.toStringAsFixed(2)} ج/جم',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.border),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'قيمة البدل',
                      style: TextStyle(
                        color: AppColors.infoLight,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${tradeIn!.value.toStringAsFixed(2)} ج.م',
                      style: const TextStyle(
                        color: AppColors.infoLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showAddTradeInDialog(BuildContext context) {
    final weightController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        title: const Text(
          'إضافة بدل',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'الوزن (جرام)',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                suffixText: 'جم',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'سعر الشراء للجرام',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                suffixText: 'ج.م',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final weight = double.tryParse(weightController.text);
              final price = double.tryParse(priceController.text);

              if (weight != null && price != null && weight > 0 && price > 0) {
                context.read<GoldSaleCubit>().addTradeIn(
                  weightMg: (weight * 1000).round(),
                  discountPercentage: 0,
                  buyBackPricePerGramPiastres: (price * 100).round(),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

/// ملخص الفاتورة
class InvoiceSummary extends StatelessWidget {
  final GoldInvoice invoice;

  const InvoiceSummary({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenNeon.withOpacity(0.1),
            AppColors.goldenGlow.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldenGlow.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt, color: AppColors.goldenNeon, size: 24),
              SizedBox(width: 12),
              Text(
                'ملخص الفاتورة',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.goldenNeon, height: 1),
          const SizedBox(height: 16),

          _buildSummaryRow('قيمة الذهب', invoice.totalGoldValue),
          _buildSummaryRow('المصنعية', invoice.totalMakingCharge),
          _buildSummaryRow(
            'الخصم',
            -invoice.totalDiscount,
            color: AppColors.errorDark,
          ),
          _buildSummaryRow('الضريبة', invoice.totalTax),

          const SizedBox(height: 12),
          _buildSummaryRow('الإجمالي الفرعي', invoice.subtotal, isBold: true),

          if (invoice.tradeInValue > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              'البدل',
              -invoice.tradeInValue,
              color: AppColors.infoDark,
            ),
          ],

          const SizedBox(height: 16),
          const Divider(color: AppColors.goldenNeon, height: 1, thickness: 2),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المبلغ النهائي',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${invoice.grandTotal.toStringAsFixed(2)} ج.م',
                style: const TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} ج.م',
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: isBold ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// قسم الدفعات
class PaymentSection extends StatelessWidget {
  final List<Payment> payments;
  final double grandTotal;
  final double paid;
  final double remaining;
  final bool enabled;

  const PaymentSection({
    super.key,
    required this.payments,
    required this.grandTotal,
    required this.paid,
    required this.remaining,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: remaining == 0
              ? AppColors.successDark
              : AppColors.border.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successDark.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.payments,
                  color: AppColors.successLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'الدفعات',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // الدفعات
          if (payments.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'لم يتم إضافة دفعات بعد',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...payments.map(
              (payment) => _PaymentItem(payment: payment, enabled: enabled),
            ),

          if (enabled && remaining > 0) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                _showAddPaymentDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة دفعة'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),

          // الملخص
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المدفوع',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                '${paid.toStringAsFixed(2)} ج.م',
                style: const TextStyle(
                  color: AppColors.successLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المتبقي',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${remaining.toStringAsFixed(2)} ج.م',
                style: TextStyle(
                  color: remaining == 0
                      ? AppColors.successLight
                      : AppColors.warningDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController(
      text: remaining.toStringAsFixed(2),
    );
    var selectedMethod = PaymentMethod.cash;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.goldenNeon, width: 2),
          ),
          title: const Text(
            'إضافة دفعة',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'المبلغ',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  suffixText: 'ج.م',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentMethod>(
                value: selectedMethod,
                style: const TextStyle(color: AppColors.textPrimary),
                dropdownColor: AppColors.card,
                decoration: const InputDecoration(
                  labelText: 'طريقة الدفع',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMethod = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  context.read<GoldSaleCubit>().addPayment(
                    method: selectedMethod,
                    amountPiastres: (amount * 100).round(),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  final Payment payment;
  final bool enabled;

  const _PaymentItem({required this.payment, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            _getPaymentIcon(payment.method),
            color: AppColors.successLight,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.method.displayName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${payment.amount.toStringAsFixed(2)} ج.م',
                  style: const TextStyle(
                    color: AppColors.successLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (enabled)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: AppColors.errorDark,
              onPressed: () {
                context.read<GoldSaleCubit>().removePayment(payment.id);
              },
            ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.transfer:
        return Icons.account_balance;
      case PaymentMethod.check:
        return Icons.receipt;
    }
  }
}

/// أزرار الإجراءات
class ActionButtons extends StatelessWidget {
  final GoldInvoice invoice;
  final bool isSubmitting;

  const ActionButtons({
    super.key,
    required this.invoice,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.goldenNeon, width: 2)),
      ),
      child: Row(
        children: [
          // حفظ كمسودة
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isSubmitting || invoice.lineItems.isEmpty
                  ? null
                  : () {
                      context.read<GoldSaleCubit>().saveDraft();
                    },
              icon: const Icon(Icons.save, size: 20),
              label: const Text('حفظ مسودة'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // إتمام البيع
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isSubmitting || !invoice.canComplete
                  ? null
                  : () {
                      context.read<GoldSaleCubit>().completeSale();
                    },
              icon: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle, size: 20),
              label: Text(isSubmitting ? 'جاري الإرسال...' : 'إتمام البيع'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
