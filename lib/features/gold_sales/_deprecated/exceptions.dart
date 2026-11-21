/// Exception when trying to sell an unavailable product
class ProductUnavailableException implements Exception {
  ProductUnavailableException(this.message);
  
  final String message;
  
  @override
  String toString() => 'ProductUnavailableException: $message';
}

/// Exception when payment is incomplete
class PaymentIncompleteException implements Exception {
  PaymentIncompleteException(this.remainingPiastres);
  
  final int remainingPiastres;
  
  @override
  String toString() => 'PaymentIncompleteException: المبلغ المدفوع ناقص $remainingPiastres قرش';
}

/// Exception when discount requires manager approval
class DiscountApprovalRequiredException implements Exception {
  DiscountApprovalRequiredException(this.discountPercent);
  
  final double discountPercent;
  
  @override
  String toString() => 'DiscountApprovalRequiredException: الخصم ${discountPercent.toStringAsFixed(1)}% يتطلب موافقة المدير';
}
