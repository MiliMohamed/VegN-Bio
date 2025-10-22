import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { motion } from 'framer-motion';
import { 
  Home,
  MapPin,
  Utensils,
  Calendar,
  Users,
  ShoppingCart,
  Star,
  MessageCircle,
  UserCheck,
  Leaf,
  Heart,
  Settings,
  User,
  ChevronRight,
  Bell,
  Search
} from 'lucide-react';

interface ModernNavigationProps {
  className?: string;
}

const ModernNavigation: React.FC<ModernNavigationProps> = ({ className = '' }) => {
  const location = useLocation();
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  const menuItems = [
    {
      path: '/app/dashboard',
      icon: <Home className="w-5 h-5" />,
      label: 'Tableau de bord',
      description: 'Vue d\'ensemble',
      badge: null
    },
    {
      path: '/app/restaurants',
      icon: <MapPin className="w-5 h-5" />,
      label: 'Restaurants',
      description: 'Nos établissements',
      badge: '3'
    },
    {
      path: '/app/menus',
      icon: <Utensils className="w-5 h-5" />,
      label: 'Menus',
      description: 'Carte des plats',
      badge: '12'
    },
    {
      path: '/app/cart',
      icon: <ShoppingCart className="w-5 h-5" />,
      label: 'Mon Panier',
      description: 'Mes commandes',
      badge: '5'
    },
    {
      path: '/app/favorites',
      icon: <Heart className="w-5 h-5" />,
      label: 'Mes Favoris',
      description: 'Plats préférés',
      badge: null
    },
    {
      path: '/app/profile',
      icon: <User className="w-5 h-5" />,
      label: 'Mon Profil',
      description: 'Informations personnelles',
      badge: null
    },
    {
      path: '/app/settings',
      icon: <Settings className="w-5 h-5" />,
      label: 'Paramètres',
      description: 'Préférences et allergies',
      badge: null
    },
    {
      path: '/app/rooms',
      icon: <Calendar className="w-5 h-5" />,
      label: 'Salles de réunion',
      description: 'Réservations',
      badge: '2'
    },
    {
      path: '/app/events',
      icon: <Users className="w-5 h-5" />,
      label: 'Événements',
      description: 'Animations & conférences',
      badge: '7'
    },
    {
      path: '/app/marketplace',
      icon: <ShoppingCart className="w-5 h-5" />,
      label: 'Marketplace',
      description: 'Fournisseurs bio',
      badge: null
    },
    {
      path: '/app/reviews',
      icon: <Star className="w-5 h-5" />,
      label: 'Avis clients',
      description: 'Retours & évaluations',
      badge: '24'
    },
    {
      path: '/app/chatbot',
      icon: <MessageCircle className="w-5 h-5" />,
      label: 'Assistant IA',
      description: 'Support intelligent',
      badge: null
    },
    {
      path: '/app/users',
      icon: <UserCheck className="w-5 h-5" />,
      label: 'Utilisateurs',
      description: 'Gestion des comptes',
      badge: '156'
    }
  ];

  const filteredItems = menuItems.filter(item =>
    item.label.toLowerCase().includes(searchQuery.toLowerCase()) ||
    item.description.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <motion.aside 
      className={`modern-navigation ${isCollapsed ? 'collapsed' : ''} ${className}`}
      initial={{ x: -280 }}
      animate={{ x: 0 }}
      transition={{ duration: 0.3, ease: "easeOut" }}
    >
      {/* Header */}
      <div className="navigation-header">
        <Link to="/app/dashboard" className="navigation-logo">
          <div className="logo-icon">
            <Leaf className="w-6 h-6" />
          </div>
          {!isCollapsed && (
            <div className="logo-text">
              <div className="logo-main">VEG'N BIO</div>
              <div className="logo-sub">Restaurants Bio</div>
            </div>
          )}
        </Link>
        
        <button
          className="collapse-toggle"
          onClick={() => setIsCollapsed(!isCollapsed)}
        >
          <ChevronRight className={`w-4 h-4 transition-transform ${isCollapsed ? 'rotate-180' : ''}`} />
        </button>
      </div>

      {/* Search */}
      {!isCollapsed && (
        <motion.div 
          className="navigation-search"
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <div className="search-container">
            <Search className="w-4 h-4 search-icon" />
            <input
              type="text"
              placeholder="Rechercher..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="search-input"
            />
          </div>
        </motion.div>
      )}

      {/* Navigation */}
      <nav className="navigation-menu">
        {filteredItems.map((item, index) => {
          const isActive = location.pathname === item.path;
          return (
            <motion.div
              key={item.path}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.1 + index * 0.05 }}
            >
              <Link
                to={item.path}
                className={`navigation-item ${isActive ? 'active' : ''}`}
                title={isCollapsed ? item.label : undefined}
              >
                <div className="item-icon">
                  {item.icon}
                </div>
                {!isCollapsed && (
                  <div className="item-content">
                    <div className="item-label">
                      {item.label}
                      {item.badge && (
                        <span className="item-badge">{item.badge}</span>
                      )}
                    </div>
                    <div className="item-description">{item.description}</div>
                  </div>
                )}
                {isActive && !isCollapsed && (
                  <motion.div
                    className="active-indicator"
                    layoutId="activeIndicator"
                    transition={{ type: "spring", stiffness: 300, damping: 30 }}
                  />
                )}
              </Link>
            </motion.div>
          );
        })}
      </nav>

      {/* Footer */}
      {!isCollapsed && (
        <motion.div 
          className="navigation-footer"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
        >
          <div className="footer-info">
            <div className="info-title">VegN Bio</div>
            <div className="info-subtitle">Depuis 2014</div>
          </div>
          <div className="footer-stats">
            <div className="stat-item">
              <span className="stat-number">3</span>
              <span className="stat-label">Restaurants</span>
            </div>
            <div className="stat-item">
              <span className="stat-number">156</span>
              <span className="stat-label">Utilisateurs</span>
            </div>
          </div>
        </motion.div>
      )}
    </motion.aside>
  );
};

export default ModernNavigation;
