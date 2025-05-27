import 'package:intl/intl.dart';

String formatTanggal(DateTime date, String locale) {
  if (locale == 'ar') {
    return DateFormat('EEEE, d MMMM y', locale).format(date);
  } else if (locale == 'en') {
    return DateFormat('EEEE, d MMMM y', locale).format(date);
  }
  return DateFormat('EEEE, d MMMM y', locale).format(date);
}
