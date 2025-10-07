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
  await dotenv.load(fileName: "assets/.env");
  
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