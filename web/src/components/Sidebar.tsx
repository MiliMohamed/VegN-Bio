import React from 'react';
import { Link, useLocation } from 'react-router-dom';

const Sidebar: React.FC = () => {
  const location = useLocation();

  const menuItems = [
    { path: '/dashboard', label: 'Tableau de bord', icon: '📊' },
    { path: '/restaurants', label: 'Restaurants', icon: '🏪' },
    { path: '/menus', label: 'Menus', icon: '🍽️' },
    { path: '/events', label: 'Événements', icon: '📅' },
    { path: '/marketplace', label: 'Marketplace', icon: '🛒' },
    { path: '/reviews', label: 'Avis', icon: '⭐' }
  ];

  return (
    <nav className="sidebar">
      <ul>
        {menuItems.map((item) => (
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
