import React, { useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { 
  LayoutDashboard,
  Building2,
  Utensils,
  Calendar,
  ShoppingBag,
  Star,
  Users,
  Settings,
  LogOut,
  Bell,
  Search,
  Menu,
  X,
  ChevronDown,
  ChevronRight,
  BarChart3,
  MessageSquare,
  Heart,
  Leaf,
  Zap,
  Shield,
  HelpCircle,
  CreditCard,
  FileText,
  AlertTriangle,
  Bot,
  TrendingUp
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

interface NavigationItem {
  id: string;
  label: string;
  icon: React.ComponentType<any>;
  path: string;
  badge?: string;
  badgeColor?: string;
  children?: NavigationItem[];
  roles?: string[];
}

const ProfessionalSidebar: React.FC = () => {
  const { user, logout } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const [collapsed, setCollapsed] = useState(false);
  const [expandedItems, setExpandedItems] = useState<string[]>([]);

  const navigationItems: NavigationItem[] = [
    {
      id: 'dashboard',
      label: 'Tableau de Bord',
      icon: LayoutDashboard,
      path: '/app/dashboard'
    },
    {
      id: 'restaurants',
      label: 'Restaurants',
      icon: Building2,
      path: '/app/restaurants',
      badge: '7',
      badgeColor: 'success'
    },
    {
      id: 'menus',
      label: 'Menus & Plats',
      icon: Utensils,
      path: '/app/menus',
      badge: '23',
      badgeColor: 'info'
    },
    {
      id: 'rooms',
      label: 'Réservation Salles',
      icon: Calendar,
      path: '/app/rooms',
      badge: '12',
      badgeColor: 'primary'
    },
    {
      id: 'events',
      label: 'Événements',
      icon: Calendar,
      path: '/app/events',
      badge: '5',
      badgeColor: 'warning'
    },
    // Marketplace seulement visible pour les fournisseurs
    ...(user?.role === 'FOURNISSEUR' ? [{
      id: 'marketplace',
      label: 'Marketplace',
      icon: ShoppingBag,
      path: '/app/marketplace',
      children: [
        {
          id: 'products',
          label: 'Produits',
          icon: Leaf,
          path: '/app/marketplace/products'
        },
        {
          id: 'suppliers',
          label: 'Fournisseurs',
          icon: Users,
          path: '/app/marketplace/suppliers'
        },
        {
          id: 'orders',
          label: 'Commandes',
          icon: CreditCard,
          path: '/app/marketplace/orders'
        }
      ]
    }] : []),
    {
      id: 'reviews',
      label: 'Avis & Retours',
      icon: Star,
      path: '/app/reviews',
      badge: '156',
      badgeColor: 'primary'
    },
    {
      id: 'analytics',
      label: 'Analyses',
      icon: BarChart3,
      path: '/app/analytics',
      children: [
        {
          id: 'performance',
          label: 'Performance',
          icon: TrendingUp,
          path: '/app/analytics/performance'
        },
        {
          id: 'reports',
          label: 'Rapports',
          icon: FileText,
          path: '/app/analytics/reports'
        },
        {
          id: 'insights',
          label: 'Insights',
          icon: Zap,
          path: '/app/analytics/insights'
        }
      ]
    },
    {
      id: 'communication',
      label: 'Communication',
      icon: MessageSquare,
      path: '/app/communication',
      children: [
        {
          id: 'chatbot',
          label: 'Assistant IA',
          icon: Bot,
          path: '/app/chatbot'
        },
        {
          id: 'notifications',
          label: 'Notifications',
          icon: Bell,
          path: '/app/communication/notifications'
        },
        {
          id: 'support',
          label: 'Support',
          icon: HelpCircle,
          path: '/app/communication/support'
        }
      ]
    },
    {
      id: 'users',
      label: 'Utilisateurs',
      icon: Users,
      path: '/app/users',
      roles: ['ADMIN']
    },
    {
      id: 'system',
      label: 'Système',
      icon: Settings,
      path: '/app/system',
      roles: ['ADMIN'],
      children: [
        {
          id: 'settings',
          label: 'Paramètres',
          icon: Settings,
          path: '/app/system/settings'
        },
        {
          id: 'security',
          label: 'Sécurité',
          icon: Shield,
          path: '/app/system/security'
        },
        {
          id: 'logs',
          label: 'Journaux',
          icon: FileText,
          path: '/app/system/logs'
        },
        {
          id: 'errors',
          label: 'Erreurs',
          icon: AlertTriangle,
          path: '/app/system/errors',
          badge: '3',
          badgeColor: 'error'
        }
      ]
    }
  ];

  const filteredItems = navigationItems.filter(item => {
    if (!item.roles) return true;
    return item.roles.includes(user?.role || '');
  });

  const handleItemClick = (item: NavigationItem) => {
    if (item.children) {
      const isExpanded = expandedItems.includes(item.id);
      if (isExpanded) {
        setExpandedItems(expandedItems.filter(id => id !== item.id));
      } else {
        setExpandedItems([...expandedItems, item.id]);
      }
    } else {
      navigate(item.path);
    }
  };

  const isActive = (path: string) => {
    return location.pathname === path;
  };

  const isParentActive = (item: NavigationItem) => {
    if (!item.children) return false;
    return item.children.some(child => isActive(child.path));
  };

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

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

  return (
    <div className={`professional-sidebar ${collapsed ? 'collapsed' : ''}`}>
      {/* Sidebar Header */}
      <div className="sidebar-header">
        <div className="sidebar-brand">
          <div className="brand-logo">
            <Leaf className="logo-icon" />
          </div>
          {!collapsed && (
            <div className="brand-content">
              <h1 className="brand-title">VegN-Bio</h1>
              <p className="brand-subtitle">Écosystème Bio</p>
            </div>
          )}
        </div>
        <button 
          className="sidebar-toggle"
          onClick={() => setCollapsed(!collapsed)}
        >
          {collapsed ? <Menu /> : <X />}
        </button>
      </div>

      {/* User Profile */}
      {!collapsed && (
        <div className="sidebar-user">
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
            <div className="user-role" style={{ color: getRoleColor(user?.role || '') }}>
              {getRoleLabel(user?.role || '')}
            </div>
          </div>
        </div>
      )}

      {/* Search Bar */}
      {!collapsed && (
        <div className="sidebar-search">
          <div className="search-input-group">
            <Search className="search-icon" />
            <input 
              type="text" 
              placeholder="Rechercher..." 
              className="search-input"
            />
          </div>
        </div>
      )}

      {/* Navigation */}
      <nav className="sidebar-nav">
        <div className="nav-section">
          <div className="nav-section-title">Principal</div>
          {filteredItems.slice(0, 6).map((item) => (
            <NavigationItemComponent
              key={item.id}
              item={item}
              isActive={isActive}
              isParentActive={isParentActive}
              expandedItems={expandedItems}
              onItemClick={handleItemClick}
              collapsed={collapsed}
            />
          ))}
        </div>

        <div className="nav-section">
          <div className="nav-section-title">Analyses</div>
          {filteredItems.slice(6, 8).map((item) => (
            <NavigationItemComponent
              key={item.id}
              item={item}
              isActive={isActive}
              isParentActive={isParentActive}
              expandedItems={expandedItems}
              onItemClick={handleItemClick}
              collapsed={collapsed}
            />
          ))}
        </div>

        <div className="nav-section">
          <div className="nav-section-title">Système</div>
          {filteredItems.slice(8).map((item) => (
            <NavigationItemComponent
              key={item.id}
              item={item}
              isActive={isActive}
              isParentActive={isParentActive}
              expandedItems={expandedItems}
              onItemClick={handleItemClick}
              collapsed={collapsed}
            />
          ))}
        </div>
      </nav>

      {/* Sidebar Footer */}
      <div className="sidebar-footer">
        <div className="footer-actions">
          <button className="footer-btn" title="Notifications">
            <Bell />
            {!collapsed && <span>Notifications</span>}
          </button>
          <button className="footer-btn" title="Support">
            <HelpCircle />
            {!collapsed && <span>Support</span>}
          </button>
        </div>
        <button className="logout-btn" onClick={handleLogout}>
          <LogOut />
          {!collapsed && <span>Déconnexion</span>}
        </button>
      </div>
    </div>
  );
};

interface NavigationItemComponentProps {
  item: NavigationItem;
  isActive: (path: string) => boolean;
  isParentActive: (item: NavigationItem) => boolean;
  expandedItems: string[];
  onItemClick: (item: NavigationItem) => void;
  collapsed: boolean;
}

const NavigationItemComponent: React.FC<NavigationItemComponentProps> = ({
  item,
  isActive,
  isParentActive,
  expandedItems,
  onItemClick,
  collapsed
}) => {
  const Icon = item.icon;
  const hasChildren = item.children && item.children.length > 0;
  const isExpanded = expandedItems.includes(item.id);
  const active = isActive(item.path) || isParentActive(item);

  const getBadgeColor = (color?: string) => {
    switch (color) {
      case 'success': return '#22c55e';
      case 'warning': return '#f59e0b';
      case 'error': return '#ef4444';
      case 'info': return '#06b6d4';
      case 'primary': return '#3b82f6';
      default: return '#64748b';
    }
  };

  return (
    <div className="nav-item-container">
      <button
        className={`nav-item ${active ? 'active' : ''} ${hasChildren ? 'has-children' : ''}`}
        onClick={() => onItemClick(item)}
        title={collapsed ? item.label : undefined}
      >
        <div className="nav-item-content">
          <div className="nav-item-icon">
            <Icon />
          </div>
          {!collapsed && (
            <>
              <span className="nav-item-label">{item.label}</span>
              {item.badge && (
                <span 
                  className="nav-item-badge"
                  style={{ backgroundColor: getBadgeColor(item.badgeColor) }}
                >
                  {item.badge}
                </span>
              )}
            </>
          )}
        </div>
        {!collapsed && hasChildren && (
          <div className="nav-item-arrow">
            {isExpanded ? <ChevronDown /> : <ChevronRight />}
          </div>
        )}
      </button>

      {/* Children */}
      {hasChildren && !collapsed && isExpanded && (
        <div className="nav-children">
          {item.children!.map((child) => {
            const ChildIcon = child.icon;
            const childActive = isActive(child.path);
            return (
              <button
                key={child.id}
                className={`nav-child ${childActive ? 'active' : ''}`}
                onClick={() => onItemClick(child)}
              >
                <div className="nav-child-icon">
                  <ChildIcon />
                </div>
                <span className="nav-child-label">{child.label}</span>
                {child.badge && (
                  <span 
                    className="nav-child-badge"
                    style={{ backgroundColor: getBadgeColor(child.badgeColor) }}
                  >
                    {child.badge}
                  </span>
                )}
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
};

export default ProfessionalSidebar;
