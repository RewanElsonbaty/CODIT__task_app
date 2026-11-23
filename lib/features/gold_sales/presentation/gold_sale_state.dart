part of 'gold_sale_cubit.dart';

sealed class GoldSaleState extends Equatable {
  const GoldSaleState();
  
  @override
  List<Object?> get props => [];
}

/// حالة أولية
class GoldSaleInitial extends GoldSaleState {}

/// تم تحميل المنتجات
class ProductsLoaded extends GoldSaleState {
  final List<GoldProduct> products;
  
  const ProductsLoaded({required this.products});
  
  @override
  List<Object?> get props => [products];
}

/// خطأ عام
class GoldSaleError extends GoldSaleState {
  final String message;
  
  const GoldSaleError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

/// جاري بناء الفاتورة
class InvoiceBuilding extends GoldSaleState {
  final GoldInvoice invoice;
  
  const InvoiceBuilding({required this.invoice});
  
  @override
  List<Object?> get props => [invoice];
}

/// خطأ مؤقت (مع الاحتفاظ بالفاتورة)
class InvoiceError extends GoldSaleState {
  final String message;
  final GoldInvoice invoice;
  
  const InvoiceError({
    required this.message,
    required this.invoice,
  });
  
  @override
  List<Object?> get props => [message, invoice];
}

/// جاري الحفظ
class InvoiceSaving extends GoldSaleState {
  final GoldInvoice invoice;
  
  const InvoiceSaving({required this.invoice});
  
  @override
  List<Object?> get props => [invoice];
}

/// تم الحفظ
class InvoiceSaved extends GoldSaleState {
  final GoldInvoice invoice;
  
  const InvoiceSaved({required this.invoice});
  
  @override
  List<Object?> get props => [invoice];
}

/// يحتاج موافقة (خصم > 10%)
class InvoiceNeedsApproval extends GoldSaleState {
  final GoldInvoice invoice;
  
  const InvoiceNeedsApproval({required this.invoice});
  
  @override
  List<Object?> get props => [invoice];
}

/// جاري الإرسال
class InvoiceSubmitting extends GoldSaleState {
  final GoldInvoice invoice;
  
  const InvoiceSubmitting({required this.invoice});
  
  @override
  List<Object?> get props => [invoice];
}

/// تمت العملية
class InvoiceCompleted extends GoldSaleState {
  final GoldInvoice invoice;
  
  const InvoiceCompleted({required this.invoice});
  
  @override
  List<Object?> get props => [invoice];
}
