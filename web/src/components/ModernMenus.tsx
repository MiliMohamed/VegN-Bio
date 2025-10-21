import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { ShoppingCart, Plus, Filter, Search, MapPin, Clock } from 'lucide-react';
import MenuItemCard from './MenuItemCard';
import ModernCart from './ModernCart';
import api from '../services/api';

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  category: string;
}

interface Restaurant {
  id: number;
  name: string;
  address: string;
  city: string;
  phone: string;
}

const ModernMenus: React.FC = () => {
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [selectedRestaurant, setSelectedRestaurant] = useState<number | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string>('');
  const [searchTerm, setSearchTerm] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isCartOpen, setIsCartOpen] = useState(false);
  const [cartItemCount, setCartItemCount] = useState(0);

  useEffect(() => {
    loadRestaurants();
  }, []);

  useEffect(() => {
    if (selectedRestaurant) {
      loadMenuItems(selectedRestaurant);
    }
  }, [selectedRestaurant]);

  const loadRestaurants = async () => {
    try {
      const response = await api.get('/api/v1/restaurants');
      setRestaurants(response.data);
      if (response.data.length > 0) {
        setSelectedRestaurant(response.data[0].id);
      }
    } catch (err: any) {
      setError('Erreur lors du chargement des restaurants');
      console.error('Error loading restaurants:', err);
    }
  };

  const loadMenuItems = async (restaurantId: number) => {
    try {
      setLoading(true);
      const response = await api.get(`/api/v1/menus/restaurant/${restaurantId}/active`);
      const menus = response.data;
      
      // Flatten menu items from all menus
      const allItems: MenuItem[] = [];
      menus.forEach((menu: any) => {
        if (menu.menuItems) {
          allItems.push(...menu.menuItems);
        }
      });
      
      setMenuItems(allItems);
      setError(null);
    } catch (err: any) {
      setError('Erreur lors du chargement des menus');
      console.error('Error loading menu items:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleAddToCart = async (item: MenuItem, quantity: number, specialInstructions?: string) => {
    try {
      await api.post('/api/v1/cart/items', {
        menuItemId: item.id,
        quantity: quantity,
        specialInstructions: specialInstructions
      });
      
      // Update cart item count
      setCartItemCount(prev => prev + quantity);
      
      // Show success message or notification
      console.log('Item added to cart successfully');
    } catch (err: any) {
      console.error('Error adding to cart:', err);
      throw err;
    }
  };

  const getCategories = () => {
    const categories = [...new Set(menuItems.map(item => item.category))];
    return categories.filter(Boolean);
  };

  const filteredItems = menuItems.filter(item => {
    const matchesRestaurant = !selectedRestaurant || true; // Already filtered by restaurant
    const matchesCategory = !selectedCategory || item.category === selectedCategory;
    const matchesSearch = !searchTerm || 
      item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.description.toLowerCase().includes(searchTerm.toLowerCase());
    
    return matchesRestaurant && matchesCategory && matchesSearch;
  });

  const selectedRestaurantData = restaurants.find(r => r.id === selectedRestaurant);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <h1 className="text-2xl font-bold text-gray-900">Menus & Commandes</h1>
              {selectedRestaurantData && (
                <div className="flex items-center space-x-2 text-sm text-gray-600">
                  <MapPin className="w-4 h-4" />
                  <span>{selectedRestaurantData.name}</span>
                </div>
              )}
            </div>
            
            <button
              onClick={() => setIsCartOpen(true)}
              className="relative p-3 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors"
            >
              <ShoppingCart className="w-6 h-6" />
              {cartItemCount > 0 && (
                <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-6 h-6 flex items-center justify-center">
                  {cartItemCount}
                </span>
              )}
            </button>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Filters */}
        <div className="bg-white rounded-2xl shadow-lg p-6 mb-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {/* Restaurant selection */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Restaurant
              </label>
              <select
                value={selectedRestaurant || ''}
                onChange={(e) => setSelectedRestaurant(Number(e.target.value))}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
              >
                <option value="">Sélectionner un restaurant</option>
                {restaurants.map(restaurant => (
                  <option key={restaurant.id} value={restaurant.id}>
                    {restaurant.name}
                  </option>
                ))}
              </select>
            </div>

            {/* Category filter */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Catégorie
              </label>
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
              >
                <option value="">Toutes les catégories</option>
                {getCategories().map(category => (
                  <option key={category} value={category}>
                    {category}
                  </option>
                ))}
              </select>
            </div>

            {/* Search */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Recherche
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Rechercher un plat..."
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                />
              </div>
            </div>

            {/* Results count */}
            <div className="flex items-end">
              <div className="text-sm text-gray-600">
                {filteredItems.length} plat{filteredItems.length > 1 ? 's' : ''} trouvé{filteredItems.length > 1 ? 's' : ''}
              </div>
            </div>
          </div>
        </div>

        {/* Error message */}
        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-6">
            {error}
          </div>
        )}

        {/* Loading */}
        {loading && (
          <div className="flex items-center justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-500"></div>
          </div>
        )}

        {/* Menu items grid */}
        {!loading && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {filteredItems.map((item) => (
              <MenuItemCard
                key={item.id}
                item={item}
                onAddToCart={handleAddToCart}
                showAddToCart={true}
              />
            ))}
          </div>
        )}

        {/* Empty state */}
        {!loading && filteredItems.length === 0 && (
          <div className="text-center py-12">
            <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Search className="w-12 h-12 text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-600 mb-2">Aucun plat trouvé</h3>
            <p className="text-gray-500">Essayez de modifier vos critères de recherche</p>
          </div>
        )}
      </div>

      {/* Cart Modal */}
      <ModernCart
        isOpen={isCartOpen}
        onClose={() => setIsCartOpen(false)}
        onItemAdded={() => setCartItemCount(0)} // Reset count when cart is updated
      />
    </div>
  );
};

export default ModernMenus;