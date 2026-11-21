/// حالات طلب الموافقة
enum ApprovalStatus {
  pending,    // معلق - ينتظر القرار
  approved,   // تمت الموافقة
  rejected,   // مرفوض
  unknown;    // النتيجة غير مؤكدة
  
  String get displayName {
    switch (this) {
      case ApprovalStatus.pending:
        return 'معلق';
      case ApprovalStatus.approved:
        return 'تمت الموافقة';
      case ApprovalStatus.rejected:
        return 'مرفوض';
      case ApprovalStatus.unknown:
        return 'غير مؤكد';
    }
  }
  
  static ApprovalStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ApprovalStatus.pending;
      case 'approved':
        return ApprovalStatus.approved;
      case 'rejected':
        return ApprovalStatus.rejected;
      case 'unknown':
        return ApprovalStatus.unknown;
      default:
        return ApprovalStatus.pending;
    }
  }
}

/// ملخص طلب الموافقة (للقائمة)
class ApprovalSummary {
  ApprovalSummary({
    required this.id,
    required this.requestNumber,
    required this.employeeName,
    required this.branchName,
    required this.amountPiastres,
    required this.reason,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String requestNumber;
  final String employeeName;
  final String branchName;
  final int amountPiastres;
  final String reason;
  final DateTime createdAt;
  final ApprovalStatus status;
  
  // Helper للمبلغ بالجنيه
  double get amount => amountPiastres / 100;
  
  factory ApprovalSummary.fromJson(Map<String, dynamic> json) {
    return ApprovalSummary(
      id: json['id'] as String,
      requestNumber: json['request_number'] as String,
      employeeName: json['employee_name'] as String,
      branchName: json['branch_name'] as String,
      amountPiastres: json['amount_piastres'] as int,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: ApprovalStatus.fromString(json['status'] as String),
    );
  }
}

/// تفاصيل طلب الموافقة (للشاشة الثانية)
class ApprovalDetail {
  ApprovalDetail({
    required this.id,
    required this.requestNumber,
    required this.version,
    required this.employeeId,
    required this.employeeName,
    required this.branchId,
    required this.branchName,
    required this.amountPiastres,
    required this.reason,
    required this.operationDetails,
    required this.createdAt,
    required this.status,
    this.warningMessage,
  });

  final String id;
  final String requestNumber;
  final int version;              // رقم نسخة الطلب
  final String employeeId;
  final String employeeName;
  final String branchId;
  final String branchName;
  final int amountPiastres;
  final String reason;
  final Map<String, dynamic> operationDetails;  // تفاصيل العملية
  final DateTime createdAt;
  final ApprovalStatus status;
  final String? warningMessage;   // تحذيرات تحتاج انتباه
  
  // Helper
  double get amount => amountPiastres / 100;
  
  factory ApprovalDetail.fromJson(Map<String, dynamic> json) {
    return ApprovalDetail(
      id: json['id'] as String,
      requestNumber: json['request_number'] as String,
      version: json['version'] as int,
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String,
      branchId: json['branch_id'] as String,
      branchName: json['branch_name'] as String,
      amountPiastres: json['amount_piastres'] as int,
      reason: json['reason'] as String,
      operationDetails: json['operation_details'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: ApprovalStatus.fromString(json['status'] as String),
      warningMessage: json['warning_message'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_number': requestNumber,
      'version': version,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'branch_id': branchId,
      'branch_name': branchName,
      'amount_piastres': amountPiastres,
      'reason': reason,
      'operation_details': operationDetails,
      'created_at': createdAt.toIso8601String(),
      'status': status.name,
      'warning_message': warningMessage,
    };
  }
  
  ApprovalDetail copyWith({
    String? id,
    String? requestNumber,
    int? version,
    String? employeeId,
    String? employeeName,
    String? branchId,
    String? branchName,
    int? amountPiastres,
    String? reason,
    Map<String, dynamic>? operationDetails,
    DateTime? createdAt,
    ApprovalStatus? status,
    String? warningMessage,
  }) {
    return ApprovalDetail(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      version: version ?? this.version,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      amountPiastres: amountPiastres ?? this.amountPiastres,
      reason: reason ?? this.reason,
      operationDetails: operationDetails ?? this.operationDetails,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      warningMessage: warningMessage ?? this.warningMessage,
    );
  }
}

/// قرار الموافقة/الرفض
class ApprovalDecision {
  ApprovalDecision({
    required this.idempotencyKey,   // مفتاح ثابت لمنع التكرار
    required this.requestId,
    required this.requestVersion,
    required this.approved,         // true = موافقة, false = رفض
    this.rejectionReason,
    required this.timestamp,
  });

  final String idempotencyKey;
  final String requestId;
  final int requestVersion;
  final bool approved;
  final String? rejectionReason;
  final DateTime timestamp;
  
  Map<String, dynamic> toJson() {
    return {
      'idempotency_key': idempotencyKey,
      'request_id': requestId,
      'request_version': requestVersion,
      'approved': approved,
      'rejection_reason': rejectionReason,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// إحصائيات الموافقات
class ApprovalStats {
  ApprovalStats({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  final int total;
  final int pending;
  final int approved;
  final int rejected;
  
  factory ApprovalStats.fromJson(Map<String, dynamic> json) {
    return ApprovalStats(
      total: json['total'] as int,
      pending: json['pending'] as int,
      approved: json['approved'] as int,
      rejected: json['rejected'] as int,
    );
  }
}