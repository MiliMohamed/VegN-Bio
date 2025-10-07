import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../models/menu_item.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/menu_filters.dart';
import 'menu_item_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Initialiser les données du menu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadMenuItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<MenuProvider>().searchMenuItems(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildFilters(),
          Expanded(
            child: Consumer<MenuProvider>(
              builder: (context, menuProvider, child) {
                if (menuProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (menuProvider.error != null) {
                  return _buildErrorWidget(menuProvider.error!);
                }

                if (menuProvider.filteredItems.isEmpty) {
                  return _buildEmptyWidget();
                }

                return _buildMenuList(menuProvider.filteredItems);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.restaurant_menu,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu Bio & Végétarien',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Découvrez nos délicieux plats',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Consumer<MenuProvider>(
            builder: (context, menuProvider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${menuProvider.filteredItems.length} plats',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Rechercher un plat...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, child) {
        return MenuFilters(
          categories: menuProvider.categories,
          selectedCategory: menuProvider.selectedCategory,
          excludedAllergens: menuProvider.excludedAllergens,
          showVeganOnly: menuProvider.showVeganOnly,
          showVegetarianOnly: menuProvider.showVegetarianOnly,
          showGlutenFreeOnly: menuProvider.showGlutenFreeOnly,
          onCategoryChanged: menuProvider.setCategory,
          onAllergenToggled: menuProvider.toggleAllergen,
          onVeganToggled: () => menuProvider.setVeganOnly(!menuProvider.showVeganOnly),
          onVegetarianToggled: () => menuProvider.setVegetarianOnly(!menuProvider.showVegetarianOnly),
          onGlutenFreeToggled: () => menuProvider.setGlutenFreeOnly(!menuProvider.showGlutenFreeOnly),
          onClearFilters: menuProvider.clearFilters,
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<MenuProvider>().refresh(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun plat trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de modifier vos critères de recherche',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<MenuProvider>().clearFilters(),
            child: const Text('Effacer les filtres'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(List<MenuItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuItemCard(
          menuItem: item,
          onTap: () => _navigateToDetail(item),
        );
      },
    );
  }

  void _navigateToDetail(MenuItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuItemDetailScreen(menuItem: item),
      ),
    );
  }
}
