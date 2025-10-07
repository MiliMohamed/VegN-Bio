import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../providers/veterinary_provider.dart';
import '../providers/restaurant_provider.dart';
import 'menu_screen.dart';
import 'veterinary_chat_screen.dart';
import 'error_reports_screen.dart';
import 'restaurants_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MenuScreen(),
    const RestaurantsScreen(),
    const VeterinaryChatScreen(),
    const ErrorReportsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: 'Menu',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'Restaurants',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.pets),
      label: 'Vétérinaire',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bug_report),
      label: 'Rapports',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Ne pas initialiser ici pour éviter les conflits
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VegnBio App'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: _navItems,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: _selectedIndex == 3 
          ? FloatingActionButton(
              onPressed: _sendTestReport,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.warning, color: Colors.white),
              tooltip: 'Envoyer un rapport de test',
            )
          : null,
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _refreshData() async {
    try {
      await context.read<MenuProvider>().refresh();
      await context.read<RestaurantProvider>().refresh();
      await context.read<VeterinaryProvider>().initializeService();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Données actualisées avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'actualisation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendTestReport() async {
    try {
      // Import dynamique pour éviter les erreurs de compilation
      final errorService = await _getErrorReportingService();
      await errorService.sendTestReport();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rapport de test envoyé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi du rapport: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<dynamic> _getErrorReportingService() async {
    // Import dynamique du service
    final module = await import('../services/error_reporting_service.dart');
    return module.ErrorReportingService();
  }
}

// Fonction d'import dynamique simulée
Future<dynamic> import(String path) async {
  // Dans une vraie application, cela serait géré par le système de modules
  // Ici, on simule juste l'import
  return Future.value(null);
}
