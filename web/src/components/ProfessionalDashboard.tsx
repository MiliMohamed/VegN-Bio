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
  Eye,
  BarChart3,
  PieChart,
  RefreshCw,
  Filter,
  Download,
  Bell,
  Settings,
  MessageSquare,
  Heart,
  Leaf,
  Zap,
  Target,
  Award,
  Globe
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { 
  restaurantService, 
  menuService, 
  eventService, 
  marketplaceService,
  feedbackService,
  bookingService,
  userService
} from '../services/api';

interface DashboardStats {
  restaurants: number;
  menus: number;
  events: number;
  reviews: number;
  suppliers: number;
  revenue: number;
  activeUsers: number;
  pendingReviews: number;
  bookings: number;
  totalProducts: number;
  averageRating: number;
  monthlyGrowth: number;
}

interface RecentActivity {
  id: number;
  type: 'review' | 'event' | 'menu' | 'supplier' | 'booking' | 'user';
  message: string;
  time: string;
  icon: React.ComponentType<any>;
  color: string;
  value?: string;
}

interface QuickAction {
  title: string;
  description: string;
  icon: React.ComponentType<any>;
  color: string;
  action: string;
  badge?: string;
}

interface PerformanceMetric {
  label: string;
  value: number;
  change: number;
  changeType: 'increase' | 'decrease';
  icon: React.ComponentType<any>;
  color: string;
}

