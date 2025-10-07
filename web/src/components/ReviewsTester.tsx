import React, { useState, useEffect } from 'react';
import { 
  Star, 
  MessageSquare, 
  ThumbsUp, 
  ThumbsDown, 
  CheckCircle, 
  Clock, 
  AlertCircle,
  User,
  Calendar,
  Filter,
  Search
} from 'lucide-react';
import { feedbackService } from '../services/api';
import { useNotificationHelpers } from './NotificationProvider';

interface Review {
  id: number;
  restaurantId: number;
  customerName: string;
  customerEmail: string;
  rating: number;
  comment: string;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  createdAt: string;
}

interface Report {
  id: number;
  restaurantId: number;
  reporterName: string;
  reporterEmail: string;
  reason: string;
  description: string;
  status: 'PENDING' | 'INVESTIGATING' | 'RESOLVED';
  createdAt: string;
}

const ReviewsTester: React.FC = () => {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [reports, setReports] = useState<Report[]>([]);
  const [loading, setLoading] = useState(true);
  const [filterStatus, setFilterStatus] = useState<string>('');
  const [searchTerm, setSearchTerm] = useState('');
  const { success, error: notifyError, info } = useNotificationHelpers();

  useEffect(() => {
    fetchReviewsAndReports();
  }, []);

  const fetchReviewsAndReports = async () => {
    try {
      setLoading(true);
      
      // Récupérer les avis pour le restaurant 1
      const reviewsResponse = await feedbackService.getAllReviewsByRestaurant(1);
      setReviews(reviewsResponse.data || []);
      
      // Récupérer les rapports actifs
      const reportsResponse = await feedbackService.getActiveReports();
      setReports(reportsResponse.data || []);
      
    } catch (err: any) {
      console.error('Erreur lors du chargement:', err);
      notifyError('Erreur de chargement', 'Impossible de charger les avis et rapports');
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateReviewStatus = async (reviewId: number, status: 'APPROVED' | 'REJECTED') => {
    try {
      await feedbackService.updateReviewStatus(reviewId, { status });
      success('Statut mis à jour', `Avis ${status === 'APPROVED' ? 'approuvé' : 'rejeté'}`);
      fetchReviewsAndReports();
    } catch (err: any) {
      notifyError('Erreur', 'Impossible de mettre à jour le statut');
    }
  };

  const handleUpdateReportStatus = async (reportId: number, status: 'INVESTIGATING' | 'RESOLVED') => {
    try {
      await feedbackService.updateReportStatus(reportId, { status });
      success('Statut mis à jour', `Rapport ${status === 'RESOLVED' ? 'résolu' : 'en investigation'}`);
      fetchReviewsAndReports();
    } catch (err: any) {
      notifyError('Erreur', 'Impossible de mettre à jour le statut');
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'APPROVED':
      case 'RESOLVED':
        return <CheckCircle className="w-4 h-4 text-green-500" />;
      case 'PENDING':
        return <Clock className="w-4 h-4 text-yellow-500" />;
      case 'INVESTIGATING':
        return <AlertCircle className="w-4 h-4 text-blue-500" />;
      case 'REJECTED':
        return <AlertCircle className="w-4 h-4 text-red-500" />;
      default:
        return <Clock className="w-4 h-4 text-gray-500" />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'APPROVED':
      case 'RESOLVED':
        return 'bg-green-50 text-green-700 border-green-200';
      case 'PENDING':
        return 'bg-yellow-50 text-yellow-700 border-yellow-200';
      case 'INVESTIGATING':
        return 'bg-blue-50 text-blue-700 border-blue-200';
      case 'REJECTED':
        return 'bg-red-50 text-red-700 border-red-200';
      default:
        return 'bg-gray-50 text-gray-700 border-gray-200';
    }
  };

  const renderStars = (rating: number) => {
    return Array.from({ length: 5 }, (_, i) => (
      <Star
        key={i}
        className={`w-4 h-4 ${i < rating ? 'text-yellow-400 fill-current' : 'text-gray-300'}`}
      />
    ));
  };

  const filteredReviews = reviews.filter(review => {
    const matchesStatus = !filterStatus || review.status === filterStatus;
    const matchesSearch = !searchTerm || 
      review.customerName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      review.comment.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesStatus && matchesSearch;
  });

  if (loading) {
    return (
      <div className="modern-card">
        <div className="modern-card-content">
          <div className="flex items-center justify-center py-8">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500"></div>
            <span className="ml-3 text-gray-600">Chargement des avis...</span>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-card">
      <div className="modern-card-header">
        <div className="flex items-center gap-3">
          <Star className="w-6 h-6 text-primary-green" />
          <h2 className="modern-card-title">Avis et Reviews</h2>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-sm text-gray-600">
            {reviews.length} avis • {reports.length} rapports
          </span>
        </div>
      </div>
      
      <div className="modern-card-content">
        {/* Filtres */}
        <div className="mb-6 flex gap-4">
          <div className="flex-1">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder="Rechercher dans les avis..."
                className="form-input pl-10"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
          </div>
          <div className="w-48">
            <select
              className="form-select"
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
            >
              <option value="">Tous les statuts</option>
              <option value="PENDING">En attente</option>
              <option value="APPROVED">Approuvés</option>
              <option value="REJECTED">Rejetés</option>
            </select>
          </div>
        </div>

        {/* Liste des avis */}
        <div className="space-y-4">
          <h3 className="text-lg font-semibold mb-3">Avis Clients ({filteredReviews.length})</h3>
          
          {filteredReviews.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <MessageSquare className="w-12 h-12 mx-auto mb-3 text-gray-300" />
              <p>Aucun avis trouvé</p>
            </div>
          ) : (
            filteredReviews.map((review) => (
              <div key={review.id} className="border border-gray-200 rounded-lg p-4">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                      <User className="w-5 h-5 text-green-600" />
                    </div>
                    <div>
                      <h4 className="font-medium text-gray-900">{review.customerName}</h4>
                      <div className="flex items-center gap-2">
                        <div className="flex">
                          {renderStars(review.rating)}
                        </div>
                        <span className="text-sm text-gray-500">
                          {new Date(review.createdAt).toLocaleDateString('fr-FR')}
                        </span>
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex items-center gap-2">
                    <span className={`px-2 py-1 rounded-full text-xs border ${getStatusColor(review.status)}`}>
                      {getStatusIcon(review.status)}
                      <span className="ml-1">
                        {review.status === 'PENDING' ? 'En attente' :
                         review.status === 'APPROVED' ? 'Approuvé' : 'Rejeté'}
                      </span>
                    </span>
                  </div>
                </div>
                
                <p className="text-gray-700 mb-3">{review.comment}</p>
                
                {review.status === 'PENDING' && (
                  <div className="flex gap-2">
                    <button
                      onClick={() => handleUpdateReviewStatus(review.id, 'APPROVED')}
                      className="btn btn-sm btn-primary"
                    >
                      <ThumbsUp className="w-4 h-4" />
                      Approuver
                    </button>
                    <button
                      onClick={() => handleUpdateReviewStatus(review.id, 'REJECTED')}
                      className="btn btn-sm btn-danger"
                    >
                      <ThumbsDown className="w-4 h-4" />
                      Rejeter
                    </button>
                  </div>
                )}
              </div>
            ))
          )}
        </div>

        {/* Liste des rapports */}
        {reports.length > 0 && (
          <div className="mt-8">
            <h3 className="text-lg font-semibold mb-3">Rapports/Signalisations ({reports.length})</h3>
            <div className="space-y-3">
              {reports.map((report) => (
                <div key={report.id} className="border border-gray-200 rounded-lg p-4">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h4 className="font-medium text-gray-900">{report.reason}</h4>
                      <p className="text-sm text-gray-600">Par {report.reporterName}</p>
                    </div>
                    <span className={`px-2 py-1 rounded-full text-xs border ${getStatusColor(report.status)}`}>
                      {getStatusIcon(report.status)}
                      <span className="ml-1">
                        {report.status === 'PENDING' ? 'En attente' :
                         report.status === 'INVESTIGATING' ? 'En investigation' : 'Résolu'}
                      </span>
                    </span>
                  </div>
                  <p className="text-gray-700 text-sm mb-3">{report.description}</p>
                  
                  {report.status !== 'RESOLVED' && (
                    <div className="flex gap-2">
                      {report.status === 'PENDING' && (
                        <button
                          onClick={() => handleUpdateReportStatus(report.id, 'INVESTIGATING')}
                          className="btn btn-sm btn-warning"
                        >
                          <AlertCircle className="w-4 h-4" />
                          Investiguer
                        </button>
                      )}
                      <button
                        onClick={() => handleUpdateReportStatus(report.id, 'RESOLVED')}
                        className="btn btn-sm btn-primary"
                      >
                        <CheckCircle className="w-4 h-4" />
                        Résoudre
                      </button>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ReviewsTester;
