/// نماذج طلبات التقسيط
/// 
/// يستخدم لطلب موافقة على تقسيط لعميل
/// المدير يرسل الطلب → المالك يوافق/يرفض

/// حالة طلب التقسيط
enum InstallmentRequestStatus {
  pending,    // معلق - ينتظر موافقة المالك
  approved,   // تمت الموافقة - يتم إضافته للأقساط
  rejected,   // مرفوض
  cancelled;  // ملغي
  
  String get displayName {
    switch (this) {
      case InstallmentRequestStatus.pending:
        return 'معلق';
      case InstallmentRequestStatus.approved:
        return 'تمت الموافقة';
      case InstallmentRequestStatus.rejected:
        return 'مرفوض';
      case InstallmentRequestStatus.cancelled:
        return 'ملغي';
    }
  }
  
  static InstallmentRequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return InstallmentRequestStatus.pending;
      case 'approved':
        return InstallmentRequestStatus.approved;
      case 'rejected':
        return InstallmentRequestStatus.rejected;
      case 'cancelled':
        return InstallmentRequestStatus.cancelled;
      default:
        return InstallmentRequestStatus.pending;
    }
  }
}

/// طلب تقسيط جديد (للإنشاء)
class CreateInstallmentRequest {
  CreateInstallmentRequest({
    required this.customerName,
    required this.customerId,
    required this.customerPhone,
    required this.nationalId,
    required this.invoiceId,
    required this.totalAmountPiastres,
    required this.downPaymentPiastres,
    required this.installmentAmountPiastres,
    required this.numberOfInstallments,
    required this.firstPaymentDate,
    required this.paymentInterval,
    required this.branchId,
    required this.branchName,
    required this.requestedBy,
    required this.requestedByName,
    this.notes,
  });

  final String customerName;
  final String customerId;
  final String customerPhone;
  final String nationalId;
  final String invoiceId;
  final int totalAmountPiastres;
  final int downPaymentPiastres;
  final int installmentAmountPiastres;
  final int numberOfInstallments;
  final DateTime firstPaymentDate;
  final String paymentInterval; // 'monthly', 'weekly', 'daily'
  final String branchId;
  final String branchName;
  final String requestedBy; // ID المدير
  final String requestedByName;
  final String? notes;

  // Helpers
  double get totalAmount => totalAmountPiastres / 100;
  double get downPayment => downPaymentPiastres / 100;
  double get installmentAmount => installmentAmountPiastres / 100;
  double get remainingAmount => (totalAmountPiastres - downPaymentPiastres) / 100;

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_id': customerId,
      'customer_phone': customerPhone,
      'national_id': nationalId,
      'invoice_id': invoiceId,
      'total_amount_piastres': totalAmountPiastres,
      'down_payment_piastres': downPaymentPiastres,
      'installment_amount_piastres': installmentAmountPiastres,
      'number_of_installments': numberOfInstallments,
      'first_payment_date': firstPaymentDate.toIso8601String(),
      'payment_interval': paymentInterval,
      'branch_id': branchId,
      'branch_name': branchName,
      'requested_by': requestedBy,
      'requested_by_name': requestedByName,
      'notes': notes,
    };
  }
}

/// طلب تقسيط (عرض كامل)
class InstallmentRequest {
  InstallmentRequest({
    required this.id,
    required this.requestNumber,
    required this.customerName,
    required this.customerId,
    required this.customerPhone,
    required this.nationalId,
    required this.invoiceId,
    required this.totalAmountPiastres,
    required this.downPaymentPiastres,
    required this.installmentAmountPiastres,
    required this.numberOfInstallments,
    required this.firstPaymentDate,
    required this.paymentInterval,
    required this.branchId,
    required this.branchName,
    required this.requestedBy,
    required this.requestedByName,
    required this.createdAt,
    required this.status,
    this.reviewedBy,
    this.reviewedByName,
    this.reviewedAt,
    this.rejectionReason,
    this.notes,
    this.version,
  });

  final String id;
  final String requestNumber;
  final String customerName;
  final String customerId;
  final String customerPhone;
  final String nationalId;
  final String invoiceId;
  final int totalAmountPiastres;
  final int downPaymentPiastres;
  final int installmentAmountPiastres;
  final int numberOfInstallments;
  final DateTime firstPaymentDate;
  final String paymentInterval;
  final String branchId;
  final String branchName;
  final String requestedBy;
  final String requestedByName;
  final DateTime createdAt;
  final InstallmentRequestStatus status;
  final String? reviewedBy;
  final String? reviewedByName;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final String? notes;
  final int? version;

  // Helpers
  double get totalAmount => totalAmountPiastres / 100;
  double get downPayment => downPaymentPiastres / 100;
  double get installmentAmount => installmentAmountPiastres / 100;
  double get remainingAmount => (totalAmountPiastres - downPaymentPiastres) / 100;
  
  bool get isPending => status == InstallmentRequestStatus.pending;
  bool get isApproved => status == InstallmentRequestStatus.approved;
  bool get isRejected => status == InstallmentRequestStatus.rejected;
  
  String get paymentIntervalArabic {
    switch (paymentInterval) {
      case 'monthly':
        return 'شهري';
      case 'weekly':
        return 'أسبوعي';
      case 'daily':
        return 'يومي';
      default:
        return paymentInterval;
    }
  }

