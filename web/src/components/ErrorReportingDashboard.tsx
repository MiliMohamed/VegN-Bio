import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  AlertTriangle, 
  Bug, 
  X, 
  Send, 
  CheckCircle, 
  Clock, 
  AlertCircle,
  Info,
  Eye,
  Filter,
  Download
} from 'lucide-react';
import { errorReportService } from '../services/api';

interface ErrorReport {
  id: number;
  title: string;
  description: string;
  errorType: string;
  severity: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  status: 'OPEN' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED';
  userAgent: string;
  url: string;
  stackTrace?: string;
  userId?: string;
  createdAt: string;
  updatedAt?: string;
}

interface ErrorStatistics {
  totalErrors: number;
  openErrors: number;
  resolvedErrors: number;
  severityStats: Record<string, number>;
  errorTypeStats: Array<{ errorType: string; count: number }>;
  recentErrors24h: number;
  resolutionRate: number;
}

const ErrorReportingDashboard: React.FC = () => {
  const [errorReports, setErrorReports] = useState<ErrorReport[]>([]);
  const [statistics, setStatistics] = useState<ErrorStatistics | null>(null);
  const [loading, setLoading] = useState(true);
  const [showReportForm, setShowReportForm] = useState(false);
  const [selectedSeverity, setSelectedSeverity] = useState<string>('all');
  const [selectedStatus, setSelectedStatus] = useState<string>('all');
  const [showStackTrace, setShowStackTrace] = useState<number | null>(null);

  useEffect(() => {
    fetchErrorReports();
    fetchStatistics();
  }, [selectedSeverity, selectedStatus]);

  const fetchErrorReports = async () => {
    try {
      const params: any = {};
      if (selectedSeverity !== 'all') params.severity = selectedSeverity;
      if (selectedStatus !== 'all') params.status = selectedStatus;
      
      const response = await errorReportService.getErrorReports(params);
      setErrorReports(response.data);
    } catch (error) {
      console.error('Erreur lors du chargement des rapports d\'erreur:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchStatistics = async () => {
    try {
      const response = await errorReportService.getErrorStatistics();
      setStatistics(response.data);
    } catch (error) {
      console.error('Erreur lors du chargement des statistiques:', error);
    }
  };

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'LOW': return '#38a169';
      case 'MEDIUM': return '#d69e2e';
      case 'HIGH': return '#dd6b20';
      case 'CRITICAL': return '#e53e3e';
      default: return '#718096';
    }
  };

  const getSeverityIcon = (severity: string) => {
    switch (severity) {
      case 'LOW': return <Info className="w-4 h-4" />;
      case 'MEDIUM': return <AlertCircle className="w-4 h-4" />;
      case 'HIGH': return <AlertTriangle className="w-4 h-4" />;
      case 'CRITICAL': return <Bug className="w-4 h-4" />;
      default: return <Info className="w-4 h-4" />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'OPEN': return '#e53e3e';
      case 'IN_PROGRESS': return '#d69e2e';
      case 'RESOLVED': return '#38a169';
      case 'CLOSED': return '#718096';
      default: return '#718096';
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('fr-FR');
  };

  const filteredReports = errorReports.filter(report => {
    const severityMatch = selectedSeverity === 'all' || report.severity === selectedSeverity;
    const statusMatch = selectedStatus === 'all' || report.status === selectedStatus;
    return severityMatch && statusMatch;
  });

  if (loading) {
    return (
      <div className="error-reporting-dashboard">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des rapports d'erreur...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="error-reporting-dashboard">
      <div className="dashboard-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Rapports d'Erreurs</h1>
          <p className="page-subtitle">
            Surveillance et gestion des erreurs de l'application
          </p>
        </motion.div>
      </div>

      {/* Statistiques */}
      {statistics && (
        <motion.div 
          className="statistics-grid"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.1 }}
        >
          <div className="stat-card">
            <div className="stat-icon total">
              <Bug className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{statistics.totalErrors}</div>
              <div className="stat-label">Total des erreurs</div>
            </div>
          </div>

          <div className="stat-card">
            <div className="stat-icon open">
              <AlertCircle className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{statistics.openErrors}</div>
              <div className="stat-label">Erreurs ouvertes</div>
            </div>
          </div>

          <div className="stat-card">
            <div className="stat-icon resolved">
              <CheckCircle className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{statistics.resolvedErrors}</div>
              <div className="stat-label">Erreurs résolues</div>
            </div>
          </div>

          <div className="stat-card">
            <div className="stat-icon rate">
              <Clock className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{(statistics.resolutionRate * 100).toFixed(1)}%</div>
              <div className="stat-label">Taux de résolution</div>
            </div>
          </div>
        </motion.div>
      )}

      {/* Filtres */}
      <div className="filters-section">
        <div className="filters">
          <div className="filter-group">
            <Filter className="filter-icon" />
            <select 
              value={selectedSeverity} 
              onChange={(e) => setSelectedSeverity(e.target.value)}
              className="filter-select"
            >
              <option value="all">Toutes les sévérités</option>
              <option value="LOW">Faible</option>
              <option value="MEDIUM">Moyenne</option>
              <option value="HIGH">Élevée</option>
              <option value="CRITICAL">Critique</option>
            </select>
          </div>

          <div className="filter-group">
            <select 
              value={selectedStatus} 
              onChange={(e) => setSelectedStatus(e.target.value)}
              className="filter-select"
            >
              <option value="all">Tous les statuts</option>
              <option value="OPEN">Ouvert</option>
              <option value="IN_PROGRESS">En cours</option>
              <option value="RESOLVED">Résolu</option>
              <option value="CLOSED">Fermé</option>
            </select>
          </div>

          <button 
            className="report-btn"
            onClick={() => setShowReportForm(true)}
          >
            <Send className="w-4 h-4" />
            Signaler une erreur
          </button>
        </div>
      </div>

      {/* Liste des rapports */}
      <div className="reports-list">
        {filteredReports.map((report, index) => (
          <motion.div
            key={report.id}
            className="report-card"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4, delay: index * 0.05 }}
          >
            <div className="report-header">
              <div className="report-title-section">
                <div className="severity-badge" style={{ backgroundColor: getSeverityColor(report.severity) }}>
                  {getSeverityIcon(report.severity)}
                  <span>{report.severity}</span>
                </div>
                <h3 className="report-title">{report.title}</h3>
              </div>
              <div className="report-meta">
                <span className="status-badge" style={{ color: getStatusColor(report.status) }}>
                  {report.status.replace('_', ' ')}
                </span>
                <span className="report-date">{formatDate(report.createdAt)}</span>
              </div>
            </div>

            <div className="report-content">
              <p className="report-description">{report.description}</p>
              
              <div className="report-details">
                <div className="detail-item">
                  <strong>Type:</strong> {report.errorType}
                </div>
                <div className="detail-item">
                  <strong>URL:</strong> {report.url}
                </div>
                {report.userAgent && (
                  <div className="detail-item">
                    <strong>User Agent:</strong> {report.userAgent}
                  </div>
                )}
              </div>

              {report.stackTrace && (
                <div className="stack-trace-section">
                  <button 
                    className="stack-trace-toggle"
                    onClick={() => setShowStackTrace(
                      showStackTrace === report.id ? null : report.id
                    )}
                  >
                    <Eye className="w-4 h-4" />
                    {showStackTrace === report.id ? 'Masquer' : 'Voir'} la stack trace
                  </button>
                  
                  {showStackTrace === report.id && (
                    <motion.pre 
                      className="stack-trace"
                      initial={{ opacity: 0, height: 0 }}
                      animate={{ opacity: 1, height: 'auto' }}
                      exit={{ opacity: 0, height: 0 }}
                    >
                      {report.stackTrace}
                    </motion.pre>
                  )}
                </div>
              )}
            </div>
          </motion.div>
        ))}
      </div>

      {filteredReports.length === 0 && (
        <div className="no-reports">
          <Bug className="w-12 h-12" />
          <h3>Aucun rapport d'erreur trouvé</h3>
          <p>Il n'y a actuellement aucun rapport d'erreur correspondant à vos critères.</p>
        </div>
      )}

      {/* Formulaire de signalement d'erreur */}
      {showReportForm && (
        <ErrorReportForm 
          onClose={() => setShowReportForm(false)}
          onSuccess={() => {
            setShowReportForm(false);
            fetchErrorReports();
            fetchStatistics();
          }}
        />
      )}
    </div>
  );
};