const ProfessionalDashboard: React.FC = () => {
  const { user } = useAuth();
  const [stats, setStats] = useState<DashboardStats>({
    restaurants: 0,
    menus: 0,
    events: 0,
    reviews: 0,
    suppliers: 0,
    revenue: 0,
    activeUsers: 0,
    pendingReviews: 0,
    bookings: 0,
    totalProducts: 0,
    averageRating: 0,
    monthlyGrowth: 0
  });
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [lastUpdated, setLastUpdated] = useState<Date>(new Date());

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    try {
      setLoading(true);
      
      // Charger les données en parallèle
      const [
        restaurantsRes,
        menusRes,
        eventsRes,
        suppliersRes,
        reviewsRes,
        bookingsRes,
        usersRes
      ] = await Promise.allSettled([
        restaurantService.getAll(),
        Promise.all([1, 2, 3, 4, 5, 6, 7].map(id => 
          menuService.getMenusByRestaurant(id).catch(() => ({ data: [] }))
        )),
        eventService.getAll(),
        marketplaceService.getSuppliers(),
        feedbackService.getReviews(),
        bookingService.getBookingsByEvent(1).catch(() => ({ data: [] })),
        userService.getUsers().catch(() => ({ data: [] }))
      ]);

      // Calculer les statistiques
      const restaurants = restaurantsRes.status === 'fulfilled' ? restaurantsRes.value.data.length : 0;
      const menus = menusRes.status === 'fulfilled' ? 
        menusRes.value.reduce((acc: number, curr: any) => acc + curr.data.length, 0) : 0;
      const events = eventsRes.status === 'fulfilled' ? eventsRes.value.data.length : 0;
      const suppliers = suppliersRes.status === 'fulfilled' ? suppliersRes.value.data.length : 0;
      const reviews = reviewsRes.status === 'fulfilled' ? reviewsRes.value.data.length : 0;
      const bookings = bookingsRes.status === 'fulfilled' ? bookingsRes.value.data.length : 0;
      const users = usersRes.status === 'fulfilled' ? usersRes.value.data.length : 0;

      setStats({
        restaurants,
        menus,
        events,
        reviews,
        suppliers,
        revenue: 12500,
        activeUsers: users,
        pendingReviews: Math.floor(reviews * 0.1),
        bookings,
        totalProducts: suppliers * 15,
        averageRating: 4.8,
        monthlyGrowth: 12.5
      });

      setLastUpdated(new Date());
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await loadDashboardData();
  };

  const getRoleGreeting = () => {
    switch (user?.role) {
      case 'ADMIN': return 'Administrateur';
      case 'RESTAURATEUR': return 'Chef Restaurateur';
      case 'CLIENT': return 'Cher Client';
      default: return 'Utilisateur';
    }
  };

  const getTimeGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  };

  const performanceMetrics: PerformanceMetric[] = [
    {
      label: 'Nouveaux Restaurants',
      value: stats.restaurants,
      change: 2,
      changeType: 'increase',
      icon: Building2,
      color: 'primary'
    },
    {
      label: 'Menus Actifs',
      value: stats.menus,
      change: 5,
      changeType: 'increase',
      icon: Utensils,
      color: 'success'
    },
    {
      label: 'Événements',
      value: stats.events,
      change: 1,
      changeType: 'increase',
      icon: Calendar,
      color: 'warning'
    },
    {
      label: 'Avis Clients',
      value: stats.reviews,
      change: 12,
      changeType: 'increase',
      icon: Star,
      color: 'info'
    }
  ];

  const recentActivities: RecentActivity[] = [
    {
      id: 1,
      type: 'review',
      message: 'Nouvel avis 5 étoiles pour VegN-Bio Bastille',
      time: 'Il y a 5 minutes',
      icon: Star,
      color: 'success',
      value: '5.0'
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
    },
    {
      id: 5,
      type: 'booking',
      message: 'Nouvelle réservation pour l\'atelier de demain',
      time: 'Il y a 4 heures',
      icon: Users,
      color: 'success'
    }
  ];

  const quickActions: QuickAction[] = [
    {
      title: 'Créer un Menu',
      description: 'Ajouter un nouveau menu saisonnier',
      icon: Plus,
      color: 'success',
      action: '/app/menus'
    },
    {
      title: 'Nouvel Événement',
      description: 'Organiser un atelier ou conférence',
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
    },
    {
      title: 'Rapports',
      description: 'Analyser les performances',
      icon: BarChart3,
      color: 'accent',
      action: '/app/reports'
    }
  ];

  if (loading) {
    return (
      <div className="professional-dashboard">
        <div className="dashboard-loading">
          <div className="loading-spinner">
            <Activity className="spinner-icon" />
            <p>Chargement du tableau de bord...</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="professional-dashboard">
      {/* Header Section */}
      <div className="dashboard-header">
        <div className="header-content">
          <div className="welcome-section">
            <h1 className="dashboard-title">
              {getTimeGreeting()}, {user?.name}! 👋
            </h1>
            <p className="dashboard-subtitle">
              {getRoleGreeting()} - Voici un aperçu complet de votre écosystème VegN-Bio
            </p>
            <div className="last-updated">
              <Clock className="update-icon" />
              <span>Dernière mise à jour: {lastUpdated.toLocaleTimeString('fr-FR')}</span>
            </div>
          </div>
          <div className="header-actions">
            <button 
              className={`btn btn-outline-primary ${refreshing ? 'loading' : ''}`}
              onClick={handleRefresh}
              disabled={refreshing}
            >
              <RefreshCw className={`btn-icon ${refreshing ? 'spinning' : ''}`} />
              Actualiser
            </button>
            <button className="btn btn-primary">
              <Download className="btn-icon" />
              Exporter
            </button>
          </div>
        </div>
      </div>

      {/* Performance Metrics Grid */}
      <div className="metrics-grid">
        {performanceMetrics.map((metric, index) => {
          const Icon = metric.icon;
          return (
            <div key={index} className={`metric-card metric-${metric.color}`}>
              <div className="metric-header">
                <div className="metric-icon">
                  <Icon />
                </div>
                <div className="metric-change">
                  {metric.changeType === 'increase' ? (
                    <ArrowUpRight className="change-icon increase" />
                  ) : (
                    <ArrowDownRight className="change-icon decrease" />
                  )}
                  <span className={`change-text ${metric.changeType}`}>
                    +{metric.change}
                  </span>
                </div>
              </div>
              <div className="metric-content">
                <div className="metric-value">{metric.value}</div>
                <div className="metric-label">{metric.label}</div>
              </div>
              <div className="metric-trend">
                <div className="trend-line"></div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Main Dashboard Content */}
      <div className="dashboard-content">
        <div className="content-grid">
          {/* Recent Activities */}
          <div className="content-section">
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
                        <div className={`activity-icon activity-${activity.color}`}>
                          <Icon />
                        </div>
                        <div className="activity-content">
                          <p className="activity-message">{activity.message}</p>
                          <div className="activity-meta">
                            <span className="activity-time">{activity.time}</span>
                            {activity.value && (
                              <span className="activity-value">{activity.value}</span>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>

          {/* Quick Actions */}
          <div className="content-section">
            <div className="content-card">
              <div className="content-card-header">
                <h3 className="content-card-title">
                  <Zap className="card-icon" />
                  Actions Rapides
                </h3>
              </div>
              <div className="content-card-body">
                <div className="quick-actions-grid">
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
        <div className="stats-row">
          <div className="stat-card">
            <div className="stat-icon">
              <Users />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.activeUsers}</div>
              <div className="stat-label">Utilisateurs Actifs</div>
              <div className="stat-change positive">+{Math.floor(stats.activeUsers * 0.1)}</div>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon">
              <DollarSign />
            </div>
            <div className="stat-content">
              <div className="stat-value">€{stats.revenue.toLocaleString()}</div>
              <div className="stat-label">Revenus du Mois</div>
              <div className="stat-change positive">+{stats.monthlyGrowth}%</div>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon">
              <ShoppingBag />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.totalProducts}</div>
              <div className="stat-label">Produits Disponibles</div>
              <div className="stat-change positive">+{Math.floor(stats.totalProducts * 0.05)}</div>
            </div>
          </div>
          <div className="stat-card">
            <div className="stat-icon">
              <Award />
            </div>
            <div className="stat-content">
              <div className="stat-value">{stats.averageRating}/5</div>
              <div className="stat-label">Note Moyenne</div>
              <div className="stat-change positive">+0.2</div>
            </div>
          </div>
        </div>

        {/* Performance Charts Placeholder */}
        <div className="charts-section">
          <div className="content-card">
            <div className="content-card-header">
              <h3 className="content-card-title">
                <BarChart3 className="card-icon" />
                Analyse de Performance
              </h3>
              <div className="chart-controls">
                <button className="btn btn-outline-secondary btn-sm">7 jours</button>
                <button className="btn btn-primary btn-sm">30 jours</button>
                <button className="btn btn-outline-secondary btn-sm">90 jours</button>
                <button className="btn btn-outline-secondary btn-sm">
                  <Filter className="btn-icon" />
                  Filtres
                </button>
              </div>
            </div>
            <div className="content-card-body">
              <div className="charts-grid">
                <div className="chart-container">
                  <div className="chart-placeholder">
                    <PieChart className="chart-icon" />
                    <h4>Répartition des Revenus</h4>
                    <p>Analyse des sources de revenus par restaurant</p>
                    <button className="btn btn-primary btn-sm">
                      <Eye className="btn-icon" />
                      Voir Détails
                    </button>
                  </div>
                </div>
                <div className="chart-container">
                  <div className="chart-placeholder">
                    <TrendingUp className="chart-icon" />
                    <h4>Tendance des Visiteurs</h4>
                    <p>Évolution du nombre de visiteurs et réservations</p>
                    <button className="btn btn-primary btn-sm">
                      <Eye className="btn-icon" />
                      Voir Détails
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* System Health */}
        <div className="system-health">
          <div className="content-card">
            <div className="content-card-header">
              <h3 className="content-card-title">
                <Heart className="card-icon" />
                État du Système
              </h3>
            </div>
            <div className="content-card-body">
              <div className="health-metrics">
                <div className="health-item healthy">
                  <CheckCircle className="health-icon" />
                  <div className="health-content">
                    <div className="health-label">Backend API</div>
                    <div className="health-status">Opérationnel</div>
                  </div>
                </div>
                <div className="health-item healthy">
                  <CheckCircle className="health-icon" />
                  <div className="health-content">
                    <div className="health-label">Base de Données</div>
                    <div className="health-status">Connectée</div>
                  </div>
                </div>
                <div className="health-item healthy">
                  <CheckCircle className="health-icon" />
                  <div className="health-content">
                    <div className="health-label">Services Externes</div>
                    <div className="health-status">Disponibles</div>
                  </div>
                </div>
                <div className="health-item warning">
                  <AlertCircle className="health-icon" />
                  <div className="health-content">
                    <div className="health-label">Avis en Attente</div>
                    <div className="health-status">{stats.pendingReviews} en attente</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfessionalDashboard;
