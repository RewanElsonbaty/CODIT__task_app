import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// اسم التطبيق
  ///
  /// In ar, this message translates to:
  /// **'كوديت - إدارة الأعمال'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @username.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get username;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get loginButton;

  /// No description provided for @loggingIn.
  ///
  /// In ar, this message translates to:
  /// **'جاري تسجيل الدخول...'**
  String get loggingIn;

  /// No description provided for @loginError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تسجيل الدخول'**
  String get loginError;

  /// No description provided for @invalidCredentials.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم أو كلمة المرور غير صحيحة'**
  String get invalidCredentials;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboard;

  /// No description provided for @branches.
  ///
  /// In ar, this message translates to:
  /// **'الفروع'**
  String get branches;

  /// No description provided for @installments.
  ///
  /// In ar, this message translates to:
  /// **'الأقساط'**
  String get installments;

  /// No description provided for @approvals.
  ///
  /// In ar, this message translates to:
  /// **'الموافقات'**
  String get approvals;

  /// No description provided for @goldSales.
  ///
  /// In ar, this message translates to:
  /// **'مبيعات الذهب'**
  String get goldSales;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @branchMonitoring.
  ///
  /// In ar, this message translates to:
  /// **'مراقبة الفروع'**
  String get branchMonitoring;

  /// No description provided for @branchDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الفرع'**
  String get branchDetails;

  /// No description provided for @branchName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الفرع'**
  String get branchName;

  /// No description provided for @branchAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الفرع'**
  String get branchAddress;

  /// No description provided for @branchManager.
  ///
  /// In ar, this message translates to:
  /// **'مدير الفرع'**
  String get branchManager;

  /// No description provided for @branchPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get branchPhone;

  /// No description provided for @activeBranches.
  ///
  /// In ar, this message translates to:
  /// **'الفروع النشطة'**
  String get activeBranches;

  /// No description provided for @totalBranches.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الفروع'**
  String get totalBranches;

  /// No description provided for @todaySales.
  ///
  /// In ar, this message translates to:
  /// **'مبيعات اليوم'**
  String get todaySales;

  /// No description provided for @todayTransactions.
  ///
  /// In ar, this message translates to:
  /// **'معاملات اليوم'**
  String get todayTransactions;

  /// No description provided for @employees.
  ///
  /// In ar, this message translates to:
  /// **'الموظفين'**
  String get employees;

  /// No description provided for @activeEmployees.
  ///
  /// In ar, this message translates to:
  /// **'الموظفين الحاليين'**
  String get activeEmployees;

  /// No description provided for @totalEmployees.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الموظفين'**
  String get totalEmployees;

  /// No description provided for @statistics.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get statistics;

  /// No description provided for @reports.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reports;

  /// No description provided for @installmentsList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الأقساط'**
  String get installmentsList;

  /// No description provided for @createInstallment.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء قسط جديد'**
  String get createInstallment;

  /// No description provided for @installmentDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل القسط'**
  String get installmentDetails;

  /// No description provided for @customerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل'**
  String get customerName;

  /// No description provided for @customerPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get customerPhone;

  /// No description provided for @nationalId.
  ///
  /// In ar, this message translates to:
  /// **'الرقم القومي'**
  String get nationalId;

  /// No description provided for @invoiceNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الفاتورة'**
  String get invoiceNumber;

  /// No description provided for @totalAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ الإجمالي'**
  String get totalAmount;

  /// No description provided for @downPayment.
  ///
  /// In ar, this message translates to:
  /// **'الدفعة الأولى'**
  String get downPayment;

  /// No description provided for @remainingAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المتبقي'**
  String get remainingAmount;

  /// No description provided for @installmentAmount.
  ///
  /// In ar, this message translates to:
  /// **'قيمة القسط'**
  String get installmentAmount;

  /// No description provided for @numberOfInstallments.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأقساط'**
  String get numberOfInstallments;

  /// No description provided for @firstPaymentDate.
  ///
  /// In ar, this message translates to:
  /// **'موعد أول دفعة'**
  String get firstPaymentDate;

  /// No description provided for @paymentInterval.
  ///
  /// In ar, this message translates to:
  /// **'فترة السداد'**
  String get paymentInterval;

  /// No description provided for @monthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In ar, this message translates to:
  /// **'أسبوعي'**
  String get weekly;

  /// No description provided for @daily.
  ///
  /// In ar, this message translates to:
  /// **'يومي'**
  String get daily;

  /// No description provided for @installmentStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة القسط'**
  String get installmentStatus;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get active;

  /// No description provided for @overdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get overdue;

  /// No description provided for @completed.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغي'**
  String get cancelled;

  /// No description provided for @pending.
  ///
  /// In ar, this message translates to:
  /// **'معلق'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In ar, this message translates to:
  /// **'موافق عليه'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get rejected;

  /// No description provided for @approvalsList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الموافقات'**
  String get approvalsList;

  /// No description provided for @installmentRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات التقسيط'**
  String get installmentRequests;

  /// No description provided for @createRequest.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء طلب'**
  String get createRequest;

  /// No description provided for @requestDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get requestDetails;

  /// No description provided for @requestNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get requestNumber;

  /// No description provided for @requestDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الطلب'**
  String get requestDate;

  /// No description provided for @requestedBy.
  ///
  /// In ar, this message translates to:
  /// **'مقدم الطلب'**
  String get requestedBy;

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

  /// No description provided for @confirmApproval.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الموافقة'**
  String get confirmApproval;

  /// No description provided for @confirmRejection.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الرفض'**
  String get confirmRejection;

  /// No description provided for @approvalSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تمت الموافقة بنجاح'**
  String get approvalSuccess;

  /// No description provided for @rejectionSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الطلب'**
  String get rejectionSuccess;

  /// No description provided for @rejectionReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الرفض'**
  String get rejectionReason;

  /// No description provided for @enterRejectionReason.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال سبب الرفض'**
  String get enterRejectionReason;

  /// No description provided for @goldSalesList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة مبيعات الذهب'**
  String get goldSalesList;

  /// No description provided for @createInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء فاتورة جديدة'**
  String get createInvoice;

  /// No description provided for @invoiceDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الفاتورة'**
  String get invoiceDetails;

  /// No description provided for @goldItems.
  ///
  /// In ar, this message translates to:
  /// **'أصناف الذهب'**
  String get goldItems;

  /// No description provided for @addItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف'**
  String get addItem;

  /// No description provided for @itemType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الصنف'**
  String get itemType;

  /// No description provided for @weight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن'**
  String get weight;

  /// No description provided for @carat.
  ///
  /// In ar, this message translates to:
  /// **'العيار'**
  String get carat;

  /// No description provided for @price.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get price;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الفرعي'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get discount;

  /// No description provided for @grandTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي النهائي'**
  String get grandTotal;

  /// No description provided for @paymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentMethod;

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

  /// No description provided for @installment.
  ///
  /// In ar, this message translates to:
  /// **'تقسيط'**
  String get installment;

  /// No description provided for @notificationsList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الإشعارات'**
  String get notificationsList;

  /// No description provided for @markAsRead.
  ///
  /// In ar, this message translates to:
  /// **'تعليم كمقروء'**
  String get markAsRead;

  /// No description provided for @markAllAsRead.
  ///
  /// In ar, this message translates to:
  /// **'تعليم الكل كمقروء'**
  String get markAllAsRead;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get noNotifications;

  /// No description provided for @newRequest.
  ///
  /// In ar, this message translates to:
  /// **'طلب جديد'**
  String get newRequest;

  /// No description provided for @requestApproved.
  ///
  /// In ar, this message translates to:
  /// **'تمت الموافقة على الطلب'**
  String get requestApproved;

  /// No description provided for @requestRejected.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض الطلب'**
  String get requestRejected;

  /// No description provided for @paymentDue.
  ///
  /// In ar, this message translates to:
  /// **'دفعة مستحقة'**
  String get paymentDue;

  /// No description provided for @overduePayment.
  ///
  /// In ar, this message translates to:
  /// **'دفعة متأخرة'**
  String get overduePayment;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get refresh;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get submit;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previous;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get close;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get error;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'نجح'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In ar, this message translates to:
  /// **'تحذير'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In ar, this message translates to:
  /// **'معلومة'**
  String get info;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get noResults;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get tryAgain;

  /// No description provided for @monday.
  ///
  /// In ar, this message translates to:
  /// **'الاثنين'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In ar, this message translates to:
  /// **'يناير'**
  String get january;

  /// No description provided for @february.
  ///
  /// In ar, this message translates to:
  /// **'فبراير'**
  String get february;

  /// No description provided for @march.
  ///
  /// In ar, this message translates to:
  /// **'مارس'**
  String get march;

  /// No description provided for @april.
  ///
  /// In ar, this message translates to:
  /// **'أبريل'**
  String get april;

  /// No description provided for @may.
  ///
  /// In ar, this message translates to:
  /// **'مايو'**
  String get may;

  /// No description provided for @june.
  ///
  /// In ar, this message translates to:
  /// **'يونيو'**
  String get june;

  /// No description provided for @july.
  ///
  /// In ar, this message translates to:
  /// **'يوليو'**
  String get july;

  /// No description provided for @august.
  ///
  /// In ar, this message translates to:
  /// **'أغسطس'**
  String get august;

  /// No description provided for @september.
  ///
  /// In ar, this message translates to:
  /// **'سبتمبر'**
  String get september;

  /// No description provided for @october.
  ///
  /// In ar, this message translates to:
  /// **'أكتوبر'**
  String get october;

  /// No description provided for @november.
  ///
  /// In ar, this message translates to:
  /// **'نوفمبر'**
  String get november;

  /// No description provided for @december.
  ///
  /// In ar, this message translates to:
  /// **'ديسمبر'**
  String get december;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'جنيه'**
  String get currency;

  /// No description provided for @egp.
  ///
  /// In ar, this message translates to:
  /// **'ج.م'**
  String get egp;

  /// No description provided for @gram.
  ///
  /// In ar, this message translates to:
  /// **'جرام'**
  String get gram;

  /// No description provided for @piece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة'**
  String get piece;

  /// No description provided for @permissions.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحيات'**
  String get permissions;

  /// No description provided for @owner.
  ///
  /// In ar, this message translates to:
  /// **'المالك'**
  String get owner;

  /// No description provided for @manager.
  ///
  /// In ar, this message translates to:
  /// **'المدير'**
  String get manager;

  /// No description provided for @cashier.
  ///
  /// In ar, this message translates to:
  /// **'الكاشير'**
  String get cashier;

  /// No description provided for @installmentsManager.
  ///
  /// In ar, this message translates to:
  /// **'مدير الأقساط'**
  String get installmentsManager;

  /// No description provided for @allPermissions.
  ///
  /// In ar, this message translates to:
  /// **'جميع الصلاحيات'**
  String get allPermissions;

  /// No description provided for @viewOnly.
  ///
  /// In ar, this message translates to:
  /// **'عرض فقط'**
  String get viewOnly;

  /// No description provided for @canApprove.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه الموافقة'**
  String get canApprove;

  /// No description provided for @canReject.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه الرفض'**
  String get canReject;

  /// No description provided for @canCreate.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه الإنشاء'**
  String get canCreate;

  /// No description provided for @canEdit.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه التعديل'**
  String get canEdit;

  /// No description provided for @canDelete.
  ///
  /// In ar, this message translates to:
  /// **'يمكنه الحذف'**
  String get canDelete;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
