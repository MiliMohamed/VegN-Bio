import React, { useState, useEffect } from 'react';
import { 
  Users,
  UserPlus,
  Search,
  Filter,
  MoreVertical,
  Edit,
  Trash2,
  Eye,
  Shield,
  Mail,
  Phone,
  Calendar,
  CheckCircle,
  XCircle,
  AlertTriangle,
  Crown,
  User,
  Building2,
  ShoppingBag,
  Star,
  Activity,
  TrendingUp,
  Download,
  Upload,
  RefreshCw
} from 'lucide-react';
import { userService } from '../services/api';

interface UserData {
  id: number;
  email: string;
  fullName: string;
  role: 'ADMIN' | 'RESTAURATEUR' | 'FOURNISSEUR' | 'CLIENT';
  createdAt: string;
  lastLogin?: string;
  isActive: boolean;
  phone?: string;
  address?: string;
  restaurantId?: number;
  restaurantName?: string;
}

interface UserStats {
  totalUsers: number;
  activeUsers: number;
  newUsersThisMonth: number;
  usersByRole: { [key: string]: number };
  averageSessions: number;
}

const ProfessionalUsers: React.FC = () => {
  const [users, setUsers] = useState<UserData[]>([]);
  const [stats, setStats] = useState<UserStats>({
    totalUsers: 0,
    activeUsers: 0,
    newUsersThisMonth: 0,
    usersByRole: {},
    averageSessions: 0
  });
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterRole, setFilterRole] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [selectedUsers, setSelectedUsers] = useState<number[]>([]);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [editingUser, setEditingUser] = useState<UserData | null>(null);

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    try {
      setLoading(true);
      const response = await userService.getUsers();
      const usersData = response.data.map((user: any) => ({
        ...user,
        isActive: true, // Placeholder
        restaurantName: user.restaurantId ? `Restaurant ${user.restaurantId}` : undefined
      }));
      setUsers(usersData);
      
      // Calculate stats
      const totalUsers = usersData.length;
      const activeUsers = usersData.filter((u: UserData) => u.isActive).length;
      const newUsersThisMonth = usersData.filter((u: UserData) => {
        const createdDate = new Date(u.createdAt);
        const now = new Date();
        return createdDate.getMonth() === now.getMonth() && 
               createdDate.getFullYear() === now.getFullYear();
      }).length;
      
      const usersByRole = usersData.reduce((acc: any, user: UserData) => {
        acc[user.role] = (acc[user.role] || 0) + 1;
        return acc;
      }, {});

      setStats({
        totalUsers,
        activeUsers,
        newUsersThisMonth,
        usersByRole,
        averageSessions: 2.3 // Placeholder
      });
    } catch (error) {
      console.error('Erreur lors du chargement des utilisateurs:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteUser = async (userId: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      return;
    }

    try {
      await userService.deleteUser(userId);
      setUsers(users.filter(user => user.id !== userId));
    } catch (error) {
      console.error('Erreur lors de la suppression:', error);
    }
  };

  const handleToggleUserStatus = async (userId: number) => {
    try {
      const user = users.find(u => u.id === userId);
      if (user) {
        await userService.updateUser(userId, { isActive: !user.isActive });
        setUsers(users.map(u => 
          u.id === userId ? { ...u, isActive: !u.isActive } : u
        ));
      }
    } catch (error) {
      console.error('Erreur lors de la mise à jour:', error);
    }
  };

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.fullName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.role.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRole = !filterRole || user.role === filterRole;
    const matchesStatus = !filterStatus || 
                         (filterStatus === 'active' && user.isActive) ||
                         (filterStatus === 'inactive' && !user.isActive);
    return matchesSearch && matchesRole && matchesStatus;
  });

  const getRoleIcon = (role: string) => {
    switch (role) {
      case 'ADMIN': return Crown;
      case 'RESTAURATEUR': return Building2;
      case 'FOURNISSEUR': return ShoppingBag;
      case 'CLIENT': return User;
      default: return User;
    }
  };

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'ADMIN': return '#ef4444';
      case 'RESTAURATEUR': return '#3b82f6';
      case 'FOURNISSEUR': return '#f59e0b';
      case 'CLIENT': return '#22c55e';
      default: return '#64748b';
    }
  };

  const getRoleLabel = (role: string) => {
    switch (role) {
      case 'ADMIN': return 'Administrateur';
      case 'RESTAURATEUR': return 'Restaurateur';
      case 'FOURNISSEUR': return 'Fournisseur';
      case 'CLIENT': return 'Client';
      default: return 'Utilisateur';
    }
  };

  if (loading) {
    return (
      <div className="professional-users">
        <div className="professional-loading">
          <div className="professional-loading-spinner"></div>
          <p className="professional-loading-text">Chargement des utilisateurs...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="professional-users">
      {/* Header */}
      <div className="users-header">
        <div className="header-content">
          <div className="header-info">
            <h1 className="page-title">
              <Users className="title-icon" />
              Gestion des Utilisateurs
            </h1>
            <p className="page-subtitle">
              Gérez les comptes utilisateurs et leurs permissions
            </p>
          </div>
          <div className="header-actions">
            <button className="btn btn-outline-primary">
              <Download className="btn-icon" />
              Exporter
            </button>
            <button className="btn btn-outline-secondary">
              <Upload className="btn-icon" />
              Importer
            </button>
            <button 
              className="btn btn-primary"
              onClick={() => setShowCreateForm(true)}
            >
              <UserPlus className="btn-icon" />
              Nouvel Utilisateur
            </button>
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="users-stats">
        <div className="stats-grid">
          <div className="stat-card">
            <div className="stat-icon">
              <Users />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.totalUsers}</div>
              <div className="stat-label">Total Utilisateurs</div>
              <div className="stat-change positive">
                <TrendingUp className="change-icon" />
                +{stats.newUsersThisMonth} ce mois
              </div>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon">
              <Activity />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.activeUsers}</div>
              <div className="stat-label">Utilisateurs Actifs</div>
              <div className="stat-change positive">
                <CheckCircle className="change-icon" />
                {Math.round((stats.activeUsers / stats.totalUsers) * 100)}%
              </div>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon">
              <Crown />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.usersByRole.ADMIN || 0}</div>
              <div className="stat-label">Administrateurs</div>
              <div className="stat-change neutral">
                <Shield className="change-icon" />
                Accès complet
              </div>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon">
              <Building2 />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.usersByRole.RESTAURATEUR || 0}</div>
              <div className="stat-label">Restaurateurs</div>
              <div className="stat-change positive">
                <TrendingUp className="change-icon" />
                +{Math.floor((stats.usersByRole.RESTAURATEUR || 0) * 0.1)}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Filters and Search */}
      <div className="users-filters">
        <div className="search-section">
          <div className="search-input-group">
            <Search className="search-icon" />
            <input
              type="text"
              placeholder="Rechercher par nom, email ou rôle..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
            />
          </div>
        </div>
        <div className="filter-section">
          <select
            value={filterRole}
            onChange={(e) => setFilterRole(e.target.value)}
            className="filter-select"
          >
            <option value="">Tous les rôles</option>
            <option value="ADMIN">Administrateurs</option>
            <option value="RESTAURATEUR">Restaurateurs</option>
            <option value="FOURNISSEUR">Fournisseurs</option>
            <option value="CLIENT">Clients</option>
          </select>
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="filter-select"
          >
            <option value="">Tous les statuts</option>
            <option value="active">Actifs</option>
            <option value="inactive">Inactifs</option>
          </select>
        </div>
      </div>

      {/* Users Table */}
      <div className="users-table-container">
        <div className="table-header">
          <div className="table-info">
            <span>{filteredUsers.length} utilisateurs trouvés</span>
          </div>
          <div className="table-actions">
            <button 
              className="btn btn-outline-primary btn-sm"
              onClick={loadUsers}
            >
              <RefreshCw className="btn-icon" />
              Actualiser
            </button>
          </div>
        </div>

        <div className="users-table">
          {filteredUsers.length === 0 ? (
            <div className="professional-empty">
              <Users className="professional-empty-icon" />
              <h3 className="professional-empty-title">Aucun utilisateur trouvé</h3>
              <p className="professional-empty-message">
                {searchTerm || filterRole || filterStatus 
                  ? 'Aucun utilisateur ne correspond à vos critères de recherche.'
                  : 'Aucun utilisateur n\'est enregistré dans le système.'
                }
              </p>
            </div>
          ) : (
            <div className="table-content">
              <div className="table-header-row">
                <div className="table-cell">Utilisateur</div>
                <div className="table-cell">Rôle</div>
                <div className="table-cell">Statut</div>
                <div className="table-cell">Dernière connexion</div>
                <div className="table-cell">Actions</div>
              </div>
              
              {filteredUsers.map((user) => {
                const RoleIcon = getRoleIcon(user.role);
                
                return (
                  <div key={user.id} className="table-row">
                    <div className="table-cell">
                      <div className="user-info">
                        <div className="user-avatar">
                          <div 
                            className="avatar-circle"
                            style={{ backgroundColor: getRoleColor(user.role) }}
                          >
                            {user.fullName.charAt(0).toUpperCase()}
                          </div>
                        </div>
                        <div className="user-details">
                          <div className="user-name">{user.fullName}</div>
                          <div className="user-email">{user.email}</div>
                          {user.restaurantName && (
                            <div className="user-restaurant">{user.restaurantName}</div>
                          )}
                        </div>
                      </div>
                    </div>
                    
                    <div className="table-cell">
                      <div className="role-badge" style={{ backgroundColor: getRoleColor(user.role) }}>
                        <RoleIcon className="role-icon" />
                        <span>{getRoleLabel(user.role)}</span>
                      </div>
                    </div>
                    
                    <div className="table-cell">
                      <div className={`status-badge ${user.isActive ? 'active' : 'inactive'}`}>
                        {user.isActive ? (
                          <>
                            <CheckCircle className="status-icon" />
                            <span>Actif</span>
                          </>
                        ) : (
                          <>
                            <XCircle className="status-icon" />
                            <span>Inactif</span>
                          </>
                        )}
                      </div>
                    </div>
                    
                    <div className="table-cell">
                      <div className="last-login">
                        {user.lastLogin ? (
                          <>
                            <Calendar className="date-icon" />
                            <span>{new Date(user.lastLogin).toLocaleDateString('fr-FR')}</span>
                          </>
                        ) : (
                          <span className="never-logged">Jamais connecté</span>
                        )}
                      </div>
                    </div>
                    
                    <div className="table-cell">
                      <div className="action-buttons">
                        <button 
                          className="btn btn-outline-primary btn-sm"
                          onClick={() => setEditingUser(user)}
                          title="Voir les détails"
                        >
                          <Eye />
                        </button>
                        <button 
                          className="btn btn-outline-secondary btn-sm"
                          onClick={() => setEditingUser(user)}
                          title="Modifier"
                        >
                          <Edit />
                        </button>
                        <button 
                          className={`btn btn-sm ${user.isActive ? 'btn-warning' : 'btn-success'}`}
                          onClick={() => handleToggleUserStatus(user.id)}
                          title={user.isActive ? 'Désactiver' : 'Activer'}
                        >
                          {user.isActive ? <XCircle /> : <CheckCircle />}
                        </button>
                        <button 
                          className="btn btn-outline-danger btn-sm"
                          onClick={() => handleDeleteUser(user.id)}
                          title="Supprimer"
                        >
                          <Trash2 />
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ProfessionalUsers;
