/// Gold sales localization strings
class GoldSalesStrings {
  // Page titles
  static const String newSale = 'فاتورة بيع ذهب جديدة';
  static const String editDraft = 'تعديل المسودة';
  
  // Actions
  static const String saveDraft = 'حفظ كمسودة';
  static const String draftSaved = 'تم حفظ المسودة بنجاح';
  static const String submitInvoice = 'إتمام عملية البيع';
  static const String invoiceSubmitted = 'تم إتمام البيع بنجاح';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String add = 'إضافة';
  static const String remove = 'حذف';
  static const String calculate = 'احسب';
  
  // Search & Input
  static const String searchProduct = 'بحث عن قطعة ذهب';
  static const String enterCodeOrBarcode = 'أدخل الكود أو امسح الباركود';
  static const String scanBarcode = 'مسح الباركود';
  static const String productCode = 'كود القطعة';
  static const String barcode = 'الباركود';
  
  // Product details
  static const String weight = 'الوزن القائم';
  static const String stonesWeight = 'وزن الفصوص';
  static const String netWeight = 'الوزن الصافي';
  static const String karat = 'العيار';
  static const String goldPrice = 'سعر الجرام';
  static const String workmanship = 'المصنعية';
  static const String discount = 'الخصم';
  static const String tax = 'الضريبة';
  static const String lineTotal = 'إجمالي السطر';
  
  // Workmanship type
  static const String perGram = 'للجرام';
  static const String fixed = 'مبلغ ثابت';
  static const String workmanshipPerGram = 'مصنعية للجرام';
  static const String workmanshipFixed = 'مصنعية ثابتة';
  
  // Invoice
  static const String itemsList = 'قطع الذهب';
  static const String invoiceSummary = 'ملخص الفاتورة';
  static const String subtotal = 'المجموع الفرعي';
  static const String totalDiscount = 'إجمالي الخصم';
  static const String totalTax = 'إجمالي الضريبة';
  static const String grandTotal = 'الإجمالي النهائي';
  static const String sellerDiscount = 'خصم البائع';
  
  // Payment
  static const String paymentMethods = 'طرق الدفع';
  static const String addPayment = 'إضافة دفعة';
  static const String cash = 'نقدي';
  static const String card = 'بطاقة';
  static const String transfer = 'تحويل بنكي';
  static const String check = 'شيك';
  static const String exchange = 'بدل';
  static const String amount = 'المبلغ';
  static const String reference = 'المرجع / الملاحظات';
  static const String totalPaid = 'المدفوع';
  static const String remaining = 'المتبقي';
  
  // Exchange payment
  static const String exchangeWeight = 'وزن البدل';
  static const String exchangePrice = 'سعر شراء البدل';
  static const String exchangeValue = 'قيمة البدل';
  
  // Status
  static const String available = 'متاح';
  static const String sold = 'مباع';
  static const String reserved = 'محجوز';
  static const String workshop = 'في الورشة';
  static const String transit = 'في الطريق';
  
  // Units
  static const String gram = 'جرام';
  static const String milligram = 'مليجرام';
  static const String egp = 'ج.م';
  static const String piaster = 'قرش';
  static const String percent = '%';
  
  // Messages
  static const String noItems = 'لا توجد قطع مضافة';
  static const String addItemsHint = 'ابحث عن قطعة أو امسح الباركود لإضافتها للفاتورة';
  static const String maxItemsReached = 'تم الوصول للحد الأقصى (قطعتين فقط)';
  static const String productNotFound = 'القطعة غير موجودة';
  static const String productAlreadyAdded = 'القطعة مضافة بالفعل';
  static const String errorLoading = 'حدث خطأ في التحميل';
  
  // Validations
  static const String invalidWeight = 'الوزن غير صحيح';
  static const String weightMustBePositive = 'يجب أن يكون الوزن أكبر من صفر';
  static const String stonesCantExceedGross = 'وزن الفصوص لا يمكن أن يساوي أو يتجاوز الوزن القائم';
  static const String invalidPrice = 'السعر غير صحيح';
  static const String invalidDiscount = 'الخصم غير صحيح';
  static const String discountNeedsApproval = 'الخصم أكثر من 10% ويحتاج موافقة';
  static const String paymentExceedsTotal = 'المبلغ المدفوع يتجاوز الإجمالي';
  static const String paymentIncomplete = 'يجب إكمال الدفع';
  static const String noItemsToSubmit = 'يجب إضافة قطعة واحدة على الأقل';
  
  // Confirmations
  static const String confirmRemoveItem = 'هل تريد حذف هذه القطعة؟';
  static const String confirmRemovePayment = 'هل تريد حذف هذه الدفعة؟';
  static const String confirmSubmit = 'هل أنت متأكد من إتمام البيع؟';
  static const String confirmSubmitMessage = 'تأكد من مراجعة جميع البيانات قبل الإتمام';
  
  // Price lock
  static const String priceLocked = 'الأسعار مقفلة';
  static const String priceUnlocked = 'الأسعار غير مقفلة';
  static const String lockPrices = 'قفل الأسعار';
  static const String unlockPrices = 'فتح الأسعار';
  static const String pricesLockedMessage = 'الأسعار مقفلة ولن تتحدث حتى تطلب تحديثها';
}
