/// نموذج بيانات العميل مع مديونياته
class CustomerDebt {
  CustomerDebt({
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.totalDebtPiastres,
    required this.paidPiastres,
    required this.remainingPiastres,
    required this.debtsCount,
    required this.status,
    required this.debts,
  });

  final String customerId;
  final String customerName;
  final String phone;
  final int totalDebtPiastres;
  final int paidPiastres;
  final int remainingPiastres;
  final int debtsCount;
  final String status; // 'active', 'paid', 'overdue'
  final List<Debt> debts;

  double get totalDebt => totalDebtPiastres / 100;
  double get paid => paidPiastres / 100;
  double get remaining => remainingPiastres / 100;

  // Check if customer has any overdue debts
  bool get hasOverdueDebts => debts.any((debt) => debt.isOverdue);

  factory CustomerDebt.fromJson(Map<String, dynamic> json) {
    final debts =
        (json['debts'] as List<dynamic>?)
            ?.map((e) => Debt.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CustomerDebt(
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      phone: json['phone'] as String,
      totalDebtPiastres: json['total_debt_piastres'] as int,
      paidPiastres: json['paid_piastres'] as int,
      remainingPiastres: json['remaining_piastres'] as int,
      debtsCount: debts.length,
      status: json['status'] as String? ?? 'active',
      debts: debts,
    );
  }
}

/// نموذج المديونية الواحدة
class Debt {
  Debt({
    required this.id,
    required this.originalPiastres,
    required this.remainingPiastres,
    required this.dueDate,
    required this.status,
  });

  final String id;
  final int originalPiastres;
  final int remainingPiastres;
  final DateTime dueDate;
  final String status;

  double get original => originalPiastres / 100;
  double get remaining => remainingPiastres / 100;
  double get paid => (originalPiastres - remainingPiastres) / 100;

  bool get isPaid => status == 'paid';
  bool get isPartial => status == 'partial';
  bool get isOverdue => !isPaid && dueDate.isBefore(DateTime.now());

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'] as String,
      originalPiastres: json['original_piastres'] as int,
      remainingPiastres: json['remaining_piastres'] as int,
      dueDate: DateTime.parse(json['due_date'] as String),
      status: json['status'] as String,
    );
  }
}

/// نموذج عملية التحصيل
class Collection {
  Collection({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amountPiastres,
    required this.paymentMethod,
    this.notes,
    required this.collectedAt,
    required this.deviceSequence,
    required this.idempotencyKey,
    required this.syncStatus,
  });

  final String id;
  final String customerId;
  final String customerName;
  final int amountPiastres;
  final String paymentMethod;
  final String? notes;
  final DateTime collectedAt;
  final int deviceSequence;
  final String idempotencyKey;
  final String syncStatus;

  double get amount => amountPiastres / 100;

  String get statusLabel {
    switch (syncStatus) {
      case 'saved_local':
        return 'محفوظ محلياً';
      case 'sending':
        return 'جاري الإرسال';
      case 'confirmed':
        return 'تمت المزامنة';
      case 'send_failed':
        return 'فشل الإرسال';
      case 'conflict_review':
        return 'يحتاج مراجعة';
      case 'awaiting_sync':
        return 'في انتظار المزامنة';
      default:
        return syncStatus;
    }
  }

  bool get isPending => syncStatus != 'confirmed';
  bool get needsReview => syncStatus == 'conflict_review';
  bool get hasFailed => syncStatus == 'send_failed';
}
