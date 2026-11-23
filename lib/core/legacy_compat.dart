/// Legacy Compatibility Layer
/// طبقة توافق للكود القديم - لا تستخدم في الكود الجديد
/// 
/// هذا الملف يوفر compatibility للكود القديم الموجود في المشروع
/// بدون كسر الوظائف الجديدة المكتملة

library;

// Legacy Gold Sales Types (deprecated - use gold_models.dart instead)
enum GoldKarat {
  k18,
  k21,
  k24;

  String get displayName {
    switch (this) {
      case GoldKarat.k18:
        return '18';
      case GoldKarat.k21:
        return '21';
      case GoldKarat.k24:
        return '24';
    }
  }
}

// Legacy Product (deprecated)
class GoldProduct {
  final String id;
  final String code;
  final String barcode;
  final String name;
  final GoldKarat karat;
  final int grossWeightMg;
  final int stonesWeightMg;
  final String category;
  final int pricePerGramPiastres;
  final int makingChargePerGramPiastres;
  final int taxPercentage;

  GoldProduct({
    required this.id,
    required this.code,
    required this.barcode,
    required this.name,
    required this.karat,
    required this.grossWeightMg,
    required this.stonesWeightMg,
    required this.category,
    required this.pricePerGramPiastres,
    required this.makingChargePerGramPiastres,
    required this.taxPercentage,
  });
}

// Legacy Invoice (deprecated)
class GoldInvoice {
  final String id;
  final String customerId;
  final DateTime timestamp;
  final List<dynamic> items;
  final int totalPiastres;

  GoldInvoice({
    required this.id,
    required this.customerId,
    required this.timestamp,
    required this.items,
    required this.totalPiastres,
  });
}

// Legacy Cubit (deprecated)
class GoldSaleCubit {
  void startNew() {}
  void addItem(dynamic item) {}
  void removeItem(String id) {}
  void save() {}
}

// Legacy State (deprecated)
class GoldSaleState {}

// Legacy Payment (deprecated)
class Payment {
  final String id;
  final int amount;
  final String method;

  Payment({required this.id, required this.amount, required this.method});
}

// Legacy PaymentLine (deprecated)  
class PaymentLine {
  final String method;
  final int amount;

  PaymentLine({required this.method, required this.amount});
}

// Legacy ExchangeWeightMg (deprecated)
class ExchangeWeightMg {
  final int weightMg;

  ExchangeWeightMg({required this.weightMg});
}

// Legacy lockedPrice (deprecated)
class LockedPrice {
  final int pricePiastres;

  LockedPrice({required this.pricePiastres});
}

// Legacy Seller (deprecated)
class Seller {
  final String id;
  final String name;

  Seller({required this.id, required this.name});
}

// Legacy Categories (deprecated)
enum GoldCategory {
  ring,
  necklace,
  bracelet,
  earring;

  String get displayName {
    switch (this) {
      case GoldCategory.ring:
        return 'خاتم';
      case GoldCategory.necklace:
        return 'سلسلة';
      case GoldCategory.bracelet:
        return 'أسورة';
      case GoldCategory.earring:
        return 'حلق';
    }
  }
}

class _ActionButtons {
  const _ActionButtons();
}
