import 'package:intl/intl.dart';

/// Clase para el formateo de valores monetarios y kilómetros
class CurrencyFormatter {
  // Formateador para moneda (EUR por defecto)
  static NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_ES',
    symbol: '€',
    decimalDigits: 2,
  );

  // Formateador para kilómetros
  static NumberFormat _mileageFormat = NumberFormat.decimalPattern('es_ES');

  // Formateador para litros
  static NumberFormat _litersFormat = NumberFormat.decimalPattern('es_ES');

  // Formateador para cantidades decimales
  static NumberFormat _decimalFormat = NumberFormat.decimalPattern('es_ES');

  /// Formatea un valor a moneda (€)
  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  /// Formatea un valor a kilómetros
  static String formatMileage(int mileage) {
    return '${_mileageFormat.format(mileage)} km';
  }

  /// Formatea un valor a litros
  static String formatLiters(double liters) {
    return '${_litersFormat.format(liters)} L';
  }

  /// Formatea un valor decimal con 2 decimales
  static String formatDecimal(double value, {int digits = 2}) {
    final formatter = NumberFormat.decimalPattern('es_ES')
      ..minimumFractionDigits = digits
      ..maximumFractionDigits = digits;

    return formatter.format(value);
  }

  /// Formatea un precio por litro para combustible
  static String formatFuelPrice(double pricePerLiter) {
    return '${_decimalFormat.format(pricePerLiter)} €/L';
  }

  /// Formatea un consumo medio (L/100km)
  static String formatFuelConsumption(double consumption) {
    return '${_decimalFormat.format(consumption)} L/100km';
  }

  /// Configura el símbolo de moneda
  static void setCurrencySymbol(String symbol) {
    // Crear un nuevo formateador con el símbolo deseado
    _currencyFormat = NumberFormat.currency(
      locale: _currencyFormat.locale,
      symbol: symbol,
      decimalDigits: 2,
    );
  }

  /// Configura la localización
  static void setLocale(String locale) {
    // Recrear los formateadores con la nueva localización
    _currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: _currencyFormat.currencySymbol,
      decimalDigits: 2,
    );
    _mileageFormat = NumberFormat.decimalPattern(locale);
    _litersFormat = NumberFormat.decimalPattern(locale);
    _decimalFormat = NumberFormat.decimalPattern(locale);
  }
}
