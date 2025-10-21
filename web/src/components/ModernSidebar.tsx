import React from 'react';
import { Link, useLocation } from 'react-router-dom';
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
  Leaf
} from 'lucide-react';

const ModernSidebar: React.FC = () => {
  const location = useLocation();

  const menuItems = [
    {
      path: '/app/dashboard',
      icon: <Home className="w-5 h-5" />,
      label: 'Tableau de bord',
      description: 'Vue d\'ensemble'
    },
    {
      path: '/app/restaurants',
      icon: <MapPin className="w-5 h-5" />,
      label: 'Restaurants',
      description: 'Nos établissements'
    },
    {
      path: '/app/menus',
      icon: <Utensils className="w-5 h-5" />,
      label: 'Menus',
      description: 'Carte des plats'
    },
    {
      path: '/app/cart',
      icon: <ShoppingCart className="w-5 h-5" />,
      label: 'Mon Panier',
      description: 'Mes commandes'
    },
    {
      path: '/app/rooms',
      icon: <Calendar className="w-5 h-5" />,
      label: 'Salles de réunion',
      description: 'Réservations'
    },
    {
      path: '/app/events',
      icon: <Users className="w-5 h-5" />,
      label: 'Événements',
      description: 'Animations & conférences'
    },
    {
      path: '/app/marketplace',
      icon: <ShoppingCart className="w-5 h-5" />,
      label: 'Marketplace',
      description: 'Fournisseurs bio'
    },
    {
      path: '/app/reviews',
      icon: <Star className="w-5 h-5" />,
      label: 'Avis clients',
      description: 'Retours & évaluations'
    },
    {
      path: '/app/chatbot',
      icon: <MessageCircle className="w-5 h-5" />,
      label: 'Assistant IA',
      description: 'Support intelligent'
    },
    {
      path: '/app/users',
      icon: <UserCheck className="w-5 h-5" />,
      label: 'Utilisateurs',
      description: 'Gestion des comptes'
    }
  ];

  return (
    <aside className="modern-sidebar">
      <div className="modern-sidebar-header">
        <Link to="/app/dashboard" className="modern-sidebar-logo">
          <div className="modern-sidebar-logo-icon">
            <Leaf className="w-6 h-6" />
          </div>
          <div className="logo-text">
            <div className="logo-main">VEG'N BIO</div>
            <div className="logo-sub">Restaurants Bio</div>
          </div>
        </Link>
      </div>
      
      <nav className="modern-sidebar-nav">
        {menuItems.map((item) => {
          const isActive = location.pathname === item.path;
          return (
            <Link
              key={item.path}
              to={item.path}
              className={`modern-nav-item ${isActive ? 'active' : ''}`}
            >
              <span className="modern-nav-item-icon">
                {item.icon}
              </span>
              <div className="nav-item-content">
                <div className="nav-item-label">{item.label}</div>
                <div className="nav-item-description">{item.description}</div>
              </div>
            </Link>
          );
        })}
      </nav>
      
      <div className="sidebar-footer">
        <div className="sidebar-info">
          <div className="info-title">VegN Bio</div>
          <div className="info-subtitle">Depuis 2014</div>
        </div>
      </div>
    </aside>
  );
};

export default ModernSidebar;