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
  Users
} from 'lucide-react';
import { menuService } from '../services/api';
import MenuForm from './MenuForm';
import MenuItemForm from './MenuItemForm';

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
}

interface Menu {
  id: number;
  title: string;
  activeFrom: string;
  activeTo: string;
  menuItems: MenuItem[];
}

const ModernMenus: React.FC = () => {
  const [menus, setMenus] = React.useState<Menu[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [selectedRestaurant, setSelectedRestaurant] = React.useState<number>(1);
  const [showMenuForm, setShowMenuForm] = useState(false);
  const [showMenuItemForm, setShowMenuItemForm] = useState(false);
  const [selectedMenu, setSelectedMenu] = useState<Menu | null>(null);

  React.useEffect(() => {
    const fetchMenus = async () => {
      try {
        const response = await menuService.getMenusByRestaurant(selectedRestaurant);
        setMenus(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des menus:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchMenus();
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
                </motion.div>
              ))}
            </div>

            <div className="menu-actions">
              <button className="btn btn-primary btn-sm">
                <Edit className="w-4 h-4" />
                Modifier le menu
              </button>
              <button 
                className="btn btn-secondary btn-sm"
                onClick={() => handleAddMenuItem(menu)}
              >
                <Plus className="w-4 h-4" />
                Ajouter un plat
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