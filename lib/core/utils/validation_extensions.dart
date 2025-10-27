import 'package:form_validator/form_validator.dart';

/// Extensiones para ValidationBuilder que añaden validaciones numéricas
extension NumericValidationExtension on ValidationBuilder {
  /// Valida que el valor sea un número válido
  ValidationBuilder isNumber([String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return message ?? 'Debe ser un número válido';
      }
      return null;
    });
  }

  /// Valida que el valor sea un número con un valor mínimo
  ValidationBuilder min(num minValue, [String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Debe ser un número válido';
      }

      if (numValue < minValue) {
        return message ?? 'El valor debe ser mayor o igual a $minValue';
      }
      return null;
    });
  }

  /// Valida que el valor sea un número con un valor máximo
  ValidationBuilder max(num maxValue, [String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Debe ser un número válido';
      }

      if (numValue > maxValue) {
        return message ?? 'El valor debe ser menor o igual a $maxValue';
      }
      return null;
    });
  }

  /// Valida que el valor sea un número dentro de un rango [minValue, maxValue]
  ValidationBuilder range(num minValue, num maxValue, [String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Debe ser un número válido';
      }

      if (numValue < minValue || numValue > maxValue) {
        return message ?? 'El valor debe estar entre $minValue y $maxValue';
      }
      return null;
    });
  }

  /// Valida que el valor sea un número entero
  ValidationBuilder integer([String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final intValue = int.tryParse(value);
      if (intValue == null) {
        return message ?? 'Debe ser un número entero';
      }
      return null;
    });
  }

  /// Valida que el valor sea un número decimal con precisión específica
  ValidationBuilder decimal(int precision, [String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Debe ser un número válido';
      }

      // Verificar que el número de decimales no exceda la precisión
      final parts = value.split('.');
      if (parts.length > 1 && parts[1].length > precision) {
        return message ?? 'Debe tener máximo $precision decimales';
      }

      return null;
    });
  }

  /// Valida que el valor sea un número positivo (mayor que cero)
  ValidationBuilder positive([String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Debe ser un número válido';
      }

      if (numValue <= 0) {
        return message ?? 'Debe ser un número positivo';
      }
      return null;
    });
  }
}

extension SecurityValidationExtension on ValidationBuilder {
  // Valida una contraseña segura con mínimo 6 caracteres, al menos una mayúscula, una minúscula, un número
  ValidationBuilder isSecurePassword([String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null; // Es opcional
      final RegExp passwordRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$',
        caseSensitive: false,
      );
      if (!passwordRegExp.hasMatch(value)) {
        return message ??
            'La contraseña debe tener al menos 6 caracteres, una mayúscula, una minúscula y un número';
      }
      return null;
    });
  }
}

/// Extensiones para ValidationBuilder que añaden validaciones de formato
extension FormatValidationExtension on ValidationBuilder {
  /// Valida que el valor sea un slug válido (letras minúsculas, números y guiones)
  ValidationBuilder isSlug([String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      final RegExp slugRegExp = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
      if (!slugRegExp.hasMatch(value)) {
        return message ?? 'Solo se permiten letras minúsculas, números y guiones';
      }
      return null;
    });
  }

  /// Valida que el valor tenga una longitud mínima específica
  ValidationBuilder minLength(int minLength, [String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < minLength) {
        return message ?? 'Debe tener al menos $minLength caracteres';
      }
      return null;
    });
  }

  /// Valida que el valor tenga una longitud máxima específica
  ValidationBuilder maxLength(int maxLength, [String? message]) {
    return add((value) {
      if (value == null || value.isEmpty) return null;

      if (value.length > maxLength) {
        return message ?? 'Debe tener máximo $maxLength caracteres';
      }
      return null;
    });
  }
}
