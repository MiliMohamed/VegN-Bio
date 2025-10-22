import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Menu, 
  X, 
  Bell, 
  Settings, 
  LogOut,
  User,
  ShoppingCart,
  Heart,
  Moon,
  Sun
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useCart } from '../contexts/CartContext';
import { useFavorites } from '../contexts/FavoritesContext';
import { useTheme } from '../contexts/ThemeContext';

const ModernHeader: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const { user, logout } = useAuth();
  const { getTotalItems } = useCart();
  const { getFavoritesCount } = useFavorites();
  const { actualTheme, toggleTheme } = useTheme();
  const location = useLocation();

  const getPageTitle = () => {
    const path = location.pathname;
    const titles: { [key: string]: string } = {
      '/app/dashboard': 'Tableau de bord',
      '/app/restaurants': 'Nos Restaurants',
      '/app/menus': 'Menus',
      '/app/rooms': 'Salles de réunion',
      '/app/events': 'Événements',
      '/app/marketplace': 'Marketplace',
      '/app/reviews': 'Avis clients',
      '/app/chatbot': 'Assistant IA',
      '/app/users': 'Utilisateurs',
      '/app/cart': 'Mon Panier',
      '/app/favorites': 'Mes Favoris',
      '/app/profile': 'Mon Profil',
      '/app/settings': 'Paramètres'
    };
    return titles[path] || 'VegN Bio';
  };

  const handleLogout = () => {
    logout();
  };

  // Données de test pour les notifications
  const notifications = [
    {
      id: 1,
      title: 'Nouveau menu disponible',
      message: 'Le menu printemps est maintenant disponible au restaurant République',
      time: 'Il y a 2 heures',
      type: 'info'
    },
    {
      id: 2,
      title: 'Réservation confirmée',
      message: 'Votre réservation de salle pour demain à 14h est confirmée',
      time: 'Il y a 4 heures',
      type: 'success'
    },
    {
      id: 3,
      title: 'Promotion spéciale',
      message: '20% de réduction sur tous les plats végétaliens ce weekend',
      time: 'Il y a 1 jour',
      type: 'promo'
    }
  ];

  return (
    <header className="modern-header">
      <div className="header-left">
        <button 
          className="menu-toggle"
          onClick={() => setIsMenuOpen(!isMenuOpen)}
        >
          {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
        <h1 className="modern-header-title">{getPageTitle()}</h1>
      </div>
      
      <div className="modern-header-actions">
        <button 
          className="theme-toggle-btn"
          onClick={toggleTheme}
          title={`Basculer vers le mode ${actualTheme === 'light' ? 'sombre' : 'clair'}`}
        >
          {actualTheme === 'light' ? <Moon className="w-5 h-5" /> : <Sun className="w-5 h-5" />}
        </button>
        
        <Link to="/app/favorites" className="favorites-btn">
          <Heart className="w-5 h-5" />
          <span className="favorites-badge">{getFavoritesCount()}</span>
        </Link>
        
        <Link to="/app/cart" className="cart-btn">
          <ShoppingCart className="w-5 h-5" />
          <span className="cart-badge">{getTotalItems()}</span>
        </Link>
        
        <button 
          className="notification-btn"
          onClick={() => setShowNotifications(!showNotifications)}
        >
          <Bell className="w-5 h-5" />
          <span className="notification-badge">{notifications.length}</span>
        </button>
        
        <div className="modern-user-menu">
          <div className="user-avatar">
            <User className="w-6 h-6" />
          </div>
          <div className="user-info">
            <div className="user-name">{user?.name || 'Utilisateur'}</div>
            <div className="user-role">{user?.role || 'CLIENT'}</div>
          </div>
          <div className="user-dropdown">
            <Link to="/app/profile" className="dropdown-item">
              <User className="w-4 h-4" />
              <span>Profil</span>
            </Link>
            <Link to="/app/settings" className="dropdown-item">
              <Settings className="w-4 h-4" />
              <span>Paramètres</span>
            </Link>
            <div className="dropdown-divider"></div>
            <button onClick={handleLogout} className="dropdown-item logout">
              <LogOut className="w-4 h-4" />
              <span>Déconnexion</span>
            </button>
          </div>
        </div>
      </div>

      {/* Dropdown des notifications */}
      {showNotifications && (
        <div className="notifications-dropdown">
          <div className="notifications-header">
            <h3>Notifications</h3>
            <button 
              className="close-notifications"
              onClick={() => setShowNotifications(false)}
            >
              <X className="w-4 h-4" />
            </button>
          </div>
          <div className="notifications-list">
            {notifications.map((notification) => (
              <div key={notification.id} className={`notification-item ${notification.type}`}>
                <div className="notification-content">
                  <h4 className="notification-title">{notification.title}</h4>
                  <p className="notification-message">{notification.message}</p>
                  <span className="notification-time">{notification.time}</span>
                </div>
              </div>
            ))}
          </div>
          <div className="notifications-footer">
            <button className="btn btn-primary btn-sm">
              Voir toutes les notifications
            </button>
          </div>
        </div>
      )}
    </header>
  );
};

export default ModernHeader;