// Composant pour le formulaire de signalement d'erreur
const ErrorReportForm: React.FC<{ onClose: () => void; onSuccess: () => void }> = ({ onClose, onSuccess }) => {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    errorType: '',
    severity: 'MEDIUM' as 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL',
    url: window.location.href,
    stackTrace: ''
  });
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);

    try {
      await errorReportService.createErrorReport({
        ...formData,
        userAgent: navigator.userAgent,
        userId: 'web_user'
      });
      onSuccess();
    } catch (error) {
      console.error('Erreur lors de la création du rapport:', error);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="modal-overlay">
      <motion.div 
        className="modal-content"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
      >
        <div className="modal-header">
          <h2>Signaler une erreur</h2>
          <button onClick={onClose} className="close-btn">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="error-form">
          <div className="form-group">
            <label>Titre de l'erreur *</label>
            <input
              type="text"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              required
              placeholder="Décrivez brièvement l'erreur"
            />
          </div>

          <div className="form-group">
            <label>Description détaillée *</label>
            <textarea
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              required
              rows={4}
              placeholder="Décrivez en détail ce qui s'est passé"
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label>Type d'erreur *</label>
              <select
                value={formData.errorType}
                onChange={(e) => setFormData({ ...formData, errorType: e.target.value })}
                required
              >
                <option value="">Sélectionnez un type</option>
                <option value="JavaScript Error">Erreur JavaScript</option>
                <option value="Network Error">Erreur réseau</option>
                <option value="UI Error">Erreur d'interface</option>
                <option value="API Error">Erreur API</option>
                <option value="Performance Issue">Problème de performance</option>
                <option value="Other">Autre</option>
              </select>
            </div>

            <div className="form-group">
              <label>Sévérité *</label>
              <select
                value={formData.severity}
                onChange={(e) => setFormData({ ...formData, severity: e.target.value as any })}
                required
              >
                <option value="LOW">Faible</option>
                <option value="MEDIUM">Moyenne</option>
                <option value="HIGH">Élevée</option>
                <option value="CRITICAL">Critique</option>
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>URL où l'erreur s'est produite</label>
            <input
              type="url"
              value={formData.url}
              onChange={(e) => setFormData({ ...formData, url: e.target.value })}
              placeholder="https://example.com/page"
            />
          </div>

          <div className="form-group">
            <label>Stack trace (optionnel)</label>
            <textarea
              value={formData.stackTrace}
              onChange={(e) => setFormData({ ...formData, stackTrace: e.target.value })}
              rows={6}
              placeholder="Collez ici la stack trace si disponible"
            />
          </div>

          <div className="form-actions">
            <button type="button" onClick={onClose} className="btn-secondary">
              Annuler
            </button>
            <button type="submit" disabled={submitting} className="btn-primary">
              {submitting ? 'Envoi en cours...' : 'Signaler l\'erreur'}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default ErrorReportingDashboard;
