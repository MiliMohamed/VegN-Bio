import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const Sidebar: React.FC = () => {
  const location = useLocation();
  const { user } = useAuth();

  const menuItems = [
    { path: '/dashboard', label: 'Tableau de bord', icon: '📊', roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] },
    { path: '/restaurants', label: 'Restaurants', icon: '🏪', roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] },
    { path: '/menus', label: 'Menus', icon: '🍽️', roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] },
    { path: '/events', label: 'Événements', icon: '📅', roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] },
    { path: '/marketplace', label: 'Marketplace', icon: '🛒', roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] },
    { path: '/reviews', label: 'Avis', icon: '⭐', roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] }
  ];

  // Filtrer les éléments du menu selon le rôle
  const filteredMenuItems = menuItems.filter(item => 
    item.roles.includes(user?.role || 'CLIENT')
  );

  return (
    <nav className="sidebar">
      <div className="user-info">
        <div className="user-avatar">👤</div>
        <div className="user-details">
          <div className="user-name">{user?.name || 'Utilisateur'}</div>
          <div className="user-role">{user?.role || 'CLIENT'}</div>
        </div>
      </div>
      
      <ul className="menu-items">
        {filteredMenuItems.map((item) => (
          <li key={item.path} className={location.pathname === item.path ? 'active' : ''}>
            <Link to={item.path}>
              <span style={{ marginRight: '10px' }}>{item.icon}</span>
              {item.label}
            </Link>
          </li>
        ))}
      </ul>
    </nav>
  );
};

export default Sidebar;
