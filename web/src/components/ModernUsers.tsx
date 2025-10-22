import React from 'react';
import { motion } from 'framer-motion';
import { 
  Users, 
  UserPlus, 
  Edit, 
  Trash2, 
  Eye,
  Shield,
  Mail,
  Calendar,
  CheckCircle,
  XCircle,
  Clock
} from 'lucide-react';
import { userService } from '../services/api';

interface User {
  id: number;
  email: string;
  fullName: string;
  role: string;
  createdAt: string;
}

const ModernUsers: React.FC = () => {
  const [users, setUsers] = React.useState<User[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [filter, setFilter] = React.useState<'all' | 'CLIENT' | 'RESTAURATEUR' | 'ADMIN'>('all');

  React.useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await userService.getUsers();
        setUsers(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des utilisateurs:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const getRoleColor = (role: string) => {
    const colors: { [key: string]: string } = {
      'ADMIN': 'danger',
      'RESTAURATEUR': 'primary',
      'CLIENT': 'info'
    };
    return colors[role] || 'secondary';
  };

  const getRoleText = (role: string) => {
    const texts: { [key: string]: string } = {
      'ADMIN': 'Administrateur',
      'RESTAURATEUR': 'Restaurateur',
      'CLIENT': 'Client'
    };
    return texts[role] || role;
  };

  const filteredUsers = users.filter(user => {
    if (filter === 'all') return true;
    return user.role === filter;
  });

  const userStats = {
    total: users.length,
    clients: users.filter(u => u.role === 'CLIENT').length,
    restaurateurs: users.filter(u => u.role === 'RESTAURATEUR').length,
    admins: users.filter(u => u.role === 'ADMIN').length
  };

  if (loading) {
    return (
      <div className="modern-users">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des utilisateurs...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-users">
      <div className="users-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Gestion des Utilisateurs</h1>
          <p className="page-subtitle">
            Gérez les comptes utilisateurs et leurs permissions
          </p>
        </motion.div>
      </div>

      <div className="users-stats">
        <motion.div
          className="stats-grid"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <div className="stat-card">
            <div className="stat-icon">
              <Users className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{userStats.total}</div>
              <div className="stat-label">Total utilisateurs</div>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon">
              <UserPlus className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{userStats.clients}</div>
              <div className="stat-label">Clients</div>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon">
              <Shield className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{userStats.restaurateurs}</div>
              <div className="stat-label">Restaurateurs</div>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon">
              <Mail className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{userStats.fournisseurs}</div>
              <div className="stat-label">Fournisseurs</div>
            </div>
          </div>
        </motion.div>
      </div>

      <div className="users-filters">
        <motion.div
          className="filter-tabs"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
        >
          <button
            className={`filter-tab ${filter === 'all' ? 'active' : ''}`}
            onClick={() => setFilter('all')}
          >
            Tous ({userStats.total})
          </button>
          <button
            className={`filter-tab ${filter === 'CLIENT' ? 'active' : ''}`}
            onClick={() => setFilter('CLIENT')}
          >
            <UserPlus className="w-4 h-4" />
            Clients ({userStats.clients})
          </button>
          <button
            className={`filter-tab ${filter === 'RESTAURATEUR' ? 'active' : ''}`}
            onClick={() => setFilter('RESTAURATEUR')}
          >
            <Shield className="w-4 h-4" />
            Restaurateurs ({userStats.restaurateurs})
          </button>
          <button
            className={`filter-tab ${filter === 'ADMIN' ? 'active' : ''}`}
            onClick={() => setFilter('ADMIN')}
          >
            <Shield className="w-4 h-4" />
            Admins ({userStats.admins})
          </button>
        </motion.div>
      </div>

      <div className="users-actions">
        <motion.button
          className="btn btn-primary"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
        >
          <UserPlus className="w-5 h-5" />
          Nouvel utilisateur
        </motion.button>
      </div>

      <div className="users-list">
        {filteredUsers.map((user, index) => (
          <motion.div
            key={user.id}
            className="user-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
          >
            <div className="user-header">
              <div className="user-avatar">
                <Users className="w-8 h-8" />
              </div>
              <div className="user-info">
                <h3 className="user-name">{user.fullName}</h3>
                <div className="user-email">{user.email}</div>
                <div className="user-role">
                  <span className={`badge badge-${getRoleColor(user.role)}`}>
                    {getRoleText(user.role)}
                  </span>
                </div>
              </div>
            </div>

            <div className="user-details">
              <div className="detail-item">
                <Calendar className="w-4 h-4" />
                <div className="detail-content">
                  <div className="detail-label">Inscription</div>
                  <div className="detail-value">{formatDate(user.createdAt)}</div>
                </div>
              </div>
              
              <div className="detail-item">
                <CheckCircle className="w-4 h-4" />
                <div className="detail-content">
                  <div className="detail-label">Statut</div>
                  <div className="detail-value">Actif</div>
                </div>
              </div>
            </div>

            <div className="user-actions">
              <button className="btn btn-primary btn-sm">
                <Eye className="w-4 h-4" />
                Voir profil
              </button>
              <button className="btn btn-secondary btn-sm">
                <Edit className="w-4 h-4" />
                Modifier
              </button>
              <button className="btn btn-danger btn-sm">
                <Trash2 className="w-4 h-4" />
                Supprimer
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {filteredUsers.length === 0 && (
        <motion.div
          className="empty-state"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <Users className="w-16 h-16" />
          <h3>Aucun utilisateur</h3>
          <p>Aucun utilisateur trouvé pour ce filtre</p>
        </motion.div>
      )}
    </div>
  );
};

export default ModernUsers;
