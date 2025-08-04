import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvsConstants {
  static String apiUrl = dotenv.env['API_URL'] ?? 'https://localhost:3000/api';
}
