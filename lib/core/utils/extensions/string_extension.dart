extension StringExtension on String {
  /// Capitaliza la primera letra de cada palabra
  String get titleCase {
    if (isEmpty) return this;

    final words = split(' ');
    final capitalized = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    });

    return capitalized.join(' ');
  }

  /// Capitaliza solo la primera letra
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Valida si el string es un email válido
  bool get isValidEmail {
    if (isEmpty) return false;

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(this);
  }

  /// Trunca el texto a la longitud especificada y añade puntos suspensivos
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Convierte un string a formato placas de vehículo (XXX-000)
  String get formatLicensePlate {
    if (isEmpty) return this;

    // Eliminar espacios y guiones existentes
    final cleaned = replaceAll(' ', '').replaceAll('-', '');

    if (cleaned.length < 6) return this;

    // Formato común para placas: 3 letras y 3 números
    final letters = cleaned.substring(0, 3).toUpperCase();
    final numbers = cleaned.substring(3, 6);

    return '$letters-$numbers';
  }

  /// Formatea un número VIN (Número de identificación del vehículo)
  String get formatVIN {
    if (isEmpty) return this;

    // Eliminar espacios y otros caracteres no alfanuméricos
    final cleaned = replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();

    // Un VIN típico tiene 17 caracteres
    if (cleaned.length != 17) return cleaned;

    // Formatear en grupos para mejor legibilidad
    return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 8)}-${cleaned.substring(8, 13)}-${cleaned.substring(13, 17)}';
  }

  /// Convierte string a doble, con manejo de errores
  double toDoubleOrZero() {
    if (isEmpty) return 0.0;
    return double.tryParse(replaceAll(',', '.')) ?? 0.0;
  }

  /// Convierte string a entero, con manejo de errores
  int toIntOrZero() {
    if (isEmpty) return 0;
    return int.tryParse(this) ?? 0;
  }
}
