import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Utensils, 
  Plus, 
  Edit, 
  Trash2, 
  Eye,
  Star,
  Clock,
  Users,
  MapPin,
  ShoppingCart,
  Heart,
  Info
} from 'lucide-react';
import { menuService, restaurantService } from '../services/api';
import { useCart } from '../contexts/CartContext';
import { useFavorites } from '../contexts/FavoritesContext';
import MenuForm from './MenuForm';
import MenuItemForm from './MenuItemForm';
import '../styles/menu-improvements.css';

interface Allergen {
  id: number;
  code: string;
  label: string;
}

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens: Allergen[];
}

interface Menu {
  id: number;
  title: string;
  activeFrom: string;
  activeTo: string;
  menuItems: MenuItem[];
}

const ModernMenus: React.FC = () => {
  const { addToCart } = useCart();
  const { addToFavorites, removeFromFavorites, isFavorite } = useFavorites();
  const [menus, setMenus] = React.useState<Menu[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [selectedRestaurant, setSelectedRestaurant] = React.useState<number>(1);
  const [showMenuForm, setShowMenuForm] = useState(false);
  const [showMenuItemForm, setShowMenuItemForm] = useState(false);
  const [selectedMenu, setSelectedMenu] = useState<Menu | null>(null);
  const [restaurants, setRestaurants] = useState<any[]>([]);

  React.useEffect(() => {
    const fetchData = async () => {
      try {
        // Charger la liste des restaurants
        const restaurantsRes = await restaurantService.getAll();
        setRestaurants(restaurantsRes.data);
        
        // Charger les menus du restaurant sélectionné
        const response = await menuService.getMenusByRestaurant(selectedRestaurant);
        setMenus(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [selectedRestaurant]);

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const handleCreateMenu = () => {
    setShowMenuForm(true);
  };

  const handleMenuSuccess = () => {
    // Recharger les menus
    const fetchMenus = async () => {
      try {
        const response = await menuService.getMenusByRestaurant(selectedRestaurant);
        setMenus(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des menus:', error);
      }
    };
    fetchMenus();
  };

  const handleAddMenuItem = (menu: Menu) => {
    setSelectedMenu(menu);
    setShowMenuItemForm(true);
  };

  const handleMenuItemSuccess = () => {
    // Recharger les menus
    const fetchMenus = async () => {
      try {
        const response = await menuService.getMenusByRestaurant(selectedRestaurant);
        setMenus(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des menus:', error);
      }
    };
    fetchMenus();
  };

  const handleEditMenu = (menu: Menu) => {
    // TODO: Implémenter l'édition de menu
    console.log('Édition du menu:', menu);
  };

  const handleDeleteMenu = async (menuId: number) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer ce menu ?')) {
      try {
        await menuService.delete(menuId);
        // Recharger les menus
        const response = await menuService.getMenusByRestaurant(selectedRestaurant);
        setMenus(response.data);
      } catch (error) {
        console.error('Erreur lors de la suppression du menu:', error);
      }
    }
  };

  const handleViewMenu = (menu: Menu) => {
    // TODO: Implémenter la vue détaillée du menu
    console.log('Voir le menu:', menu);
  };

  // Actions côté client
  const handleAddToCart = (item: MenuItem) => {
    const selectedRestaurantData = restaurants.find(r => r.id === selectedRestaurant);
    addToCart({
      id: item.id,
      name: item.name,
      description: item.description,
      priceCents: item.priceCents,
      isVegan: item.isVegan,
      allergens: item.allergens,
      restaurantId: selectedRestaurant,
      restaurantName: selectedRestaurantData?.name || 'Restaurant'
    }, selectedRestaurantData?.name || 'Restaurant');
    
    // Notification visuelle
    const button = document.querySelector(`[data-item-id="${item.id}"]`);
    if (button) {
      button.textContent = '✓ Ajouté';
      button.classList.add('btn-success');
      setTimeout(() => {
        button.textContent = 'Panier';
        button.classList.remove('btn-success');
      }, 2000);
    }
  };

  const handleAddToFavorites = (item: MenuItem) => {
    const selectedRestaurantData = restaurants.find(r => r.id === selectedRestaurant);
    
    if (isFavorite(item.id)) {
      removeFromFavorites(item.id);
      alert(`Retiré des favoris: ${item.name}`);
    } else {
      addToFavorites({
        id: item.id,
        name: item.name,
        description: item.description,
        priceCents: item.priceCents,
        isVegan: item.isVegan,
        allergens: item.allergens,
        restaurantId: selectedRestaurant,
        restaurantName: selectedRestaurantData?.name || 'Restaurant'
      });
      alert(`Ajouté aux favoris: ${item.name}`);
    }
  };

  const handleViewItemDetails = (item: MenuItem) => {
    // TODO: Implémenter la vue détaillée de l'item
    console.log('Voir détails:', item);
    alert(`Détails de: ${item.name}\nDescription: ${item.description}\nPrix: ${formatPrice(item.priceCents)}`);
  };

  if (loading) {
    return (
      <div className="modern-menus">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des menus...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-menus">
      <div className="menus-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Menus Végétariens Bio</h1>
          <p className="page-subtitle">
            Découvrez nos cartes saisonnières composées de produits biologiques franciliens
          </p>
        </motion.div>
      </div>

      {/* Sélecteur de restaurant */}
      <motion.div 
        className="restaurant-selector"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="selector-container">
          <label htmlFor="restaurant-select" className="selector-label">
            <MapPin className="w-4 h-4" />
            Restaurant :
          </label>
          <select
            id="restaurant-select"
            value={selectedRestaurant}
            onChange={(e) => setSelectedRestaurant(Number(e.target.value))}
            className="selector-input"
          >
            {restaurants.map(restaurant => (
              <option key={restaurant.id} value={restaurant.id}>
                {restaurant.name} ({restaurant.code})
              </option>
            ))}
          </select>
        </div>
        
        <button 
          className="btn btn-primary btn-sm"
          onClick={handleCreateMenu}
        >
          <Plus className="w-4 h-4" />
          Nouveau menu
        </button>
      </motion.div>

      <div className="menus-content">
        {menus.map((menu, index) => (
          <motion.div
            key={menu.id}
            className="menu-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
          >
            <div className="menu-header">
              <h2 className="menu-title">{menu.title}</h2>
              <div className="menu-period">
                <Clock className="w-4 h-4" />
                <span>
                  Du {new Date(menu.activeFrom).toLocaleDateString('fr-FR')} au{' '}
                  {new Date(menu.activeTo).toLocaleDateString('fr-FR')}
                </span>
              </div>
            </div>

            <div className="menu-items">
              {menu.menuItems.map((item, itemIndex) => (
                <motion.div
                  key={item.id}
                  className="menu-item"
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.4, delay: itemIndex * 0.05 }}
                >
                  <div className="item-header">
                    <h3 className="item-name">{item.name}</h3>
                    <div className="item-price">{formatPrice(item.priceCents)}</div>
                  </div>
                  <p className="item-description">{item.description}</p>
                  <div className="item-badges">
                    {item.isVegan && (
                      <span className="badge badge-vegan">
                        <Star className="w-3 h-3" />
                        Végétalien
                      </span>
                    )}
                    <span className="badge badge-bio">
                      <Utensils className="w-3 h-3" />
                      Bio
                    </span>
                  </div>
                  
                  {/* Affichage des allergènes */}
                  {item.allergens && item.allergens.length > 0 && (
                    <div className="allergens-section">
                      <div className="allergens-label">
                        <span className="allergens-icon">⚠️</span>
                        Allergènes :
                      </div>
                      <div className="allergens-list">
                        {item.allergens.map((allergen) => (
                          <span key={allergen.id} className="allergen-badge">
                            {allergen.label}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Actions pour chaque plat */}
                  <div className="item-actions">
                    <button 
                      className="btn btn-success btn-xs"
                      onClick={() => handleAddToCart(item)}
                      title="Ajouter au panier"
                      data-item-id={item.id}
                    >
                      <ShoppingCart className="w-3 h-3" />
                      Panier
                    </button>
                    <button 
                      className={`btn btn-warning btn-xs ${isFavorite(item.id) ? 'btn-favorite-active' : ''}`}
                      onClick={() => handleAddToFavorites(item)}
                      title={isFavorite(item.id) ? "Retirer des favoris" : "Ajouter aux favoris"}
                    >
                      <Heart className={`w-3 h-3 ${isFavorite(item.id) ? 'fill-current' : ''}`} />
                      {isFavorite(item.id) ? 'Favori' : 'Favoris'}
                    </button>
                    <button 
                      className="btn btn-info btn-xs"
                      onClick={() => handleViewItemDetails(item)}
                      title="Voir détails"
                    >
                      <Info className="w-3 h-3" />
                      Détails
                    </button>
                  </div>
                </motion.div>
              ))}
            </div>

            <div className="menu-actions">
              <button 
                className="btn btn-primary btn-sm"
                onClick={() => handleViewMenu(menu)}
              >
                <Eye className="w-4 h-4" />
                Voir
              </button>
              <button 
                className="btn btn-secondary btn-sm"
                onClick={() => handleEditMenu(menu)}
              >
                <Edit className="w-4 h-4" />
                Modifier
              </button>
              <button 
                className="btn btn-success btn-sm"
                onClick={() => handleAddMenuItem(menu)}
              >
                <Plus className="w-4 h-4" />
                Ajouter un plat
              </button>
              <button 
                className="btn btn-danger btn-sm"
                onClick={() => handleDeleteMenu(menu.id)}
              >
                <Trash2 className="w-4 h-4" />
                Supprimer
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Formulaires */}
      <MenuForm
        isOpen={showMenuForm}
        onClose={() => setShowMenuForm(false)}
        onSuccess={handleMenuSuccess}
        restaurantId={selectedRestaurant}
      />

      {selectedMenu && (
        <MenuItemForm
          isOpen={showMenuItemForm}
          onClose={() => setShowMenuItemForm(false)}
          onSuccess={handleMenuItemSuccess}
          menuId={selectedMenu.id}
        />
      )}
    </div>
  );
};

export default ModernMenus;