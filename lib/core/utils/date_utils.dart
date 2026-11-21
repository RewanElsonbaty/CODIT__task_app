import 'package:intl/intl.dart';

const cairoTimeZone = 'Africa/Cairo';

DateTime utcNow() => DateTime.now().toUtc();

String formatCairoDateTime(DateTime utc) {
  final local = utc.toLocal();
  return DateFormat('yyyy/MM/dd HH:mm', 'ar_EG').format(local);
}