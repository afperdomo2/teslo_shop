import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Retorna una cadena formateada para la fecha en formato dd/MM/yyyy
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Retorna una cadena formateada para la fecha en formato dd MMM yyyy
  String get formattedDateWithMonth {
    return DateFormat('dd MMM yyyy', 'es').format(this);
  }

  /// Retorna una cadena formateada para la fecha y hora en formato dd/MM/yyyy HH:mm
  String get formattedDateTime {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Retorna una cadena formateada relativa a la fecha actual
  /// Por ejemplo: "Hoy", "Ayer", "Hace 2 días", etc.
  String get relativeDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(year, month, day);

    if (dateToCompare == today) {
      return 'Hoy';
    } else if (dateToCompare == yesterday) {
      return 'Ayer';
    } else if (dateToCompare.isAfter(today.subtract(const Duration(days: 7)))) {
      return 'Hace ${today.difference(dateToCompare).inDays} días';
    } else {
      return formattedDate;
    }
  }

  /// Retorna la fecha sin la parte de la hora
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  /// Calcula la diferencia en días con otra fecha
  int daysDifference(DateTime other) {
    final date1 = dateOnly;
    final date2 = DateTime(other.year, other.month, other.day);
    return date1.difference(date2).inDays.abs();
  }

  /// Verifica si la fecha está dentro de un rango de días desde hoy
  bool isWithinDays(int days) {
    final now = DateTime.now().dateOnly;
    final diff = dateOnly.difference(now).inDays.abs();
    return diff <= days;
  }

  /// Añade meses a la fecha actual
  DateTime addMonths(int months) {
    int newMonth = month + months;
    int yearsToAdd = (newMonth - 1) ~/ 12;
    int finalMonth = newMonth - (yearsToAdd * 12);

    if (finalMonth <= 0) {
      yearsToAdd--;
      finalMonth += 12;
    }

    int finalYear = year + yearsToAdd;

    // Manejar días en meses con menos días
    int finalDay = day;
    int lastDayOfMonth = DateTime(finalYear, finalMonth + 1, 0).day;
    if (finalDay > lastDayOfMonth) {
      finalDay = lastDayOfMonth;
    }

    return DateTime(
        finalYear, finalMonth, finalDay, hour, minute, second, millisecond, microsecond);
  }
}
