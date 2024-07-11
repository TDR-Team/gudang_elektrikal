import 'package:intl/intl.dart';

String formatFullDate(DateTime date) {
  return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
}

String formatCompactDate(DateTime date) {
  return DateFormat('dd MMM yyyy', 'id_ID').format(date);
}
