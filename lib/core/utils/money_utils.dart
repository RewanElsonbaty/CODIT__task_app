import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Money stored as integer piastres (1 EGP = 100 piastres).
class Money {
  const Money(this.piastres);

  final int piastres;

  static const int piastresPerPound = 100;

  factory Money.fromPounds(String pounds) {
    final d = Decimal.parse(pounds);
    final scaled = (d * Decimal.fromInt(piastresPerPound)).toDouble().round();
    return Money(scaled);
  }

  Decimal toPoundsDecimal() => Decimal.parse((piastres / piastresPerPound).toString());

  String formatEgp() {
    final formatter = NumberFormat.currency(
      locale: 'ar_EG',
      symbol: 'ج.م',
      decimalDigits: 2,
    );
    return formatter.format(toPoundsDecimal().toDouble());
  }

  Money operator +(Money other) => Money(piastres + other.piastres);
  Money operator -(Money other) => Money(piastres - other.piastres);

  bool operator <(Money other) => piastres < other.piastres;
}

int roundPoundsToPiastresHalfUp(Decimal pounds) {
  final scaled = pounds * Decimal.fromInt(Money.piastresPerPound);
  return scaled.toDouble().round();
}

Decimal mgToGrams(int mg) => Decimal.parse((mg / 1000.0).toString());