import React, { useState } from 'react';
import { 
  Bell,
  Search,
  Settings,
  User,
  LogOut,
  Menu,
  X,
  ChevronDown,
  Moon,
  Sun,
  Globe,
  HelpCircle,
  MessageSquare,
  Heart,
  Zap,
  Shield
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

interface Notification {
  id: number;
  title: string;
  message: string;
  time: string;
  type: 'info' | 'success' | 'warning' | 'error';
  read: boolean;
}

interface UserMenuOption {
  label: string;
  icon: React.ComponentType<any>;
  action: string;
  divider?: boolean;
}

const ProfessionalHeader: React.FC = () => {
  const { user, logout } = useAuth();
  const [showNotifications, setShowNotifications] = useState(false);
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [showSearch, setShowSearch] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  const notifications: Notification[] = [
    {
      id: 1,
      title: 'Nouvel avis reçu',
      message: 'Un client a laissé un avis 5 étoiles pour VegN-Bio Bastille',
      time: 'Il y a 5 minutes',
      type: 'success',
      read: false
    },
    {
      id: 2,
      title: 'Réservation confirmée',
      message: 'Nouvelle réservation pour l\'atelier de cuisine bio',
      time: 'Il y a 1 heure',
      type: 'info',
      read: false
    },
    {
      id: 3,
      title: 'Stock faible',
      message: 'Les tomates bio sont en rupture de stock',
      time: 'Il y a 2 heures',
      type: 'warning',
      read: true
    },
    {
      id: 4,
      title: 'Maintenance programmée',
      message: 'Maintenance du système prévue dimanche à 2h',
      time: 'Il y a 1 jour',
      type: 'info',
      read: true
    }
  ];

  const unreadCount = notifications.filter(n => !n.read).length;

  const userMenuOptions: UserMenuOption[] = [
    {
      label: 'Mon Profil',
      icon: User,
      action: '/app/profile'
    },
    {
      label: 'Paramètres',
      icon: Settings,
      action: '/app/settings'
    },
    {
      label: 'Préférences',
      icon: Heart,
      action: '/app/preferences'
    },
    {
      label: 'divider',
      icon: User,
      action: '',
      divider: true
    },
    {
      label: 'Support',
      icon: HelpCircle,
      action: '/app/support'
    },
    {
      label: 'Déconnexion',
      icon: LogOut,
      action: 'logout'
    }
  ];

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'ADMIN': return '#ef4444';
      case 'RESTAURATEUR': return '#3b82f6';
      case 'CLIENT': return '#22c55e';
      default: return '#64748b';
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

  const handleUserMenuAction = (action: string) => {
    if (action === 'logout') {
      logout();
    } else {
      // Navigate to action
      console.log('Navigate to:', action);
    }
    setShowUserMenu(false);
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Search for:', searchQuery);
    setShowSearch(false);
  };

  const toggleDarkMode = () => {
    setDarkMode(!darkMode);
    // Implement dark mode logic
  };

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'success': return '✅';
      case 'warning': return '⚠️';
      case 'error': return '❌';
      default: return 'ℹ️';
    }
  };

  const getNotificationColor = (type: string) => {
    switch (type) {
      case 'success': return '#22c55e';
      case 'warning': return '#f59e0b';
      case 'error': return '#ef4444';
      default: return '#3b82f6';
    }
  };

  return (
    <header className="professional-header">
      <div className="header-container">
        {/* Left Section */}
        <div className="header-left">
          <button className="mobile-menu-btn">
            <Menu />
          </button>
          <div className="breadcrumb">
            <span className="breadcrumb-item">VegN-Bio</span>
            <span className="breadcrumb-separator">/</span>
            <span className="breadcrumb-current">Tableau de Bord</span>
          </div>
        </div>

        {/* Center Section - Search */}
        <div className="header-center">
          <form onSubmit={handleSearch} className="search-form">
            <div className="search-input-group">
              <Search className="search-icon" />
              <input
                type="text"
                placeholder="Rechercher restaurants, menus, événements..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="search-input"
              />
              <button type="submit" className="search-btn">
                Rechercher
              </button>
            </div>
          </form>
        </div>

        {/* Right Section */}
        <div className="header-right">
          {/* Quick Actions */}
          <div className="quick-actions">
            <button 
              className="action-btn"
              onClick={toggleDarkMode}
              title="Mode sombre"
            >
              {darkMode ? <Sun /> : <Moon />}
            </button>
            <button 
              className="action-btn"
              title="Langue"
            >
              <Globe />
            </button>
            <button 
              className="action-btn"
              title="Support"
            >
              <HelpCircle />
            </button>
          </div>

          {/* Notifications */}
          <div className="notifications-container">
            <button 
              className="notification-btn"
              onClick={() => setShowNotifications(!showNotifications)}
            >
              <Bell />
              {unreadCount > 0 && (
                <span className="notification-badge">{unreadCount}</span>
              )}
            </button>

            {showNotifications && (
              <div className="notifications-dropdown">
                <div className="notifications-header">
                  <h3>Notifications</h3>
                  <span className="notification-count">{unreadCount} non lues</span>
                </div>
                <div className="notifications-list">
                  {notifications.map((notification) => (
                    <div 
                      key={notification.id} 
                      className={`notification-item ${!notification.read ? 'unread' : ''}`}
                    >
                      <div className="notification-icon">
                        {getNotificationIcon(notification.type)}
                      </div>
                      <div className="notification-content">
                        <div className="notification-title">{notification.title}</div>
                        <div className="notification-message">{notification.message}</div>
                        <div className="notification-time">{notification.time}</div>
                      </div>
                      {!notification.read && (
                        <div 
                          className="notification-dot"
                          style={{ backgroundColor: getNotificationColor(notification.type) }}
                        />
                      )}
                    </div>
                  ))}
                </div>
                <div className="notifications-footer">
                  <button className="btn btn-outline-primary btn-sm">
                    Voir toutes les notifications
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* User Menu */}
          <div className="user-menu-container">
            <button 
              className="user-menu-btn"
              onClick={() => setShowUserMenu(!showUserMenu)}
            >
              <div className="user-avatar">
                <div 
                  className="avatar-circle"
                  style={{ backgroundColor: getRoleColor(user?.role || '') }}
                >
                  {user?.name?.charAt(0).toUpperCase() || 'U'}
                </div>
              </div>
              <div className="user-info">
                <div className="user-name">{user?.name || 'Utilisateur'}</div>
                <div className="user-role">{getRoleLabel(user?.role || '')}</div>
              </div>
              <ChevronDown className="user-chevron" />
            </button>

            {showUserMenu && (
              <div className="user-menu-dropdown">
                <div className="user-menu-header">
                  <div className="user-avatar-large">
                    <div 
                      className="avatar-circle-large"
                      style={{ backgroundColor: getRoleColor(user?.role || '') }}
                    >
                      {user?.name?.charAt(0).toUpperCase() || 'U'}
                    </div>
                  </div>
                  <div className="user-details">
                    <div className="user-name-large">{user?.name || 'Utilisateur'}</div>
                    <div className="user-email">{user?.email || 'email@exemple.com'}</div>
                    <div 
                      className="user-role-badge"
                      style={{ backgroundColor: getRoleColor(user?.role || '') }}
                    >
                      {getRoleLabel(user?.role || '')}
                    </div>
                  </div>
                </div>
                <div className="user-menu-options">
                  {userMenuOptions.map((option, index) => {
                    if (option.divider) {
                      return <div key={index} className="menu-divider" />;
                    }
                    const Icon = option.icon;
                    return (
                      <button
                        key={index}
                        className="menu-option"
                        onClick={() => handleUserMenuAction(option.action)}
                      >
                        <Icon className="menu-option-icon" />
                        <span className="menu-option-label">{option.label}</span>
                      </button>
                    );
                  })}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Mobile Search Overlay */}
      {showSearch && (
        <div className="mobile-search-overlay">
          <div className="mobile-search-container">
            <form onSubmit={handleSearch} className="mobile-search-form">
              <div className="mobile-search-input-group">
                <Search className="search-icon" />
                <input
                  type="text"
                  placeholder="Rechercher..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="mobile-search-input"
                  autoFocus
                />
                <button 
                  type="button" 
                  className="close-search-btn"
                  onClick={() => setShowSearch(false)}
                >
                  <X />
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </header>
  );
};

export default ProfessionalHeader;
