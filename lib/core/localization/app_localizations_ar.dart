// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كوديت للأعمال';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get otpTitle => 'رمز التحقق';

  @override
  String get deviceVerifyTitle => 'التحقق من الجهاز';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get approvals => 'طلبات الموافقة';

  @override
  String get installments => 'التحصيل';

  @override
  String get goldSales => 'بيع الذهب';

  @override
  String get branchMonitoring => 'مراقبة الفروع';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get errorGeneric => 'حدث خطأ. حاول مرة أخرى.';

  @override
  String get emptyList => 'لا توجد بيانات';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get approve => 'موافقة';

  @override
  String get reject => 'رفض';

  @override
  String get pendingSyncTitle => 'عمليات التحصيل المعلقة';

  @override
  String get checkingDecision => 'جارٍ التحقق من نتيجة الموافقة';

  @override
  String get goldSaleTitle => 'فاتورة بيع ذهب';

  @override
  String get addProduct => 'إضافة قطعة';

  @override
  String get searchByCode => 'البحث بالكود';

  @override
  String get searchByBarcode => 'مسح الباركود';

  @override
  String get productCode => 'كود القطعة';

  @override
  String get grossWeight => 'الوزن القائم (جم)';

  @override
  String get stoneWeight => 'وزن الفصوص (جم)';

  @override
  String get netWeight => 'الوزن الصافي (جم)';

  @override
  String get karat => 'العيار';

  @override
  String get pricePerGram => 'سعر الجرام (ج.م)';

  @override
  String get workmanship => 'المصنعية';

  @override
  String get workmanshipPerGram => 'مصنعية للجرام';

  @override
  String get fixedWorkmanship => 'مصنعية ثابتة';

  @override
  String get discount => 'الخصم %';

  @override
  String get goldValue => 'قيمة الذهب';

  @override
  String get tax => 'الضريبة (14%)';

  @override
  String get total => 'الإجمالي';

  @override
  String get subtotal => 'المجموع';

  @override
  String get grandTotal => 'الإجمالي النهائي';

  @override
  String get payments => 'طرق الدفع';

  @override
  String get addPayment => 'إضافة دفعة';

  @override
  String get cash => 'نقدي';

  @override
  String get card => 'بطاقة';

  @override
  String get bankTransfer => 'تحويل بنكي';

  @override
  String get exchange => 'بدل ذهب';

  @override
  String get exchangeWeight => 'وزن البدل';

  @override
  String get exchangePrice => 'سعر شراء البدل';

  @override
  String get paid => 'المدفوع';

  @override
  String get remaining => 'المتبقي';

  @override
  String get saveDraft => 'حفظ مسودة';

  @override
  String get loadDraft => 'فتح مسودة';

  @override
  String get completeSale => 'إتمام البيع';

  @override
  String get productNotFound => 'القطعة غير موجودة';

  @override
  String get productAlreadyAdded => 'القطعة مضافة بالفعل';

  @override
  String get productNotAvailable => 'القطعة غير متاحة للبيع';

  @override
  String get productSold => 'القطعة مباعة';

  @override
  String get productReserved => 'القطعة محجوزة';

  @override
  String get productInWorkshop => 'القطعة في الورشة';

  @override
  String get productInTransit => 'القطعة في الطريق';

  @override
  String get invalidWeight => 'وزن غير صالح';

  @override
  String get stoneWeightTooHigh =>
      'وزن الفصوص لا يمكن أن يساوي أو يزيد عن الوزن القائم';

  @override
  String get discountExceedsLimit => 'الخصم يتجاوز 10٪ ويحتاج موافقة';

  @override
  String get paymentShortage => 'المدفوع أقل من الإجمالي';

  @override
  String get needsApproval => 'يحتاج موافقة';

  @override
  String get lockPrices => 'تثبيت الأسعار';

  @override
  String get updatePrices => 'تحديث الأسعار';

  @override
  String get goldSalesNewSale => 'بيع ذهب جديد';

  @override
  String get goldSalesSearchProductHint => 'أدخل كود القطعة';

  @override
  String get goldSalesSearch => 'بحث';

  @override
  String get goldSalesScanBarcode => 'مسح الباركود';

  @override
  String get goldSalesScanning => 'جارٍ المسح...';

  @override
  String get goldSalesStartScan => 'ابدأ المسح';

  @override
  String get goldSalesScanHint => 'وجّه الكاميرا نحو الباركود';

  @override
  String get goldSalesScanError => 'فشل مسح الباركود';

  @override
  String get goldSalesItemsList => 'قائمة القطع';

  @override
  String get goldSalesItems => 'قطعة';

  @override
  String get goldSalesNoItems => 'لا توجد قطع في الفاتورة';

  @override
  String get goldSalesAddItemsHint => 'استخدم البحث أو الباركود لإضافة القطع';

  @override
  String get goldSalesStatusAvailable => 'متاح';

  @override
  String get goldSalesStatusSold => 'مباع';

  @override
  String get goldSalesStatusReserved => 'محجوز';

  @override
  String get goldSalesStatusWorkshop => 'ورشة';

  @override
  String get goldSalesStatusTransit => 'نقل';

  @override
  String get goldSalesRemoveItem => 'إزالة';

  @override
  String get goldSalesWeight => 'الوزن';

  @override
  String get goldSalesGram => 'جم';

  @override
  String get goldSalesCarat => 'العيار';

  @override
  String get goldSalesCaratUnit => 'قيراط';

  @override
  String get goldSalesStonesWeight => 'وزن الفصوص';

  @override
  String get goldSalesGoldPricePerGram => 'سعر الجرام';

  @override
  String get goldSalesEgp => 'ج.م';

  @override
  String get goldSalesWorkmanship => 'المصنعية';

  @override
  String get goldSalesLineTotal => 'إجمالي القطعة';

  @override
  String get goldSalesInvoiceSummary => 'ملخص الفاتورة';

  @override
  String get goldSalesSubtotal => 'المجموع الفرعي';

  @override
  String get goldSalesDiscount => 'الخصم';

  @override
  String get goldSalesApply => 'تطبيق';

  @override
  String get goldSalesInvalidDiscount => 'نسبة خصم غير صالحة (0-100)';

  @override
  String get goldSalesNetTotal => 'الإجمالي';

  @override
  String get goldSalesPaid => 'المدفوع';

  @override
  String get goldSalesRemaining => 'المتبقي';

  @override
  String get goldSalesPaymentSection => 'الدفع';

  @override
  String get goldSalesPaymentMethod => 'طريقة الدفع';

  @override
  String get goldSalesPaymentCash => 'نقدي';

  @override
  String get goldSalesPaymentCard => 'بطاقة';

  @override
  String get goldSalesPaymentTransfer => 'تحويل';

  @override
  String get goldSalesPaymentCheck => 'شيك';

  @override
  String get goldSalesAmount => 'المبلغ';

  @override
  String get goldSalesReference => 'المرجع';

  @override
  String get goldSalesReferenceHint => 'رقم المرجع أو الملاحظات';

  @override
  String get goldSalesInvalidAmount => 'مبلغ غير صالح';

  @override
  String get goldSalesAddPayment => 'إضافة دفعة';

  @override
  String get goldSalesPaymentsList => 'الدفعات';

  @override
  String get goldSalesTotalPaid => 'إجمالي المدفوع';

  @override
  String get goldSalesSaveDraft => 'حفظ مسودة';

  @override
  String get goldSalesDraftSaved => 'تم حفظ المسودة بنجاح';

  @override
  String get goldSalesSubmitInvoice => 'إتمام الفاتورة';

  @override
  String get goldSalesInvoiceSubmitted => 'تم إتمام الفاتورة بنجاح';

  @override
  String get goldSalesErrorLoading => 'حدث خطأ في تحميل الصفحة';

  @override
  String get goldSalesNeedsApproval => 'الخصم يتجاوز 10٪ ويحتاج موافقة';
}
