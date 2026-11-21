import 'package:intl/intl.dart';

class NumberFormatters {
  NumberFormatters._();

  /// Format currency to 2 decimal places
  static String formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  /// Format weight to 3 decimal places
  static String formatWeight(double weight) {
    return weight.toStringAsFixed(3);
  }

  /// Format percentage to 1 decimal place
  static String formatPercentage(double percent) {
    return percent.toStringAsFixed(1);
  }

  /// Format number with thousand separators
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number);
  }

  /// Parse string to double safely
  static double? parseDouble(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }

  /// Parse string to int safely
  static int? parseInt(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }
}
