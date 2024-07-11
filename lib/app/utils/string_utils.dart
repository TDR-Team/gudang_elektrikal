import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String censorEmail(String email) {
  return email.replaceRange(3, email.indexOf('@'), '*' * 3);
}

String getTimeInDays(int inputTime) {
    // Mengonversi waktu dari jam menjadi hari
    int hours = inputTime;
    int days = (hours / 24).ceil();
    return '$days hari';
  }

String formatCurrency(double value) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(value);
}

int calculateAge(DateTime? birthDate) {
  if (birthDate != null) {
    return DateTime.now().year - birthDate.year;
  } else {
    return 0;
  }
}

String fullName({
  required String firstName,
  required String lastName,
}) {
  String sanitizedFirstName = firstName.trim().replaceAll(RegExp(r'\s+'), ' ');
  String sanitizedLastName = lastName.trim().replaceAll(RegExp(r'\s+'), ' ');
  String fullName = "$sanitizedFirstName $sanitizedLastName";

  const maxLength = 17;

  if (fullName.length > maxLength) {
    List<String> nameParts = fullName.split(' ');
    List<String> names = fullName.split(' ');
    var increment = 0;

    while (names.join(' ').length > maxLength) {
      // Start loop from the second index
      names = [];

      for (int i = 0; i < nameParts.length; i++) {
        String name = nameParts[i];
        names.add(
            i == increment ? name : '${name.characters.first.toUpperCase()}.');
      }
      increment++;
    }

    return names.join(' ');
  } else {
    return fullName;
  }
}

String capitalizeEachWord(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input.split(' ').map((word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

String formattingTitleDate(
    {required DateTime startDate, required DateTime endDate}) {
  return startDate.month == endDate.month
      ? '${DateFormat('dd', 'id').format(startDate)} - ${DateFormat('dd MMMM', 'id').format(endDate)}'
      : '${DateFormat('dd MMMM', 'id').format(startDate)} - ${DateFormat('dd MMMM', 'id').format(endDate)}';
}

String formattingJobDate(
    {required DateTime startDate, required DateTime endDate}) {
  final DateFormat dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

  String formattedStartDate = dateFormat.format(startDate);
  String formattedEndDate = dateFormat.format(endDate);

  return '$formattedStartDate - $formattedEndDate';
}
