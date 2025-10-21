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
  Heart
} from 'lucide-react';
import { restaurantService, eventService, feedbackService } from '../services/api';

interface DashboardStats {
  totalRestaurants: number;
  totalEvents: number;
  totalReviews: number;
  averageRating: number;
  upcomingEvents: number;
  pendingReviews: number;
}

const ModernDashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats>({
    totalRestaurants: 0,
    totalEvents: 0,
    totalReviews: 0,
    averageRating: 0,
    upcomingEvents: 0,
    pendingReviews: 0
  });
  const [loading, setLoading] = useState(true);

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
          pendingReviews: 0 // À implémenter selon l'API
        });
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  const statCards = [
    {
      title: 'Restaurants',
      value: stats.totalRestaurants,
      icon: <MapPin className="w-6 h-6" />,
      color: 'primary',
      change: '+2 ce mois',
      trend: 'up'
    },
    {
      title: 'Événements',
      value: stats.totalEvents,
      icon: <Calendar className="w-6 h-6" />,
      color: 'success',
      change: '+5 cette semaine',
      trend: 'up'
    },
    {
      title: 'Avis clients',
      value: stats.totalReviews,
      icon: <Star className="w-6 h-6" />,
      color: 'warning',
      change: '+12 aujourd\'hui',
      trend: 'up'
    },
    {
      title: 'Note moyenne',
      value: stats.averageRating,
      icon: <Heart className="w-6 h-6" />,
      color: 'info',
      change: '+0.2 cette semaine',
      trend: 'up'
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
      color: 'success'
    },
    {
      id: 2,
      type: 'review',
      title: 'Nouvel avis client',
      description: 'Excellent restaurant ! - Bastille',
      time: 'Il y a 4 heures',
      icon: <Star className="w-4 h-4" />,
      color: 'warning'
    },
    {
      id: 3,
      type: 'menu',
      title: 'Menu mis à jour',
      description: 'Menu Printemps Bio - Nation',
      time: 'Il y a 6 heures',
      icon: <Utensils className="w-4 h-4" />,
      color: 'info'
    },
    {
      id: 4,
      type: 'user',
      title: 'Nouvel utilisateur',
      description: 'Inscription client - Place d\'Italie',
      time: 'Il y a 8 heures',
      icon: <Users className="w-4 h-4" />,
      color: 'primary'
    }
  ];

  const quickActions = [
    {
      title: 'Ajouter un événement',
      description: 'Créer un nouvel événement ou animation',
      icon: <Calendar className="w-8 h-8" />,
      color: 'success',
      action: '/app/events'
    },
    {
      title: 'Gérer les menus',
      description: 'Modifier les cartes des restaurants',
      icon: <Utensils className="w-8 h-8" />,
      color: 'primary',
      action: '/app/menus'
    },
    {
      title: 'Voir les avis',
      description: 'Consulter les retours clients',
      icon: <Star className="w-8 h-8" />,
      color: 'warning',
      action: '/app/reviews'
    },
    {
      title: 'Réservations',
      description: 'Gérer les réservations de salles',
      icon: <Clock className="w-8 h-8" />,
      color: 'info',
      action: '/app/rooms'
    }
  ];

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
            whileHover={{ y: -5 }}
          >
            <div className="stat-icon">
              {stat.icon}
            </div>
            <div className="stat-content">
              <div className="modern-stat-value">{stat.value}</div>
              <div className="modern-stat-label">{stat.title}</div>
              <div className={`modern-stat-change ${stat.trend}`}>
                {stat.trend === 'up' ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
                {stat.change}
              </div>
            </div>
          </motion.div>
        ))}
      </motion.div>

      <div className="dashboard-content">
        {/* Activités récentes */}
        <motion.div 
          className="dashboard-section"
          initial={{ opacity: 0, x: -30 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
        >
          <div className="section-header">
            <h2 className="section-title">Activités récentes</h2>
            <p className="section-subtitle">Dernières actions sur la plateforme</p>
          </div>
          
          <div className="activities-list">
            {recentActivities.map((activity, index) => (
              <motion.div
                key={activity.id}
                className="activity-item"
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.4, delay: 0.5 + index * 0.1 }}
              >
                <div className={`activity-icon activity-${activity.color}`}>
                  {activity.icon}
                </div>
                <div className="activity-content">
                  <div className="activity-title">{activity.title}</div>
                  <div className="activity-description">{activity.description}</div>
                  <div className="activity-time">{activity.time}</div>
                </div>
                <div className="activity-status">
                  <CheckCircle className="w-4 h-4" />
                </div>
              </motion.div>
            ))}
          </div>
        </motion.div>

        {/* Actions rapides */}
        <motion.div 
          className="dashboard-section"
          initial={{ opacity: 0, x: 30 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
        >
          <div className="section-header">
            <h2 className="section-title">Actions rapides</h2>
            <p className="section-subtitle">Accès direct aux fonctionnalités principales</p>
          </div>
          
          <div className="quick-actions-grid">
            {quickActions.map((action, index) => (
              <motion.a
                key={action.title}
                href={action.action}
                className={`quick-action-card action-${action.color}`}
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.7 + index * 0.1 }}
                whileHover={{ y: -5, scale: 1.02 }}
              >
                <div className="action-icon">
                  {action.icon}
                </div>
                <div className="action-content">
                  <h3 className="action-title">{action.title}</h3>
                  <p className="action-description">{action.description}</p>
                </div>
                <div className="action-arrow">
                  →
                </div>
              </motion.a>
            ))}
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default ModernDashboard;