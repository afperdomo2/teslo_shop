class WrongCredentials implements Exception {
  final String message;

  WrongCredentials({this.message = 'Credenciales incorrectas'});

  @override
  String toString() => 'WrongCredentials: $message';
}

class InvalidToken implements Exception {
  final String message;

  InvalidToken({this.message = 'Token inválido'});

  @override
  String toString() => 'InvalidToken: $message';
}
