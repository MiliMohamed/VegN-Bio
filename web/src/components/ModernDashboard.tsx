import React, { useState, useEffect } from 'react';
import { 
  Building2, 
  Utensils, 
  Calendar, 
  Star, 
  TrendingUp, 
  Users, 
  ShoppingBag,
  DollarSign,
  Activity,
  Clock,
  CheckCircle,
  AlertCircle,
  Plus,
  ArrowUpRight,
  ArrowDownRight,
  Eye
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import DatabasePopulator from './DatabasePopulator';
import BackendTester from './BackendTester';
import ReviewsTester from './ReviewsTester';

interface DashboardStats {
  restaurants: number;
  menus: number;
  events: number;
  reviews: number;
  suppliers: number;
  revenue: number;
  activeUsers: number;
  pendingReviews: number;
}

const ModernDashboard: React.FC = () => {
  const { user } = useAuth();
  const [stats, setStats] = useState<DashboardStats>({
    restaurants: 7,
    menus: 23,
    events: 5,
    reviews: 156,
    suppliers: 12,
    revenue: 12500,
    activeUsers: 89,
    pendingReviews: 8
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simuler le chargement des données
    const timer = setTimeout(() => {
      setLoading(false);
    }, 1000);
    return () => clearTimeout(timer);
  }, []);

  const getRoleGreeting = () => {
    switch (user?.role) {
      case 'ADMIN': return 'Administrateur';
      case 'RESTAURATEUR': return 'Chef Restaurateur';
      case 'CLIENT': return 'Cher Client';
      case 'FOURNISSEUR': return 'Partenaire Fournisseur';
      default: return 'Utilisateur';
    }
  };

  const getTimeGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  };

  const statCards = [
    {
      title: 'Restaurants',
      value: stats.restaurants,
      icon: Building2,
      color: 'primary',
      change: '+2',
      changeType: 'increase'
    },
    {
      title: 'Menus Actifs',
      value: stats.menus,
      icon: Utensils,
      color: 'success',
      change: '+5',
      changeType: 'increase'
    },
    {
      title: 'Événements',
      value: stats.events,
      icon: Calendar,
      color: 'warning',
      change: '+1',
      changeType: 'increase'
    },
    {
      title: 'Avis Clients',
      value: stats.reviews,
      icon: Star,
      color: 'info',
      change: '+12',
      changeType: 'increase'
    }
  ];

  const recentActivities = [
    {
      id: 1,
      type: 'review',
      message: 'Nouvel avis 5 étoiles pour VegN-Bio Bastille',
      time: 'Il y a 5 minutes',
      icon: Star,
      color: 'success'
    },
    {
      id: 2,
      type: 'event',
      message: 'Événement "Atelier Cuisine Bio" créé',
      time: 'Il y a 1 heure',
      icon: Calendar,
      color: 'warning'
    },
    {
      id: 3,
      type: 'menu',
      message: 'Menu "Automne Bio" mis à jour',
      time: 'Il y a 2 heures',
      icon: Utensils,
      color: 'info'
    },
    {
      id: 4,
      type: 'supplier',
      message: 'Nouveau fournisseur "BioFarm" ajouté',
      time: 'Il y a 3 heures',
      icon: ShoppingBag,
      color: 'primary'
    }
  ];

  const quickActions = [
    {
      title: 'Créer un Menu',
      description: 'Ajouter un nouveau menu',
      icon: Plus,
      color: 'success',
      action: '/app/menus'
    },
    {
      title: 'Nouvel Événement',
      description: 'Organiser un événement',
      icon: Calendar,
      color: 'warning',
      action: '/app/events'
    },
    {
      title: 'Ajouter Restaurant',
      description: 'Créer un nouveau restaurant',
      icon: Building2,
      color: 'primary',
      action: '/app/restaurants'
    },
    {
      title: 'Voir les Avis',
      description: 'Consulter les retours clients',
      icon: Star,
      color: 'info',
      action: '/app/reviews'
    }
  ];

  if (loading) {
    return (
      <div className="dashboard-loading">
        <div className="loading-spinner">
          <Activity className="spinner-icon" />
          <p>Chargement du tableau de bord...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-dashboard">
      {/* Header Section */}
      <div className="dashboard-header">
        <div className="welcome-section">
          <h1 className="dashboard-title">
            {getTimeGreeting()}, {user?.name}! 👋
          </h1>
          <p className="dashboard-subtitle">
            {getRoleGreeting()} - Voici un aperçu de votre activité sur VegN-Bio
          </p>
        </div>
        <div className="header-actions">
          <div className="date-info">
            <Clock className="date-icon" />
            <span>{new Date().toLocaleDateString('fr-FR', { 
              weekday: 'long', 
              year: 'numeric', 
              month: 'long', 
              day: 'numeric' 
            })}</span>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="stats-grid">
        {statCards.map((card, index) => {
          const Icon = card.icon;
          return (
            <div key={index} className={`stat-card stat-card-${card.color}`}>
              <div className="stat-header">
                <div className="stat-icon">
                  <Icon />
                </div>
                <div className="stat-change">
                  {card.changeType === 'increase' ? (
                    <ArrowUpRight className="change-icon increase" />
                  ) : (
                    <ArrowDownRight className="change-icon decrease" />
                  )}
                  <span className={`change-text ${card.changeType}`}>
                    {card.change}
                  </span>
                </div>
              </div>
              <div className="stat-content">
                <div className="stat-value">{card.value}</div>
                <div className="stat-title">{card.title}</div>
              </div>
            </div>
          );
        })}
      </div>

      <div className="dashboard-content">
        <div className="row g-4">
          {/* Recent Activities */}
          <div className="col-lg-8">
            <div className="content-card">
              <div className="content-card-header">
                <h3 className="content-card-title">
                  <Activity className="card-icon" />
                  Activité Récente
                </h3>
                <button className="btn btn-outline-primary btn-sm">
                  <Eye className="btn-icon" />
                  Voir tout
                </button>
              </div>
              <div className="content-card-body">
                <div className="activities-list">
                  {recentActivities.map((activity) => {
                    const Icon = activity.icon;
                    return (
                      <div key={activity.id} className="activity-item">
                        <div className={`activity-icon activity-icon-${activity.color}`}>
                          <Icon />
                        </div>
                        <div className="activity-content">
                          <p className="activity-message">{activity.message}</p>
                          <span className="activity-time">{activity.time}</span>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>

          {/* Quick Actions */}
          <div className="col-lg-4">
            <div className="content-card">
              <div className="content-card-header">
                <h3 className="content-card-title">
                  <TrendingUp className="card-icon" />
                  Actions Rapides
                </h3>
              </div>
              <div className="content-card-body">
                <div className="quick-actions">
                  {quickActions.map((action, index) => {
                    const Icon = action.icon;
                    return (
                      <button key={index} className={`quick-action-btn quick-action-${action.color}`}>
                        <div className="action-icon">
                          <Icon />
                        </div>
                        <div className="action-content">
                          <div className="action-title">{action.title}</div>
                          <div className="action-description">{action.description}</div>
                        </div>
                        <ArrowUpRight className="action-arrow" />
                      </button>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Additional Stats Row */}
        <div className="row g-4 mt-4">
          <div className="col-md-3">
            <div className="mini-stat-card">
              <div className="mini-stat-icon">
                <Users />
              </div>
              <div className="mini-stat-content">
                <div className="mini-stat-value">{stats.activeUsers}</div>
                <div className="mini-stat-label">Utilisateurs Actifs</div>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <div className="mini-stat-card">
              <div className="mini-stat-icon">
                <DollarSign />
              </div>
              <div className="mini-stat-content">
                <div className="mini-stat-value">€{stats.revenue.toLocaleString()}</div>
                <div className="mini-stat-label">Revenus du Mois</div>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <div className="mini-stat-card">
              <div className="mini-stat-icon">
                <ShoppingBag />
              </div>
              <div className="mini-stat-content">
                <div className="mini-stat-value">{stats.suppliers}</div>
                <div className="mini-stat-label">Fournisseurs</div>
              </div>
            </div>
          </div>
          <div className="col-md-3">
            <div className="mini-stat-card pending-reviews">
              <div className="mini-stat-icon">
                <AlertCircle />
              </div>
              <div className="mini-stat-content">
                <div className="mini-stat-value">{stats.pendingReviews}</div>
                <div className="mini-stat-label">Avis en Attente</div>
              </div>
            </div>
          </div>
        </div>

        {/* Performance Chart Placeholder */}
        <div className="row g-4 mt-4">
          <div className="col-12">
            <div className="content-card">
              <div className="content-card-header">
                <h3 className="content-card-title">
                  <TrendingUp className="card-icon" />
                  Performance des Restaurants
                </h3>
                <div className="chart-actions">
                  <button className="btn btn-outline-secondary btn-sm">7 jours</button>
                  <button className="btn btn-primary btn-sm">30 jours</button>
                  <button className="btn btn-outline-secondary btn-sm">90 jours</button>
                </div>
              </div>
              <div className="content-card-body">
                <div className="chart-placeholder">
                  <div className="chart-info">
                    <TrendingUp className="chart-icon" />
                    <h4>Graphique de Performance</h4>
                    <p>Visualisez les tendances de vos restaurants, menus et événements</p>
                    <button className="btn btn-primary">
                      <Eye className="btn-icon" />
                      Voir les Détails
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Admin Tools - Admin Only */}
        {user?.role === 'ADMIN' && (
          <div className="row g-4 mt-4">
            <div className="col-md-4">
              <DatabasePopulator />
            </div>
            <div className="col-md-4">
              <BackendTester />
            </div>
            <div className="col-md-4">
              <ReviewsTester />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ModernDashboard;
