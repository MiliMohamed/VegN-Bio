import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../providers/allergen_provider.dart';
import '../providers/chatbot_provider.dart';
import 'restaurant_list_screen.dart';
import 'chatbot_screen.dart';
import 'allergen_filter_screen.dart';
import 'admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RestaurantListScreen(),
    const AllergenFilterScreen(),
    const ChatbotScreen(),
    const AdminDashboardScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialiser les providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadRestaurants();
      context.read<AllergenProvider>().loadAllergens();
      context.read<ChatbotProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VegN-Bio'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Allergènes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Vétérinaire',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}
