import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Home, 
  Building2, 
  Utensils, 
  Calendar, 
  ShoppingBag, 
  Star,
  BarChart3,
  Users,
  Package,
  FileText,
  Settings
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const SimpleSidebar: React.FC = () => {
  const location = useLocation();
  const { user } = useAuth();

  const menuItems = [
    { 
      path: '/app/dashboard', 
      label: 'Tableau de bord', 
      icon: Home, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    },
    { 
      path: '/app/restaurants', 
      label: 'Restaurants', 
      icon: Building2, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    },
    { 
      path: '/app/menus', 
      label: 'Menus', 
      icon: Utensils, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    },
    { 
      path: '/app/events', 
      label: 'Événements', 
      icon: Calendar, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    },
    { 
      path: '/app/marketplace', 
      label: 'Marketplace', 
      icon: ShoppingBag, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    },
    { 
      path: '/app/reviews', 
      label: 'Avis & Rapports', 
      icon: Star, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    },
    { 
      path: '/app/analytics', 
      label: 'Analyses', 
      icon: BarChart3, 
      roles: ['ADMIN', 'RESTAURATEUR'] 
    },
    { 
      path: '/app/users', 
      label: 'Utilisateurs', 
      icon: Users, 
      roles: ['ADMIN'] 
    },
    { 
      path: '/app/inventory', 
      label: 'Inventaire', 
      icon: Package, 
      roles: ['ADMIN', 'RESTAURATEUR'] 
    },
    { 
      path: '/app/reports', 
      label: 'Rapports', 
      icon: FileText, 
      roles: ['ADMIN', 'RESTAURATEUR'] 
    },
    { 
      path: '/app/settings', 
      label: 'Paramètres', 
      icon: Settings, 
      roles: ['ADMIN', 'RESTAURATEUR', 'CLIENT'] 
    }
  ];

  // Filtrer les éléments du menu selon le rôle
  const filteredMenuItems = menuItems.filter(item => 
    item.roles.includes(user?.role || 'CLIENT')
  );

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'ADMIN': return 'danger';
      case 'RESTAURATEUR': return 'warning';
      case 'CLIENT': return 'primary';
      default: return 'secondary';
    }
  };

  const getRoleLabel = (role: string) => {
    switch (role) {
      case 'ADMIN': return 'Administrateur';
      case 'RESTAURATEUR': return 'Restaurateur';
      case 'CLIENT': return 'Client';
      default: return 'Utilisateur';
    }
  };

  return (
    <aside className="modern-sidebar">
      <div className="sidebar-content">
        {/* User Profile Section */}
        <div className="sidebar-user">
          <div className="user-avatar-large">
            <div className="avatar-circle">
              <span>{user?.name?.charAt(0)?.toUpperCase() || 'U'}</span>
            </div>
            <div className="status-indicator online"></div>
          </div>
          <div className="user-details">
            <h4 className="user-name">{user?.name || 'Utilisateur'}</h4>
            <p className="user-email">{user?.email}</p>
            <span className={`user-role badge bg-${getRoleColor(user?.role || 'CLIENT')}`}>
              {getRoleLabel(user?.role || 'CLIENT')}
            </span>
          </div>
        </div>

        {/* Navigation Menu */}
        <nav className="sidebar-nav">
          <div className="nav-section">
            <h5 className="nav-section-title">Navigation principale</h5>
            <ul className="nav-menu">
              {filteredMenuItems.slice(0, 6).map((item) => {
                const isActive = location.pathname === item.path;
                const Icon = item.icon;
                
                return (
                  <li key={item.path} className={`nav-item ${isActive ? 'active' : ''}`}>
                    <Link to={item.path} className="nav-link">
                      <div className="nav-icon">
                        <Icon />
                      </div>
                      <span className="nav-label">{item.label}</span>
                      {isActive && (
                        <div className="nav-indicator" />
                      )}
                    </Link>
                  </li>
                );
              })}
            </ul>
          </div>

          {/* Secondary Menu */}
          {filteredMenuItems.length > 6 && (
            <div className="nav-section">
              <h5 className="nav-section-title">Administration</h5>
              <ul className="nav-menu">
                {filteredMenuItems.slice(6).map((item) => {
                  const isActive = location.pathname === item.path;
                  const Icon = item.icon;
                  
                  return (
                    <li key={item.path} className={`nav-item ${isActive ? 'active' : ''}`}>
                      <Link to={item.path} className="nav-link">
                        <div className="nav-icon">
                          <Icon />
                        </div>
                        <span className="nav-label">{item.label}</span>
                        {isActive && (
                          <div className="nav-indicator" />
                        )}
                      </Link>
                    </li>
                  );
                })}
              </ul>
            </div>
          )}
        </nav>

        {/* Sidebar Footer */}
        <div className="sidebar-footer">
          <div className="footer-stats">
            <div className="stat-item">
              <div className="stat-value">24</div>
              <div className="stat-label">Notifications</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">5</div>
              <div className="stat-label">Messages</div>
            </div>
          </div>
          <div className="footer-actions">
            <button className="footer-btn">
              <Settings />
              <span>Paramètres</span>
            </button>
          </div>
        </div>
      </div>
    </aside>
  );
};

export default SimpleSidebar;
