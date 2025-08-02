import 'package:intl/intl.dart';

/// Utilidades para formatear valores en la aplicación
class FormatUtils {
  /// Formatea un valor como moneda (por defecto en pesos colombianos)
  static String formatCurrency(double value, {String locale = 'es_CO', String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// Formatea un valor como kilometraje
  static String formatMileage(int kilometers) {
    final formatter = NumberFormat.decimalPattern('es_CO');
    return '${formatter.format(kilometers)} km';
  }

  /// Formatea una fecha
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format, 'es_CO').format(date);
  }

  /// Formatea una fecha y hora
  static String formatDateTime(DateTime dateTime, {String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format, 'es_CO').format(dateTime);
  }
}
