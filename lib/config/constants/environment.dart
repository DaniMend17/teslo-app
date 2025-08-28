import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnviroment() async => await dotenv.load(fileName: ".env");

  static String apiUrl =
      dotenv.env['API_URL'] ?? 'No se ha configurado la url de la api';
}
