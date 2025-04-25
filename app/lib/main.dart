import 'package:app/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await EnvConfig.load();

  // Initialize Parse SDK with environment configuration
  await Parse().initialize(
    dotenv.env['PARSE_APP_ID'] ?? '',
    dotenv.env['PARSE_SERVER_URL'] ?? '',
    clientKey: dotenv.env['PARSE_CLIENT_KEY'],
    debug: true,
  );

  // Start the application
  runApp(MyApp());
}
