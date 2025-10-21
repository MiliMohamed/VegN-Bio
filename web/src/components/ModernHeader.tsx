import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Menu, 
  X, 
  Bell, 
  Settings, 
  LogOut,
  User
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const ModernHeader: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const { user, logout } = useAuth();
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
      '/app/users': 'Utilisateurs'
    };
    return titles[path] || 'VegN Bio';
  };

  const handleLogout = () => {
    logout();
  };

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
        <button className="notification-btn">
          <Bell className="w-5 h-5" />
          <span className="notification-badge">3</span>
        </button>
        
        <div className="modern-user-menu">
          <div className="modern-user-avatar">
            <User className="w-5 h-5" />
          </div>
          <div className="user-info">
            <div className="user-name">{user?.name || 'Utilisateur'}</div>
            <div className="user-role">{user?.role || 'CLIENT'}</div>
          </div>
          <div className="user-dropdown">
            <Link to="/app/profile" className="dropdown-item">
              <User className="w-4 h-4" />
              Profil
            </Link>
            <Link to="/app/settings" className="dropdown-item">
              <Settings className="w-4 h-4" />
              Paramètres
            </Link>
            <button onClick={handleLogout} className="dropdown-item">
              <LogOut className="w-4 h-4" />
              Déconnexion
            </button>
          </div>
        </div>
      </div>
    </header>
  );
};

export default ModernHeader;