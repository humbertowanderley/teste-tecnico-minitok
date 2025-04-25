import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Carrega as variáveis de ambiente do arquivo .env
  static Future<void> load() async {
    await dotenv.load();  // Especifica o caminho para o arquivo .env na pasta env
  }

  // Acesso às variáveis de ambiente carregadas
  static String? get parseAppId => dotenv.env['PARSE_APP_ID'];
  static String? get parseServerUrl => dotenv.env['PARSE_SERVER_URL'];
  static String? get parseClientKey => dotenv.env['PARSE_CLIENT_KEY'];
}
