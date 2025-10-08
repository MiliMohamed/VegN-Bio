import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'providers/menu_provider.dart';
import 'providers/allergen_provider.dart';
import 'providers/chatbot_provider.dart';
import 'services/api_service.dart';
import 'services/allergen_service.dart';
import 'services/chatbot_service.dart';
import 'services/error_reporting_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
  try {
    await dotenv.load(fileName: "assets/.env");
    print('✅ Environment variables loaded successfully');
    print('API_BASE_URL: ${dotenv.env['API_BASE_URL']}');
  } catch (e) {
    print('⚠️ Failed to load .env file: $e');
    print('Using fallback environment variables');
    // Si le fichier .env n'existe pas, utiliser les valeurs par défaut
    dotenv.env['API_BASE_URL'] = 'https://vegn-bio-backend.onrender.com/api/v1';
    dotenv.env['API_TIMEOUT'] = '30000';
    dotenv.env['ERROR_REPORTING_ENABLED'] = 'true';
    dotenv.env['ERROR_REPORTING_URL'] = 'https://vegn-bio-backend.onrender.com/api/v1/errors';
    dotenv.env['CHATBOT_API_URL'] = 'https://vegn-bio-backend.onrender.com/api/v1/chatbot';
    dotenv.env['CHATBOT_LEARNING_ENABLED'] = 'true';
    dotenv.env['CHATBOT_CONFIDENCE_THRESHOLD'] = '0.7';
  }
  
  // Initialiser les services
  ApiService().initialize();
  AllergenService().initialize();
  ChatbotService().initialize();
  ErrorReportingService().initialize();
  
  // Configurer le logger
  Logger.level = Level.debug;
  
  runApp(const VegnBioApp());
}

class VegnBioApp extends StatelessWidget {
  const VegnBioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => AllergenProvider()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
      ],
      child: MaterialApp(
        title: 'VegN-Bio Mobile',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}