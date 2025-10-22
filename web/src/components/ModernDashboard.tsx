import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  Users, 
  MapPin, 
  Utensils, 
  Calendar,
  TrendingUp,
  TrendingDown,
  Star,
  Clock,
  CheckCircle,
  AlertCircle,
  Leaf,
  Heart,
  ShoppingCart,
  MessageCircle,
  Eye,
  ArrowRight
} from 'lucide-react';
import { restaurantService, eventService, feedbackService } from '../services/api';
import { useTheme } from '../contexts/ThemeContext';
import ModernTable from './ModernTable';
import FloatingActionButton from './FloatingActionButton';

interface DashboardStats {
  totalRestaurants: number;
  totalEvents: number;
  totalReviews: number;
  averageRating: number;
  upcomingEvents: number;
  pendingReviews: number;
  totalUsers: number;
  totalOrders: number;
}

interface StatCard {
  title: string;
  value: number | string;
  icon: React.ReactNode;
  color: 'primary' | 'success' | 'warning' | 'info' | 'danger';
  change: string;
  trend: 'up' | 'down' | 'neutral';
  description?: string;
}

const ModernDashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats>({
    totalRestaurants: 0,
    totalEvents: 0,
    totalReviews: 0,
    averageRating: 0,
    upcomingEvents: 0,
    pendingReviews: 0,
    totalUsers: 0,
    totalOrders: 0
  });
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'overview' | 'recent' | 'analytics'>('overview');
  const { actualTheme } = useTheme();

  useEffect(() => {
    const fetchDashboardData = async () => {
      try {
        const [restaurantsRes, eventsRes, reviewsRes] = await Promise.all([
          restaurantService.getAll(),
          eventService.getAll(),
          feedbackService.getReviews()
        ]);

        const restaurants = restaurantsRes.data;
        const events = eventsRes.data;
        const reviews = reviewsRes.data;

        // Calculer les statistiques
        const now = new Date();
        const upcomingEvents = events.filter((event: any) => 
          new Date(event.dateStart) > now
        ).length;

        const averageRating = reviews.length > 0 
          ? reviews.reduce((sum: number, review: any) => sum + review.rating, 0) / reviews.length
          : 0;

        setStats({
          totalRestaurants: restaurants.length,
          totalEvents: events.length,
          totalReviews: reviews.length,
          averageRating: Math.round(averageRating * 10) / 10,
          upcomingEvents,
          pendingReviews: 0, // À implémenter selon l'API
          totalUsers: 156, // Données simulées
          totalOrders: 1247 // Données simulées
        });
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  const statCards: StatCard[] = [
    {
      title: 'Restaurants',
      value: stats.totalRestaurants,
      icon: <MapPin className="w-6 h-6" />,
      color: 'primary',
      change: '+2 ce mois',
      trend: 'up',
      description: 'Établissements actifs'
    },
    {
      title: 'Utilisateurs',
      value: stats.totalUsers,
      icon: <Users className="w-6 h-6" />,
      color: 'success',
      change: '+12 cette semaine',
      trend: 'up',
      description: 'Clients enregistrés'
    },
    {
      title: 'Commandes',
      value: stats.totalOrders,
      icon: <ShoppingCart className="w-6 h-6" />,
      color: 'warning',
      change: '+45 aujourd\'hui',
      trend: 'up',
      description: 'Commandes totales'
    },
    {
      title: 'Note moyenne',
      value: stats.averageRating,
      icon: <Star className="w-6 h-6" />,
      color: 'info',
      change: '+0.2 cette semaine',
      trend: 'up',
      description: 'Satisfaction clients'
    },
    {
      title: 'Événements',
      value: stats.totalEvents,
      icon: <Calendar className="w-6 h-6" />,
      color: 'success',
      change: '+5 cette semaine',
      trend: 'up',
      description: 'Événements organisés'
    },
    {
      title: 'Avis clients',
      value: stats.totalReviews,
      icon: <Heart className="w-6 h-6" />,
      color: 'warning',
      change: '+24 aujourd\'hui',
      trend: 'up',
      description: 'Retours clients'
    }
  ];

  const recentActivities = [
    {
      id: 1,
      type: 'event',
      title: 'Nouvel événement créé',
      description: 'Conférence sur l\'alimentation durable - République',
      time: 'Il y a 2 heures',
      icon: <Calendar className="w-4 h-4" />,
      color: 'success',
      status: 'completed'
    },
    {
      id: 2,
      type: 'review',
      title: 'Nouvel avis client',
      description: 'Excellent restaurant ! - Bastille',
      time: 'Il y a 4 heures',
      icon: <Star className="w-4 h-4" />,
      color: 'warning',
      status: 'pending'
    },
    {
      id: 3,
      type: 'menu',
      title: 'Menu mis à jour',
      description: 'Menu Printemps Bio - Nation',
      time: 'Il y a 6 heures',
      icon: <Utensils className="w-4 h-4" />,
      color: 'info',
      status: 'completed'
    },
    {
      id: 4,
      type: 'user',
      title: 'Nouvel utilisateur',
      description: 'Inscription client - Place d\'Italie',
      time: 'Il y a 8 heures',
      icon: <Users className="w-4 h-4" />,
      color: 'primary',
      status: 'completed'
    }
  ];

  const tableColumns = [
    { key: 'title', label: 'Activité', sortable: true },
    { key: 'description', label: 'Description', sortable: true },
    { key: 'time', label: 'Heure', sortable: true },
    { key: 'status', label: 'Statut', sortable: true }
  ];

  const tableData = recentActivities.map(activity => ({
    id: activity.id,
    title: (
      <div className="flex items-center gap-2">
        <div className={`w-8 h-8 rounded-full flex items-center justify-center bg-${activity.color}-100 text-${activity.color}-600`}>
          {activity.icon}
        </div>
        <span className="font-medium">{activity.title}</span>
      </div>
    ),
    description: activity.description,
    time: activity.time,
    status: activity.status
  }));

  if (loading) {
    return (
      <div className="modern-dashboard">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des données...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-dashboard">
      {/* Header */}
      <div className="dashboard-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="dashboard-title">
            <Leaf className="w-8 h-8" />
            Tableau de bord VegN Bio
          </h1>
          <p className="dashboard-subtitle">
            Bienvenue dans votre espace de gestion des restaurants végétariens et biologiques
          </p>
        </motion.div>
      </div>

      {/* Tabs */}
      <div className="dashboard-tabs">
        <button
          className={`tab-button ${activeTab === 'overview' ? 'active' : ''}`}
          onClick={() => setActiveTab('overview')}
        >
          <Eye className="w-4 h-4" />
          Vue d'ensemble
        </button>
        <button
          className={`tab-button ${activeTab === 'recent' ? 'active' : ''}`}
          onClick={() => setActiveTab('recent')}
        >
          <Clock className="w-4 h-4" />
          Activités récentes
        </button>
        <button
          className={`tab-button ${activeTab === 'analytics' ? 'active' : ''}`}
          onClick={() => setActiveTab('analytics')}
        >
          <TrendingUp className="w-4 h-4" />
          Analytiques
        </button>
      </div>

      {/* Content */}
      <div className="dashboard-content">
        {activeTab === 'overview' && (
          <>
            {/* Statistiques */}
            <motion.div 
              className="modern-stats"
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.2 }}
            >
              {statCards.map((stat, index) => (
                <motion.div
                  key={stat.title}
                  className={`modern-stat-card stat-${stat.color}`}
                  initial={{ opacity: 0, y: 30 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.6, delay: 0.3 + index * 0.1 }}
                  whileHover={{ y: -5, scale: 1.02 }}
                >
                  <div className="stat-icon">
                    {stat.icon}
                  </div>
                  <div className="stat-content">
                    <div className="modern-stat-value">{stat.value}</div>
                    <div className="modern-stat-label">{stat.title}</div>
                    <div className="modern-stat-description">{stat.description}</div>
                    <div className={`modern-stat-change ${stat.trend}`}>
                      {stat.trend === 'up' ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
                      {stat.change}
                    </div>
                  </div>
                </motion.div>
              ))}
            </motion.div>

            {/* Quick Actions */}
            <motion.div 
              className="dashboard-section"
              initial={{ opacity: 0, x: -30 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.6, delay: 0.4 }}
            >
              <div className="section-header">
                <h2 className="section-title">Actions rapides</h2>
                <p className="section-subtitle">Accès direct aux fonctionnalités principales</p>
              </div>
              
              <div className="quick-actions">
                <motion.button 
                  className="quick-action-card"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <Utensils className="w-6 h-6" />
                  <span>Gérer les menus</span>
                  <ArrowRight className="w-4 h-4" />
                </motion.button>
                
                <motion.button 
                  className="quick-action-card"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <Calendar className="w-6 h-6" />
                  <span>Planifier un événement</span>
                  <ArrowRight className="w-4 h-4" />
                </motion.button>
                
                <motion.button 
                  className="quick-action-card"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <MessageCircle className="w-6 h-6" />
                  <span>Assistant IA</span>
                  <ArrowRight className="w-4 h-4" />
                </motion.button>
              </div>
            </motion.div>
          </>
        )}

        {activeTab === 'recent' && (
          <motion.div 
            className="dashboard-section"
            initial={{ opacity: 0, x: -30 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6 }}
          >
            <div className="section-header">
              <h2 className="section-title">Activités récentes</h2>
              <p className="section-subtitle">Dernières actions sur la plateforme</p>
            </div>
            
            <ModernTable
              data={tableData}
              columns={tableColumns}
              searchable={true}
              filterable={true}
              emptyMessage="Aucune activité récente"
            />
          </motion.div>
        )}

        {activeTab === 'analytics' && (
          <motion.div 
            className="dashboard-section"
            initial={{ opacity: 0, x: -30 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6 }}
          >
            <div className="section-header">
              <h2 className="section-title">Analytiques</h2>
              <p className="section-subtitle">Statistiques détaillées et tendances</p>
            </div>
            
            <div className="analytics-placeholder">
              <TrendingUp className="w-12 h-12" />
              <h3>Analytiques en cours de développement</h3>
              <p>Les graphiques et statistiques détaillées seront bientôt disponibles.</p>
            </div>
          </motion.div>
        )}
      </div>

      {/* Floating Action Button */}
      <FloatingActionButton
        onCreate={() => console.log('Create action')}
        onEdit={() => console.log('Edit action')}
        onDelete={() => console.log('Delete action')}
        onView={() => console.log('View action')}
        onSettings={() => console.log('Settings action')}
      />
    </div>
  );
};

export default ModernDashboard;