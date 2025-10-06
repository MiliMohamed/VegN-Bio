import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Menu, 
  X, 
  Bell, 
  Settings, 
  LogOut, 
  User,
  Leaf,
  Search
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const ModernHeader: React.FC = () => {
  const { user, logout } = useAuth();
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [showMobileMenu, setShowMobileMenu] = useState(false);

  const handleLogout = () => {
    logout();
    window.location.href = '/login';
  };

  const userRoleLabels = {
    ADMIN: 'Administrateur',
    RESTAURATEUR: 'Restaurateur',
    CLIENT: 'Client',
    FOURNISSEUR: 'Fournisseur'
  };

  const userRoleColors = {
    ADMIN: 'danger',
    RESTAURATEUR: 'warning',
    CLIENT: 'primary',
    FOURNISSEUR: 'info'
  };

  return (
    <motion.header 
      className="modern-header"
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <div className="container-fluid">
        <div className="row align-items-center">
          {/* Logo & Brand */}
          <div className="col-auto">
            <div className="header-brand">
              <Leaf className="brand-icon" />
              <div className="brand-text">
                <h1>VegN-Bio</h1>
                <span className="brand-subtitle">Plateforme Culinaire</span>
              </div>
            </div>
          </div>

          {/* Search Bar - Desktop */}
          <div className="col d-none d-lg-block">
            <div className="header-search">
              <div className="search-input-group">
                <Search className="search-icon" />
                <input 
                  type="text" 
                  className="search-input"
                  placeholder="Rechercher restaurants, plats, événements..."
                />
              </div>
            </div>
          </div>

          {/* Header Actions */}
          <div className="col-auto">
            <div className="header-actions">
              {/* Notifications */}
              <div className="action-item">
                <button className="action-btn notification-btn">
                  <Bell />
                  <span className="notification-badge">3</span>
                </button>
              </div>

              {/* Settings */}
              <div className="action-item">
                <button className="action-btn">
                  <Settings />
                </button>
              </div>

              {/* User Menu */}
              <div className="action-item user-menu">
                <button 
                  className="user-btn"
                  onClick={() => setShowUserMenu(!showUserMenu)}
                >
                  <div className="user-avatar">
                    <User />
                  </div>
                  <div className="user-info">
                    <div className="user-name">{user?.name || 'Utilisateur'}</div>
                    <div className={`user-role badge bg-${userRoleColors[user?.role as keyof typeof userRoleColors] || 'secondary'}`}>
                      {userRoleLabels[user?.role as keyof typeof userRoleLabels] || 'Client'}
                    </div>
                  </div>
                </button>

                {/* User Dropdown */}
                {showUserMenu && (
                  <motion.div 
                    className="user-dropdown"
                    initial={{ opacity: 0, y: -10 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -10 }}
                  >
                    <div className="dropdown-header">
                      <div className="user-details">
                        <div className="user-name">{user?.name || 'Utilisateur'}</div>
                        <div className="user-email">{user?.email}</div>
                      </div>
                    </div>
                    <div className="dropdown-divider"></div>
                    <div className="dropdown-menu">
                      <button className="dropdown-item">
                        <User className="dropdown-icon" />
                        Mon Profil
                      </button>
                      <button className="dropdown-item">
                        <Settings className="dropdown-icon" />
                        Paramètres
                      </button>
                      <div className="dropdown-divider"></div>
                      <button 
                        className="dropdown-item logout-item"
                        onClick={handleLogout}
                      >
                        <LogOut className="dropdown-icon" />
                        Déconnexion
                      </button>
                    </div>
                  </motion.div>
                )}
              </div>

              {/* Mobile Menu Toggle */}
              <div className="action-item d-lg-none">
                <button 
                  className="action-btn mobile-menu-btn"
                  onClick={() => setShowMobileMenu(!showMobileMenu)}
                >
                  {showMobileMenu ? <X /> : <Menu />}
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Mobile Search Bar */}
        {showMobileMenu && (
          <motion.div 
            className="mobile-search"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
          >
            <div className="search-input-group">
              <Search className="search-icon" />
              <input 
                type="text" 
                className="search-input"
                placeholder="Rechercher..."
              />
            </div>
          </motion.div>
        )}
      </div>

      {/* Click outside to close dropdowns */}
      {showUserMenu && (
        <div 
          className="dropdown-overlay"
          onClick={() => setShowUserMenu(false)}
        />
      )}
    </motion.header>
  );
};

export default ModernHeader;
