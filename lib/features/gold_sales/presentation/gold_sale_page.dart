import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../domain/gold_models.dart';
import 'gold_sale_cubit.dart';
import 'widgets/gold_sale_widgets.dart';

class GoldSalePage extends StatelessWidget {
  const GoldSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoldSaleCubit()..startNew(),
      child: const _GoldSaleView(),
    );
  }
}

class _GoldSaleView extends StatelessWidget {
  const _GoldSaleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Icons.diamond,
                size: 24,
                color: AppColors.goldenNeon,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'بيع الذهب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          // زر الرجوع للصفحة الرئيسية
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.goldenNeon),
            onPressed: () {
              context.go('/home');
            },
            tooltip: 'الصفحة الرئيسية',
          ),
          // زر المسودات
          IconButton(
            icon: const Icon(Icons.drafts, color: AppColors.goldenNeon),
            onPressed: () {
              // TODO: Open drafts
            },
            tooltip: 'المسودات',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<GoldSaleCubit, GoldSaleState>(
        listener: (context, state) {
          if (state is InvoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: AppColors.errorLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.errorDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is InvoiceSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.successLight,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'تم حفظ المسودة بنجاح',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: AppColors.successDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is InvoiceCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.successLight,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'تمت عملية البيع بنجاح',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: AppColors.successDark,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 3),
              ),
            );

            // العودة للشاشة السابقة
            Future.delayed(const Duration(seconds: 3), () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          } else if (state is InvoiceNeedsApproval) {
            _showApprovalDialog(context, state.invoice);
          }
        },
        builder: (context, state) {
          if (state is GoldSaleInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final invoice = _getInvoice(state);
          if (invoice == null) {
            return const Center(
              child: Text(
                'حدث خطأ',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            );
          }

          return ResponsiveBuilder(
            builder: (context, isMobile) {
              if (isMobile) {
                return _buildMobileLayout(context, invoice, state);
              } else {
                return _buildTabletLayout(context, invoice, state);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    GoldInvoice invoice,
    GoldSaleState state,
  ) {
    final isSubmitting = state is InvoiceSubmitting || state is InvoiceSaving;

    return Column(
      children: [
        // الهيدر
        InvoiceHeader(invoice: invoice),

        // المحتوى القابل للتمرير
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // البحث عن المنتج
                ProductSearchSection(
                  enabled: !isSubmitting && invoice.lineItems.length < 2,
                ),

                const SizedBox(height: 16),

                // قائمة الأصناف
                LineItemsList(
                  lineItems: invoice.lineItems,
                  enabled: !isSubmitting,
                ),

                const SizedBox(height: 16),

                // البدل
                TradeInSection(
                  tradeIn: invoice.tradeIn,
                  enabled: !isSubmitting,
                ),

                const SizedBox(height: 16),

                // الملخص
                InvoiceSummary(invoice: invoice),

                const SizedBox(height: 16),

                // الدفعات
                PaymentSection(
                  payments: invoice.payments,
                  grandTotal: invoice.grandTotal,
                  paid: invoice.paid,
                  remaining: invoice.remaining,
                  enabled: !isSubmitting,
                ),

                const SizedBox(height: 80), // مساحة للأزرار
              ],
            ),
          ),
        ),

        // الأزرار
        ActionButtons(invoice: invoice, isSubmitting: isSubmitting),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    GoldInvoice invoice,
    GoldSaleState state,
  ) {
    final isSubmitting = state is InvoiceSubmitting || state is InvoiceSaving;

    return Column(
      children: [
        // الهيدر
        InvoiceHeader(invoice: invoice),

        // المحتوى - صفين
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الجانب الأيسر - الأصناف
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // البحث
                      ProductSearchSection(
                        enabled: !isSubmitting && invoice.lineItems.length < 2,
                      ),

                      const SizedBox(height: 24),

                      // قائمة الأصناف
                      LineItemsList(
                        lineItems: invoice.lineItems,
                        enabled: !isSubmitting,
                      ),

                      const SizedBox(height: 24),

                      // البدل
                      TradeInSection(
                        tradeIn: invoice.tradeIn,
                        enabled: !isSubmitting,
                      ),
                    ],
                  ),
                ),
              ),

              // الجانب الأيمن - الملخص والدفع
              Expanded(
                flex: 2,
                child: Container(
                  color: AppColors.backgroundSecondary,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // الملخص
                        InvoiceSummary(invoice: invoice),

                        const SizedBox(height: 24),

                        // الدفعات
                        PaymentSection(
                          payments: invoice.payments,
                          grandTotal: invoice.grandTotal,
                          paid: invoice.paid,
                          remaining: invoice.remaining,
                          enabled: !isSubmitting,
                        ),

                        const SizedBox(height: 24),

                        // الأزرار
                        ActionButtons(
                          invoice: invoice,
                          isSubmitting: isSubmitting,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  GoldInvoice? _getInvoice(GoldSaleState state) {
    return switch (state) {
      InvoiceBuilding() => state.invoice,
      InvoiceError() => state.invoice,
      InvoiceSaving() => state.invoice,
      InvoiceSaved() => state.invoice,
      InvoiceNeedsApproval() => state.invoice,
      InvoiceSubmitting() => state.invoice,
      InvoiceCompleted() => state.invoice,
      _ => null,
    };
  }

  void _showApprovalDialog(BuildContext context, GoldInvoice invoice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningDark.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning,
                color: AppColors.warningDark,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'يحتاج موافقة',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الفاتورة تحتوي على خصومات أكثر من 10%',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningDark.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warningDark, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: invoice.lineItems
                    .where((item) => item.discountPercentage > 10)
                    .map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• ${item.product.name}: خصم ${item.discountPercentage}%',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'يرجى طلب موافقة المدير لإتمام العملية',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Request approval
            },
            child: const Text(
              'طلب موافقة',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
