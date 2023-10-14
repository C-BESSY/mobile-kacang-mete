import 'package:intl/intl.dart';

String capitalizeWord(String word) {
  return word[0].toUpperCase() + word.substring(1);
}

String intToIDR(int value) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
  );
  return formatter.format(value);
}

String formatDate(String inputDate) {
  try {
    final parsedDate = DateTime.parse(inputDate);
    final List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final day = parsedDate.day.toString().padLeft(2, '0');
    final month = monthNames[parsedDate.month - 1];
    final year = parsedDate.year.toString().substring(2);

    return '$day $month $year';
  } catch (e) {
    return 'Invalid Date';
  }
}

String dateTimeToMonth(DateTime date) {
  return DateFormat('MMMM yyyy').format(date);
}
