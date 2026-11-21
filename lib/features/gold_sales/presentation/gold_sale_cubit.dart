import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../domain/gold_models.dart';
import '../domain/gold_calculator.dart';

part 'gold_sale_state.dart';

class GoldSaleCubit extends Cubit<GoldSaleState> {
  GoldSaleCubit() : super(GoldSaleInitial());
  
  final _uuid = const Uuid();
  
  /// بدء فاتورة جديدة
  void startNew() {
    final invoice = GoldInvoice(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      lineItems: const [],
      payments: const [],
      totalGoldValuePiastres: 0,
      totalMakingChargePiastres: 0,
      totalDiscountPiastres: 0,
      totalTaxPiastres: 0,
      subtotalPiastres: 0,
      tradeInValuePiastres: 0,
      grandTotalPiastres: 0,
      paidPiastres: 0,
      remainingPiastres: 0,
      isDraft: true,
      isComplete: false,
    );
    
    emit(InvoiceBuilding(invoice: invoice));
  }
  
  /// إضافة قطعة
  Future<void> addProduct({
    required GoldProduct product,
    required int pricePerGramPiastres,
    required MakingChargeType makingChargeType,
    int makingChargePerGramPiastres = 0,
    int? makingChargeFixedPiastres,
    int discountPercentage = 0,
  }) async {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    // التحقق من حالة القطعة
    if (!product.status.canSell) {
      emit(InvoiceError(
        message: 'لا يمكن بيع هذه القطعة - ${product.status.displayName}',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    // التحقق من التكرار
    final exists = current.invoice.lineItems.any((item) => 
      item.product.code == product.code
    );
    
    if (exists) {
      emit(InvoiceError(
        message: 'القطعة موجودة بالفعل في الفاتورة',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    // التحقق من الحد الأقصى (قطعتين)
    if (current.invoice.lineItems.length >= 2) {
      emit(InvoiceError(
        message: 'لا يمكن إضافة أكثر من قطعتين في الفاتورة',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    // حساب السطر
    final lineTotal = GoldCalculator.calculateLineTotal(
      grossWeightMg: product.grossWeightMg,
      stonesWeightMg: product.stonesWeightMg,
      pricePerGramPiastres: pricePerGramPiastres,
      makingChargePerGramPiastres: makingChargePerGramPiastres,
      makingChargeFixedPiastres: makingChargeFixedPiastres,
      discountPercentage: discountPercentage,
    );
    
    final lineItem = InvoiceLineItem(
      id: _uuid.v4(),
      product: product,
      pricePerGramPiastres: pricePerGramPiastres,
      makingChargeType: makingChargeType,
      makingChargePerGramPiastres: makingChargePerGramPiastres,
      makingChargeFixedPiastres: makingChargeFixedPiastres,
      discountPercentage: discountPercentage,
      netWeightMg: lineTotal.netWeightMg,
      goldValuePiastres: lineTotal.goldValuePiastres,
      makingChargePiastres: lineTotal.makingChargePiastres,
      discountPiastres: lineTotal.discountPiastres,
      makingChargeAfterDiscountPiastres: lineTotal.makingChargeAfterDiscountPiastres,
      taxPiastres: lineTotal.taxPiastres,
      totalPiastres: lineTotal.totalPiastres,
    );
    
    // إضافة للفاتورة وإعادة الحساب
    final newLineItems = [...current.invoice.lineItems, lineItem];
    _recalculateInvoice(current.invoice, newLineItems: newLineItems);
  }
  
  /// حذف قطعة
  void removeProduct(String lineItemId) {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    final newLineItems = current.invoice.lineItems
        .where((item) => item.id != lineItemId)
        .toList();
    
    _recalculateInvoice(current.invoice, newLineItems: newLineItems);
  }
  
  /// تحديث خصم سطر
  Future<void> updateLineDiscount(String lineItemId, int discountPercentage) async {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    // التحقق من نسبة الخصم
    if (discountPercentage < 0 || discountPercentage > 100) {
      emit(InvoiceError(
        message: 'نسبة الخصم يجب أن تكون بين 0 و 100',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    // تحديث السطر وإعادة الحساب
    final newLineItems = current.invoice.lineItems.map((item) {
      if (item.id != lineItemId) return item;
      
      final lineTotal = GoldCalculator.calculateLineTotal(
        grossWeightMg: item.product.grossWeightMg,
        stonesWeightMg: item.product.stonesWeightMg,
        pricePerGramPiastres: item.pricePerGramPiastres,
        makingChargePerGramPiastres: item.makingChargePerGramPiastres,
        makingChargeFixedPiastres: item.makingChargeFixedPiastres,
        discountPercentage: discountPercentage,
      );
      
      return item.copyWith(
        discountPercentage: discountPercentage,
        discountPiastres: lineTotal.discountPiastres,
        makingChargeAfterDiscountPiastres: lineTotal.makingChargeAfterDiscountPiastres,
        taxPiastres: lineTotal.taxPiastres,
        totalPiastres: lineTotal.totalPiastres,
      );
    }).toList();
    
    _recalculateInvoice(current.invoice, newLineItems: newLineItems);
  }
  
  /// إضافة بدل
  Future<void> addTradeIn({
    required int weightMg,
    required int discountPercentage,
    required int buyBackPricePerGramPiastres,
  }) async {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    if (weightMg <= 0) {
      emit(InvoiceError(
        message: 'وزن البدل يجب أن يكون أكبر من صفر',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    final valuePiastres = GoldCalculator.calculateTradeInValue(
      tradeInWeightMg: weightMg,
      tradeInDiscountPercentage: discountPercentage,
      buyBackPricePerGramPiastres: buyBackPricePerGramPiastres,
    );
    
    final tradeIn = TradeInItem(
      weightMg: weightMg,
      discountPercentage: discountPercentage,
      buyBackPricePerGramPiastres: buyBackPricePerGramPiastres,
      valuePiastres: valuePiastres,
    );
    
    _recalculateInvoice(current.invoice, tradeIn: tradeIn);
  }
  
  /// حذف البدل
  void removeTradeIn() {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    _recalculateInvoice(current.invoice, tradeIn: null, clearTradeIn: true);
  }
  
  /// إضافة دفعة
  Future<void> addPayment({
    required PaymentMethod method,
    required int amountPiastres,
    String? reference,
  }) async {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    if (amountPiastres <= 0) {
      emit(InvoiceError(
        message: 'المبلغ يجب أن يكون أكبر من صفر',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    final payment = Payment(
      id: _uuid.v4(),
      method: method,
      amountPiastres: amountPiastres,
      reference: reference,
    );
    
    final newPayments = [...current.invoice.payments, payment];
    final paidPiastres = newPayments.fold<int>(
      0,
      (sum, p) => sum + p.amountPiastres,
    );
    
    // التحقق من عدم تجاوز المبلغ المطلوب
    if (paidPiastres > current.invoice.grandTotalPiastres) {
      emit(InvoiceError(
        message: 'المدفوعات تتجاوز المبلغ المطلوب',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    final remainingPiastres = current.invoice.grandTotalPiastres - paidPiastres;
    
    final newInvoice = current.invoice.copyWith(
      payments: newPayments,
      paidPiastres: paidPiastres,
      remainingPiastres: remainingPiastres,
    );
    
    emit(InvoiceBuilding(invoice: newInvoice));
  }
  
  /// حذف دفعة
  void removePayment(String paymentId) {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    final newPayments = current.invoice.payments
        .where((p) => p.id != paymentId)
        .toList();
    
    final paidPiastres = newPayments.fold<int>(
      0,
      (sum, p) => sum + p.amountPiastres,
    );
    
    final remainingPiastres = current.invoice.grandTotalPiastres - paidPiastres;
    
    final newInvoice = current.invoice.copyWith(
      payments: newPayments,
      paidPiastres: paidPiastres,
      remainingPiastres: remainingPiastres,
    );
    
    emit(InvoiceBuilding(invoice: newInvoice));
  }
  
  /// حفظ كمسودة
  Future<void> saveDraft() async {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    if (current.invoice.lineItems.isEmpty) {
      emit(InvoiceError(
        message: 'لا يمكن حفظ فاتورة فارغة',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    emit(InvoiceSaving(invoice: current.invoice));
    
    // TODO: Save to local storage
    await Future.delayed(const Duration(seconds: 1));
    
    emit(InvoiceSaved(invoice: current.invoice));
    await Future.delayed(const Duration(seconds: 1));
    emit(current);
  }
  
  /// إتمام البيع
  Future<void> completeSale() async {
    final current = state;
    if (current is! InvoiceBuilding) return;
    
    // التحقق من وجود أصناف
    if (current.invoice.lineItems.isEmpty) {
      emit(InvoiceError(
        message: 'لا يمكن إتمام فاتورة فارغة',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    // التحقق من اكتمال الدفع
    if (!current.invoice.canComplete) {
      emit(InvoiceError(
        message: 'المبلغ المدفوع أقل من المطلوب',
        invoice: current.invoice,
      ));
      await Future.delayed(const Duration(seconds: 2));
      emit(current);
      return;
    }
    
    // التحقق من الموافقة إذا كان الخصم > 10%
    if (current.invoice.needsApproval) {
      emit(InvoiceNeedsApproval(invoice: current.invoice));
      return;
    }
    
    emit(InvoiceSubmitting(invoice: current.invoice));
    
    // TODO: Submit to API
    await Future.delayed(const Duration(seconds: 2));
    
    final completedInvoice = current.invoice.copyWith(
      isDraft: false,
      isComplete: true,
    );
    
    emit(InvoiceCompleted(invoice: completedInvoice));
  }
  
  /// إعادة الحساب الكاملة للفاتورة
  void _recalculateInvoice(
    GoldInvoice invoice, {
    List<InvoiceLineItem>? newLineItems,
    TradeInItem? tradeIn,
    bool clearTradeIn = false,
  }) {
    final lineItems = newLineItems ?? invoice.lineItems;
    final tradeInItem = clearTradeIn ? null : (tradeIn ?? invoice.tradeIn);
    
    // حساب الإجمالي
    final invoiceTotal = GoldCalculator.calculateInvoiceTotal(
      lineItems: lineItems.map((item) {
        return LineItemTotal(
          netWeightMg: item.netWeightMg,
          goldValuePiastres: item.goldValuePiastres,
          makingChargePiastres: item.makingChargePiastres,
          discountPiastres: item.discountPiastres,
          makingChargeAfterDiscountPiastres: item.makingChargeAfterDiscountPiastres,
          taxPiastres: item.taxPiastres,
          totalPiastres: item.totalPiastres,
        );
      }).toList(),
      tradeInWeightMg: tradeInItem?.weightMg,
      tradeInDiscountPercentage: tradeInItem?.discountPercentage,
      buyBackPricePerGramPiastres: tradeInItem?.buyBackPricePerGramPiastres,
    );
    
    final paidPiastres = invoice.payments.fold<int>(
      0,
      (sum, p) => sum + p.amountPiastres,
    );
    
    final remainingPiastres = invoiceTotal.grandTotalPiastres - paidPiastres;
    
    final newInvoice = invoice.copyWith(
      lineItems: lineItems,
      tradeIn: tradeInItem,
      totalGoldValuePiastres: invoiceTotal.totalGoldValuePiastres,
      totalMakingChargePiastres: invoiceTotal.totalMakingChargePiastres,
      totalDiscountPiastres: invoiceTotal.totalDiscountPiastres,
      totalTaxPiastres: invoiceTotal.totalTaxPiastres,
      subtotalPiastres: invoiceTotal.subtotalPiastres,
      tradeInValuePiastres: invoiceTotal.tradeInValuePiastres,
      grandTotalPiastres: invoiceTotal.grandTotalPiastres,
      paidPiastres: paidPiastres,
      remainingPiastres: remainingPiastres,
    );
    
    emit(InvoiceBuilding(invoice: newInvoice));
  }
}
