import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'كوديت للأعمال'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get otpTitle;

  /// No description provided for @deviceVerifyTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من الجهاز'**
  String get deviceVerifyTitle;

  /// No description provided for @homeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get homeTitle;

  /// No description provided for @approvals.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الموافقة'**
  String get approvals;

  /// No description provided for @installments.
  ///
  /// In ar, this message translates to:
  /// **'التحصيل'**
  String get installments;

  /// No description provided for @goldSales.
  ///
  /// In ar, this message translates to:
  /// **'بيع الذهب'**
  String get goldSales;

  /// No description provided for @branchMonitoring.
  ///
  /// In ar, this message translates to:
  /// **'مراقبة الفروع'**
  String get branchMonitoring;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل...'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ. حاول مرة أخرى.'**
  String get errorGeneric;

  /// No description provided for @emptyList.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get emptyList;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @approve.
  ///
  /// In ar, this message translates to:
  /// **'موافقة'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get reject;

  /// No description provided for @pendingSyncTitle.
  ///
  /// In ar, this message translates to:
  /// **'عمليات التحصيل المعلقة'**
  String get pendingSyncTitle;

  /// No description provided for @checkingDecision.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحقق من نتيجة الموافقة'**
  String get checkingDecision;

  /// No description provided for @goldSaleTitle.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة بيع ذهب'**
  String get goldSaleTitle;

  /// No description provided for @addProduct.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قطعة'**
  String get addProduct;

  /// No description provided for @searchByCode.
  ///
  /// In ar, this message translates to:
  /// **'البحث بالكود'**
  String get searchByCode;

  /// No description provided for @searchByBarcode.
  ///
  /// In ar, this message translates to:
  /// **'مسح الباركود'**
  String get searchByBarcode;

  /// No description provided for @productCode.
  ///
  /// In ar, this message translates to:
  /// **'كود القطعة'**
  String get productCode;

  /// No description provided for @grossWeight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن القائم (جم)'**
  String get grossWeight;

  /// No description provided for @stoneWeight.
  ///
  /// In ar, this message translates to:
  /// **'وزن الفصوص (جم)'**
  String get stoneWeight;

  /// No description provided for @netWeight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن الصافي (جم)'**
  String get netWeight;

  /// No description provided for @karat.
  ///
  /// In ar, this message translates to:
  /// **'العيار'**
  String get karat;

  /// No description provided for @pricePerGram.
  ///
  /// In ar, this message translates to:
  /// **'سعر الجرام (ج.م)'**
  String get pricePerGram;

  /// No description provided for @workmanship.
  ///
  /// In ar, this message translates to:
  /// **'المصنعية'**
  String get workmanship;

  /// No description provided for @workmanshipPerGram.
  ///
  /// In ar, this message translates to:
  /// **'مصنعية للجرام'**
  String get workmanshipPerGram;

  /// No description provided for @fixedWorkmanship.
  ///
  /// In ar, this message translates to:
  /// **'مصنعية ثابتة'**
  String get fixedWorkmanship;

  /// No description provided for @discount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم %'**
  String get discount;

  /// No description provided for @goldValue.
  ///
  /// In ar, this message translates to:
  /// **'قيمة الذهب'**
  String get goldValue;

  /// No description provided for @tax.
  ///
  /// In ar, this message translates to:
  /// **'الضريبة (14%)'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get subtotal;

  /// No description provided for @grandTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي النهائي'**
  String get grandTotal;

  /// No description provided for @payments.
  ///
  /// In ar, this message translates to:
  /// **'طرق الدفع'**
  String get payments;

  /// No description provided for @addPayment.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دفعة'**
  String get addPayment;

  /// No description provided for @cash.
  ///
  /// In ar, this message translates to:
  /// **'نقدي'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة'**
  String get card;

  /// No description provided for @bankTransfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي'**
  String get bankTransfer;

  /// No description provided for @exchange.
  ///
  /// In ar, this message translates to:
  /// **'بدل ذهب'**
  String get exchange;

  /// No description provided for @exchangeWeight.
  ///
  /// In ar, this message translates to:
  /// **'وزن البدل'**
  String get exchangeWeight;

  /// No description provided for @exchangePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر شراء البدل'**
  String get exchangePrice;

  /// No description provided for @paid.
  ///
  /// In ar, this message translates to:
  /// **'المدفوع'**
  String get paid;

  /// No description provided for @remaining.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي'**
  String get remaining;

  /// No description provided for @saveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ مسودة'**
  String get saveDraft;

  /// No description provided for @loadDraft.
  ///
  /// In ar, this message translates to:
  /// **'فتح مسودة'**
  String get loadDraft;

  /// No description provided for @completeSale.
  ///
  /// In ar, this message translates to:
  /// **'إتمام البيع'**
  String get completeSale;

  /// No description provided for @productNotFound.
  ///
  /// In ar, this message translates to:
  /// **'القطعة غير موجودة'**
  String get productNotFound;

  /// No description provided for @productAlreadyAdded.
  ///
  /// In ar, this message translates to:
  /// **'القطعة مضافة بالفعل'**
  String get productAlreadyAdded;

  /// No description provided for @productNotAvailable.
  ///
  /// In ar, this message translates to:
  /// **'القطعة غير متاحة للبيع'**
  String get productNotAvailable;

  /// No description provided for @productSold.
  ///
  /// In ar, this message translates to:
  /// **'القطعة مباعة'**
  String get productSold;

  /// No description provided for @productReserved.
  ///
  /// In ar, this message translates to:
  /// **'القطعة محجوزة'**
  String get productReserved;

  /// No description provided for @productInWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'القطعة في الورشة'**
  String get productInWorkshop;

  /// No description provided for @productInTransit.
  ///
  /// In ar, this message translates to:
  /// **'القطعة في الطريق'**
  String get productInTransit;

  /// No description provided for @invalidWeight.
  ///
  /// In ar, this message translates to:
  /// **'وزن غير صالح'**
  String get invalidWeight;

  /// No description provided for @stoneWeightTooHigh.
  ///
  /// In ar, this message translates to:
  /// **'وزن الفصوص لا يمكن أن يساوي أو يزيد عن الوزن القائم'**
  String get stoneWeightTooHigh;

  /// No description provided for @discountExceedsLimit.
  ///
  /// In ar, this message translates to:
  /// **'الخصم يتجاوز 10٪ ويحتاج موافقة'**
  String get discountExceedsLimit;

  /// No description provided for @paymentShortage.
  ///
  /// In ar, this message translates to:
  /// **'المدفوع أقل من الإجمالي'**
  String get paymentShortage;

  /// No description provided for @needsApproval.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج موافقة'**
  String get needsApproval;

  /// No description provided for @lockPrices.
  ///
  /// In ar, this message translates to:
  /// **'تثبيت الأسعار'**
  String get lockPrices;

  /// No description provided for @updatePrices.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الأسعار'**
  String get updatePrices;

  /// No description provided for @goldSalesNewSale.
  ///
  /// In ar, this message translates to:
  /// **'بيع ذهب جديد'**
  String get goldSalesNewSale;

  /// No description provided for @goldSalesSearchProductHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كود القطعة'**
  String get goldSalesSearchProductHint;

  /// No description provided for @goldSalesSearch.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get goldSalesSearch;

  /// No description provided for @goldSalesScanBarcode.
  ///
  /// In ar, this message translates to:
  /// **'مسح الباركود'**
  String get goldSalesScanBarcode;

  /// No description provided for @goldSalesScanning.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ المسح...'**
  String get goldSalesScanning;

  /// No description provided for @goldSalesStartScan.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ المسح'**
  String get goldSalesStartScan;

  /// No description provided for @goldSalesScanHint.
  ///
  /// In ar, this message translates to:
  /// **'وجّه الكاميرا نحو الباركود'**
  String get goldSalesScanHint;

  /// No description provided for @goldSalesScanError.
  ///
  /// In ar, this message translates to:
  /// **'فشل مسح الباركود'**
  String get goldSalesScanError;

  /// No description provided for @goldSalesItemsList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة القطع'**
  String get goldSalesItemsList;

  /// No description provided for @goldSalesItems.
  ///
  /// In ar, this message translates to:
  /// **'قطعة'**
  String get goldSalesItems;

  /// No description provided for @goldSalesNoItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد قطع في الفاتورة'**
  String get goldSalesNoItems;

  /// No description provided for @goldSalesAddItemsHint.
  ///
  /// In ar, this message translates to:
  /// **'استخدم البحث أو الباركود لإضافة القطع'**
  String get goldSalesAddItemsHint;

  /// No description provided for @goldSalesStatusAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متاح'**
  String get goldSalesStatusAvailable;

  /// No description provided for @goldSalesStatusSold.
  ///
  /// In ar, this message translates to:
  /// **'مباع'**
  String get goldSalesStatusSold;

  /// No description provided for @goldSalesStatusReserved.
  ///
  /// In ar, this message translates to:
  /// **'محجوز'**
  String get goldSalesStatusReserved;

  /// No description provided for @goldSalesStatusWorkshop.
  ///
  /// In ar, this message translates to:
  /// **'ورشة'**
  String get goldSalesStatusWorkshop;

  /// No description provided for @goldSalesStatusTransit.
  ///
  /// In ar, this message translates to:
  /// **'نقل'**
  String get goldSalesStatusTransit;

  /// No description provided for @goldSalesRemoveItem.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get goldSalesRemoveItem;

  /// No description provided for @goldSalesWeight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن'**
  String get goldSalesWeight;

  /// No description provided for @goldSalesGram.
  ///
  /// In ar, this message translates to:
  /// **'جم'**
  String get goldSalesGram;

  /// No description provided for @goldSalesCarat.
  ///
  /// In ar, this message translates to:
  /// **'العيار'**
  String get goldSalesCarat;

  /// No description provided for @goldSalesCaratUnit.
  ///
  /// In ar, this message translates to:
  /// **'قيراط'**
  String get goldSalesCaratUnit;

  /// No description provided for @goldSalesStonesWeight.
  ///
  /// In ar, this message translates to:
  /// **'وزن الفصوص'**
  String get goldSalesStonesWeight;

  /// No description provided for @goldSalesGoldPricePerGram.
  ///
  /// In ar, this message translates to:
  /// **'سعر الجرام'**
  String get goldSalesGoldPricePerGram;

  /// No description provided for @goldSalesEgp.
  ///
  /// In ar, this message translates to:
  /// **'ج.م'**
  String get goldSalesEgp;

  /// No description provided for @goldSalesWorkmanship.
  ///
  /// In ar, this message translates to:
  /// **'المصنعية'**
  String get goldSalesWorkmanship;

  /// No description provided for @goldSalesLineTotal.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي القطعة'**
  String get goldSalesLineTotal;

  /// No description provided for @goldSalesInvoiceSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الفاتورة'**
  String get goldSalesInvoiceSummary;

  /// No description provided for @goldSalesSubtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الفرعي'**
  String get goldSalesSubtotal;

  /// No description provided for @goldSalesDiscount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get goldSalesDiscount;

  /// No description provided for @goldSalesApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get goldSalesApply;

  /// No description provided for @goldSalesInvalidDiscount.
  ///
  /// In ar, this message translates to:
  /// **'نسبة خصم غير صالحة (0-100)'**
  String get goldSalesInvalidDiscount;

  /// No description provided for @goldSalesNetTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get goldSalesNetTotal;

  /// No description provided for @goldSalesPaid.
  ///
  /// In ar, this message translates to:
  /// **'المدفوع'**
  String get goldSalesPaid;

  /// No description provided for @goldSalesRemaining.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي'**
  String get goldSalesRemaining;

  /// No description provided for @goldSalesPaymentSection.
  ///
  /// In ar, this message translates to:
  /// **'الدفع'**
  String get goldSalesPaymentSection;

  /// No description provided for @goldSalesPaymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get goldSalesPaymentMethod;

  /// No description provided for @goldSalesPaymentCash.
  ///
  /// In ar, this message translates to:
  /// **'نقدي'**
  String get goldSalesPaymentCash;

  /// No description provided for @goldSalesPaymentCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة'**
  String get goldSalesPaymentCard;

  /// No description provided for @goldSalesPaymentTransfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل'**
  String get goldSalesPaymentTransfer;

  /// No description provided for @goldSalesPaymentCheck.
  ///
  /// In ar, this message translates to:
  /// **'شيك'**
  String get goldSalesPaymentCheck;

  /// No description provided for @goldSalesAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get goldSalesAmount;

  /// No description provided for @goldSalesReference.
  ///
  /// In ar, this message translates to:
  /// **'المرجع'**
  String get goldSalesReference;

  /// No description provided for @goldSalesReferenceHint.
  ///
  /// In ar, this message translates to:
  /// **'رقم المرجع أو الملاحظات'**
  String get goldSalesReferenceHint;

  /// No description provided for @goldSalesInvalidAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ غير صالح'**
  String get goldSalesInvalidAmount;

  /// No description provided for @goldSalesAddPayment.
  ///
  /// In ar, this message translates to:
  /// **'إضافة دفعة'**
  String get goldSalesAddPayment;

  /// No description provided for @goldSalesPaymentsList.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات'**
  String get goldSalesPaymentsList;

  /// No description provided for @goldSalesTotalPaid.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المدفوع'**
  String get goldSalesTotalPaid;

  /// No description provided for @goldSalesSaveDraft.
  ///
  /// In ar, this message translates to:
  /// **'حفظ مسودة'**
  String get goldSalesSaveDraft;

  /// No description provided for @goldSalesDraftSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ المسودة بنجاح'**
  String get goldSalesDraftSaved;

  /// No description provided for @goldSalesSubmitInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إتمام الفاتورة'**
  String get goldSalesSubmitInvoice;

  /// No description provided for @goldSalesInvoiceSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'تم إتمام الفاتورة بنجاح'**
  String get goldSalesInvoiceSubmitted;

  /// No description provided for @goldSalesErrorLoading.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في تحميل الصفحة'**
  String get goldSalesErrorLoading;

  /// No description provided for @goldSalesNeedsApproval.
  ///
  /// In ar, this message translates to:
  /// **'الخصم يتجاوز 10٪ ويحتاج موافقة'**
  String get goldSalesNeedsApproval;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
