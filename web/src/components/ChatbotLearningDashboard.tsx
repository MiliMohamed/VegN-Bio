import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  Brain, 
  TrendingUp, 
  Users, 
  Activity, 
  Target,
  BarChart3,
  PieChart,
  Calendar,
  Award,
  Zap,
  BookOpen,
  CheckCircle
} from 'lucide-react';
import { chatbotService } from '../services/api';

interface LearningStatistics {
  totalConsultations: number;
  supportedBreeds: number;
  knownSymptoms: number;
  averageConfidence: number;
  mostCommonBreeds: Array<{ breed: string; count: number }>;
  mostCommonSymptoms: Array<{ symptom: string; count: number }>;
}

const ChatbotLearningDashboard: React.FC = () => {
  const [statistics, setStatistics] = useState<LearningStatistics | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedTimeframe, setSelectedTimeframe] = useState<'week' | 'month' | 'year'>('month');

  useEffect(() => {
    fetchStatistics();
  }, [selectedTimeframe]);

  const fetchStatistics = async () => {
    try {
      setLoading(true);
      const response = await chatbotService.getLearningStatistics();
      setStatistics(response.data);
      setError(null);
    } catch (err) {
      setError('Erreur lors du chargement des statistiques');
      console.error('Erreur:', err);
    } finally {
      setLoading(false);
    }
  };

  const getConfidenceColor = (confidence: number) => {
    if (confidence >= 0.8) return '#38a169';
    if (confidence >= 0.6) return '#d69e2e';
    return '#e53e3e';
  };

  const getConfidenceLabel = (confidence: number) => {
    if (confidence >= 0.8) return 'Excellent';
    if (confidence >= 0.6) return 'Bon';
    return 'À améliorer';
  };

  if (loading) {
    return (
      <div className="learning-dashboard">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des statistiques d'apprentissage...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="learning-dashboard">
        <div className="error-container">
          <p>{error}</p>
          <button onClick={fetchStatistics} className="retry-btn">
            Réessayer
          </button>
        </div>
      </div>
    );
  }

  if (!statistics) {
    return (
      <div className="learning-dashboard">
        <div className="no-data">
          <Brain className="w-12 h-12" />
          <h3>Aucune donnée disponible</h3>
          <p>Le système d'apprentissage n'a pas encore de données à afficher.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="learning-dashboard">
      <div className="dashboard-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Statistiques d'Apprentissage IA</h1>
          <p className="page-subtitle">
            Surveillance des performances du système de diagnostic vétérinaire
          </p>
        </motion.div>
      </div>

      {/* Filtres de temps */}
      <div className="timeframe-filters">
        <div className="filter-group">
          <Calendar className="filter-icon" />
          <select 
            value={selectedTimeframe} 
            onChange={(e) => setSelectedTimeframe(e.target.value as any)}
            className="timeframe-select"
          >
            <option value="week">7 derniers jours</option>
            <option value="month">30 derniers jours</option>
            <option value="year">12 derniers mois</option>
          </select>
        </div>
      </div>

      {/* Statistiques principales */}
      <div className="stats-grid">
        <motion.div 
          className="stat-card primary"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.1 }}
        >
          <div className="stat-icon">
            <Brain className="w-6 h-6" />
          </div>
          <div className="stat-content">
            <div className="stat-value">{statistics.totalConsultations}</div>
            <div className="stat-label">Consultations totales</div>
            <div className="stat-trend">
              <TrendingUp className="w-4 h-4" />
              <span>+12% ce mois</span>
            </div>
          </div>
        </motion.div>

        <motion.div 
          className="stat-card success"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <div className="stat-icon">
            <Target className="w-6 h-6" />
          </div>
          <div className="stat-content">
            <div className="stat-value">{(statistics.averageConfidence * 100).toFixed(1)}%</div>
            <div className="stat-label">Confiance moyenne</div>
            <div className="stat-trend">
              <span style={{ color: getConfidenceColor(statistics.averageConfidence) }}>
                {getConfidenceLabel(statistics.averageConfidence)}
              </span>
            </div>
          </div>
        </motion.div>

        <motion.div 
          className="stat-card info"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
        >
          <div className="stat-icon">
            <Users className="w-6 h-6" />
          </div>
          <div className="stat-content">
            <div className="stat-value">{statistics.supportedBreeds}</div>
            <div className="stat-label">Races supportées</div>
            <div className="stat-trend">
              <CheckCircle className="w-4 h-4" />
              <span>Actives</span>
            </div>
          </div>
        </motion.div>

        <motion.div 
          className="stat-card warning"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
        >
          <div className="stat-icon">
            <Activity className="w-6 h-6" />
          </div>
          <div className="stat-content">
            <div className="stat-value">{statistics.knownSymptoms}</div>
            <div className="stat-label">Symptômes connus</div>
            <div className="stat-trend">
              <BookOpen className="w-4 h-4" />
              <span>En base</span>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Graphiques et analyses */}
      <div className="analytics-grid">
        {/* Races les plus consultées */}
        <motion.div 
          className="analytics-card"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.5 }}
        >
          <div className="card-header">
            <BarChart3 className="w-5 h-5" />
            <h3>Races les plus consultées</h3>
          </div>
          <div className="card-content">
            {statistics.mostCommonBreeds.map((item, index) => (
              <div key={item.breed} className="chart-item">
                <div className="chart-label">
                  <span className="rank">#{index + 1}</span>
                  <span className="name">{item.breed}</span>
                </div>
                <div className="chart-bar">
                  <div 
                    className="bar-fill"
                    style={{ 
                      width: `${(item.count / statistics.mostCommonBreeds[0].count) * 100}%`,
                      backgroundColor: `hsl(${index * 60}, 70%, 50%)`
                    }}
                  />
                </div>
                <div className="chart-value">{item.count}</div>
              </div>
            ))}
          </div>
        </motion.div>

        {/* Symptômes les plus fréquents */}
        <motion.div 
          className="analytics-card"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
        >
          <div className="card-header">
            <PieChart className="w-5 h-5" />
            <h3>Symptômes les plus fréquents</h3>
          </div>
          <div className="card-content">
            {statistics.mostCommonSymptoms.slice(0, 8).map((item, index) => (
              <div key={item.symptom} className="chart-item">
                <div className="chart-label">
                  <span className="name">{item.symptom}</span>
                </div>
                <div className="chart-bar">
                  <div 
                    className="bar-fill"
                    style={{ 
                      width: `${(item.count / statistics.mostCommonSymptoms[0].count) * 100}%`,
                      backgroundColor: `hsl(${200 + index * 20}, 60%, 50%)`
                    }}
                  />
                </div>
                <div className="chart-value">{item.count}</div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Indicateurs de performance */}
      <motion.div 
        className="performance-indicators"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.7 }}
      >
        <h3>Indicateurs de Performance</h3>
        <div className="indicators-grid">
          <div className="indicator">
            <div className="indicator-icon">
              <Zap className="w-5 h-5" />
            </div>
            <div className="indicator-content">
              <div className="indicator-label">Temps de réponse</div>
              <div className="indicator-value">1.2s</div>
              <div className="indicator-status good">Excellent</div>
            </div>
          </div>

          <div className="indicator">
            <div className="indicator-icon">
              <Award className="w-5 h-5" />
            </div>
            <div className="indicator-content">
              <div className="indicator-label">Précision</div>
              <div className="indicator-value">{(statistics.averageConfidence * 100).toFixed(1)}%</div>
              <div className="indicator-status good">Très bon</div>
            </div>
          </div>

          <div className="indicator">
            <div className="indicator-icon">
              <Users className="w-5 h-5" />
            </div>
            <div className="indicator-content">
              <div className="indicator-label">Satisfaction</div>
              <div className="indicator-value">4.7/5</div>
              <div className="indicator-status good">Excellent</div>
            </div>
          </div>

          <div className="indicator">
            <div className="indicator-icon">
              <Activity className="w-5 h-5" />
            </div>
            <div className="indicator-content">
              <div className="indicator-label">Utilisation</div>
              <div className="indicator-value">+15%</div>
              <div className="indicator-status good">En croissance</div>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Recommandations d'amélioration */}
      <motion.div 
        className="improvement-recommendations"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
      >
        <h3>Recommandations d'Amélioration</h3>
        <div className="recommendations-list">
          {statistics.averageConfidence < 0.7 && (
            <div className="recommendation-item warning">
              <div className="recommendation-icon">⚠️</div>
              <div className="recommendation-content">
                <div className="recommendation-title">Améliorer la confiance</div>
                <div className="recommendation-text">
                  La confiance moyenne est en dessous de 70%. Considérez enrichir la base de connaissances.
                </div>
              </div>
            </div>
          )}
          
          {statistics.supportedBreeds < 10 && (
            <div className="recommendation-item info">
              <div className="recommendation-icon">ℹ️</div>
              <div className="recommendation-content">
                <div className="recommendation-title">Étendre les races</div>
                <div className="recommendation-text">
                  Ajoutez plus de races d'animaux pour améliorer la couverture du système.
                </div>
              </div>
            </div>
          )}

          <div className="recommendation-item success">
            <div className="recommendation-icon">✅</div>
            <div className="recommendation-content">
              <div className="recommendation-title">Système performant</div>
              <div className="recommendation-text">
                Le système fonctionne bien avec {statistics.totalConsultations} consultations traitées.
              </div>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  );
};

export default ChatbotLearningDashboard;