  factory InstallmentRequest.fromJson(Map<String, dynamic> json) {
    return InstallmentRequest(
      id: json['id'] as String,
      requestNumber: json['request_number'] as String,
      customerName: json['customer_name'] as String,
      customerId: json['customer_id'] as String,
      customerPhone: json['customer_phone'] as String,
      nationalId: json['national_id'] as String,
      invoiceId: json['invoice_id'] as String,
      totalAmountPiastres: json['total_amount_piastres'] as int,
      downPaymentPiastres: json['down_payment_piastres'] as int,
      installmentAmountPiastres: json['installment_amount_piastres'] as int,
      numberOfInstallments: json['number_of_installments'] as int,
      firstPaymentDate: DateTime.parse(json['first_payment_date'] as String),
      paymentInterval: json['payment_interval'] as String,
      branchId: json['branch_id'] as String,
      branchName: json['branch_name'] as String,
      requestedBy: json['requested_by'] as String,
      requestedByName: json['requested_by_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: InstallmentRequestStatus.fromString(json['status'] as String),
      reviewedBy: json['reviewed_by'] as String?,
      reviewedByName: json['reviewed_by_name'] as String?,
      reviewedAt: json['reviewed_at'] != null 
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
      notes: json['notes'] as String?,
      version: json['version'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_number': requestNumber,
      'customer_name': customerName,
      'customer_id': customerId,
      'customer_phone': customerPhone,
      'national_id': nationalId,
      'invoice_id': invoiceId,
      'total_amount_piastres': totalAmountPiastres,
      'down_payment_piastres': downPaymentPiastres,
      'installment_amount_piastres': installmentAmountPiastres,
      'number_of_installments': numberOfInstallments,
      'first_payment_date': firstPaymentDate.toIso8601String(),
      'payment_interval': paymentInterval,
      'branch_id': branchId,
      'branch_name': branchName,
      'requested_by': requestedBy,
      'requested_by_name': requestedByName,
      'created_at': createdAt.toIso8601String(),
      'status': status.name,
      'reviewed_by': reviewedBy,
      'reviewed_by_name': reviewedByName,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'notes': notes,
      'version': version,
    };
  }

  InstallmentRequest copyWith({
    String? id,
    String? requestNumber,
    String? customerName,
    String? customerId,
    String? customerPhone,
    String? nationalId,
    String? invoiceId,
    int? totalAmountPiastres,
    int? downPaymentPiastres,
    int? installmentAmountPiastres,
    int? numberOfInstallments,
    DateTime? firstPaymentDate,
    String? paymentInterval,
    String? branchId,
    String? branchName,
    String? requestedBy,
    String? requestedByName,
    DateTime? createdAt,
    InstallmentRequestStatus? status,
    String? reviewedBy,
    String? reviewedByName,
    DateTime? reviewedAt,
    String? rejectionReason,
    String? notes,
    int? version,
  }) {
    return InstallmentRequest(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      customerPhone: customerPhone ?? this.customerPhone,
      nationalId: nationalId ?? this.nationalId,
      invoiceId: invoiceId ?? this.invoiceId,
      totalAmountPiastres: totalAmountPiastres ?? this.totalAmountPiastres,
      downPaymentPiastres: downPaymentPiastres ?? this.downPaymentPiastres,
      installmentAmountPiastres: installmentAmountPiastres ?? this.installmentAmountPiastres,
      numberOfInstallments: numberOfInstallments ?? this.numberOfInstallments,
      firstPaymentDate: firstPaymentDate ?? this.firstPaymentDate,
      paymentInterval: paymentInterval ?? this.paymentInterval,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedByName: requestedByName ?? this.requestedByName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedByName: reviewedByName ?? this.reviewedByName,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      notes: notes ?? this.notes,
      version: version ?? this.version,
    );
  }
}

/// قرار موافقة/رفض طلب التقسيط
class InstallmentRequestDecision {
  InstallmentRequestDecision({
    required this.requestId,
    required this.approved,
    this.rejectionReason,
    required this.reviewedBy,
    required this.reviewedByName,
    required this.reviewedAt,
  });

  final String requestId;
  final bool approved;
  final String? rejectionReason;
  final String reviewedBy;
  final String reviewedByName;
  final DateTime reviewedAt;

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'approved': approved,
      'rejection_reason': rejectionReason,
      'reviewed_by': reviewedBy,
      'reviewed_by_name': reviewedByName,
      'reviewed_at': reviewedAt.toIso8601String(),
    };
  }
}

/// ملخص طلب تقسيط (للقوائم)
class InstallmentRequestSummary {
  InstallmentRequestSummary({
    required this.id,
    required this.requestNumber,
    required this.customerName,
    required this.customerId,
    required this.totalAmountPiastres,
    required this.numberOfInstallments,
    required this.branchName,
    required this.requestedByName,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String requestNumber;
  final String customerName;
  final String customerId;
  final int totalAmountPiastres;
  final int numberOfInstallments;
  final String branchName;
  final String requestedByName;
  final DateTime createdAt;
  final InstallmentRequestStatus status;

  double get totalAmount => totalAmountPiastres / 100;
  bool get isPending => status == InstallmentRequestStatus.pending;

  factory InstallmentRequestSummary.fromJson(Map<String, dynamic> json) {
    return InstallmentRequestSummary(
      id: json['id'] as String,
      requestNumber: json['request_number'] as String,
      customerName: json['customer_name'] as String,
      customerId: json['customer_id'] as String,
      totalAmountPiastres: json['total_amount_piastres'] as int,
      numberOfInstallments: json['number_of_installments'] as int,
      branchName: json['branch_name'] as String,
      requestedByName: json['requested_by_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: InstallmentRequestStatus.fromString(json['status'] as String),
    );
  }
}
