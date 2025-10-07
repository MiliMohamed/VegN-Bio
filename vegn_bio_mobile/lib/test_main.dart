import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
  await dotenv.load(fileName: "assets/.env");
  
  print('🔗 Configuration chargée:');
  print('API_BASE_URL: ${dotenv.env['API_BASE_URL']}');
  print('CHATBOT_API_URL: ${dotenv.env['CHATBOT_API_URL']}');
  print('ERROR_REPORTING_URL: ${dotenv.env['ERROR_REPORTING_URL']}');
  
  // Test de connectivité
  await testBackendConnection();
  
  runApp(const TestApp());
}

Future<void> testBackendConnection() async {
  try {
    final dio = Dio();
    final response = await dio.get('${dotenv.env['API_BASE_URL']}/restaurants');
    print('✅ Backend accessible - Status: ${response.statusCode}');
    print('📊 Données reçues: ${response.data.length} restaurants');
  } catch (e) {
    print('❌ Erreur de connexion au backend: $e');
  }
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VegN-Bio Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<dynamic> restaurants = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get('${dotenv.env['API_BASE_URL']}/restaurants');
      
      setState(() {
        restaurants = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> testChatbot() async {
    try {
      final dio = Dio();
      final response = await dio.post('${dotenv.env['CHATBOT_API_URL']}/breeds');
      print('✅ Chatbot accessible - Races: ${response.data}');
    } catch (e) {
      print('❌ Erreur chatbot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VegN-Bio Test'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test de Connectivité Backend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Configuration:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('API: ${dotenv.env['API_BASE_URL']}'),
                    Text('Chatbot: ${dotenv.env['CHATBOT_API_URL']}'),
                    Text('Errors: ${dotenv.env['ERROR_REPORTING_URL']}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test des restaurants
            const Text('Restaurants:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('❌ Erreur: $error'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: loadRestaurants,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.restaurant),
                        title: Text(restaurant['name'] ?? 'Sans nom'),
                        subtitle: Text(restaurant['address'] ?? ''),
                        trailing: restaurant['isActive'] == true
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Boutons de test
            Row(
              children: [
                ElevatedButton(
                  onPressed: loadRestaurants,
                  child: const Text('Tester Restaurants'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: testChatbot,
                  child: const Text('Tester Chatbot'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
