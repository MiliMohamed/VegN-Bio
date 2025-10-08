import React, { useState, useEffect } from 'react';
import { 
  Star,
  Filter,
  Search,
  TrendingUp,
  TrendingDown,
  Eye,
  CheckCircle,
  XCircle,
  Clock,
  MessageSquare,
  ThumbsUp,
  ThumbsDown,
  Flag,
  MoreVertical,
  Download,
  RefreshCw,
  Calendar,
  User,
  MapPin,
  Award,
  AlertTriangle,
  BarChart3,
  PieChart
} from 'lucide-react';
import { feedbackService } from '../services/api';

interface Review {
  id: number;
  customerName: string;
  customerEmail: string;
  rating: number;
  comment: string;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  createdAt: string;
  restaurantId: number;
  restaurantName?: string;
  helpfulCount?: number;
  reportedCount?: number;
}

interface ReviewStats {
  totalReviews: number;
  averageRating: number;
  pendingReviews: number;
  approvedReviews: number;
  rejectedReviews: number;
  monthlyGrowth: number;
  ratingDistribution: { [key: number]: number };
}

const ProfessionalReviews: React.FC = () => {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [stats, setStats] = useState<ReviewStats>({
    totalReviews: 0,
    averageRating: 0,
    pendingReviews: 0,
    approvedReviews: 0,
    rejectedReviews: 0,
    monthlyGrowth: 0,
    ratingDistribution: {}
  });
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [filterRating, setFilterRating] = useState('');
  const [sortBy, setSortBy] = useState('newest');
  const [selectedReviews, setSelectedReviews] = useState<number[]>([]);
  const [showStats, setShowStats] = useState(true);

  useEffect(() => {
    loadReviews();
  }, []);

  const loadReviews = async () => {
    try {
      setLoading(true);
      const response = await feedbackService.getReviews();
      const reviewsData = response.data.map((review: any) => ({
        ...review,
        restaurantName: `Restaurant ${review.restaurantId}` // Placeholder
      }));
      setReviews(reviewsData);
      
      // Calculate stats
      const totalReviews = reviewsData.length;
      const averageRating = reviewsData.reduce((acc: number, review: Review) => acc + review.rating, 0) / totalReviews;
      const pendingReviews = reviewsData.filter((r: Review) => r.status === 'PENDING').length;
      const approvedReviews = reviewsData.filter((r: Review) => r.status === 'APPROVED').length;
      const rejectedReviews = reviewsData.filter((r: Review) => r.status === 'REJECTED').length;
      
      // Rating distribution
      const ratingDistribution = reviewsData.reduce((acc: any, review: Review) => {
        acc[review.rating] = (acc[review.rating] || 0) + 1;
        return acc;
      }, {});

      setStats({
        totalReviews,
        averageRating: Number(averageRating.toFixed(1)),
        pendingReviews,
        approvedReviews,
        rejectedReviews,
        monthlyGrowth: 12.5, // Placeholder
        ratingDistribution
      });
    } catch (error) {
      console.error('Erreur lors du chargement des avis:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleApproveReview = async (reviewId: number) => {
    try {
      await feedbackService.updateReviewStatus(reviewId, { status: 'APPROVED' });
      setReviews(reviews.map(review => 
        review.id === reviewId ? { ...review, status: 'APPROVED' } : review
      ));
    } catch (error) {
      console.error('Erreur lors de l\'approbation:', error);
    }
  };

  const handleRejectReview = async (reviewId: number) => {
    try {
      await feedbackService.updateReviewStatus(reviewId, { status: 'REJECTED' });
      setReviews(reviews.map(review => 
        review.id === reviewId ? { ...review, status: 'REJECTED' } : review
      ));
    } catch (error) {
      console.error('Erreur lors du rejet:', error);
    }
  };

  const handleBulkAction = async (action: 'approve' | 'reject') => {
    try {
      for (const reviewId of selectedReviews) {
        await feedbackService.updateReviewStatus(reviewId, { status: action.toUpperCase() as any });
      }
      setReviews(reviews.map(review => 
        selectedReviews.includes(review.id) 
          ? { ...review, status: action.toUpperCase() as any }
          : review
      ));
      setSelectedReviews([]);
    } catch (error) {
      console.error('Erreur lors de l\'action en lot:', error);
    }
  };

  const filteredReviews = reviews.filter(review => {
    const matchesSearch = review.customerName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         review.comment.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         review.restaurantName?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = !filterStatus || review.status === filterStatus;
    const matchesRating = !filterRating || review.rating.toString() === filterRating;
    return matchesSearch && matchesStatus && matchesRating;
  });

  const sortedReviews = [...filteredReviews].sort((a, b) => {
    switch (sortBy) {
      case 'newest':
        return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
      case 'oldest':
        return new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime();
      case 'rating-high':
        return b.rating - a.rating;
      case 'rating-low':
        return a.rating - b.rating;
      default:
        return 0;
    }
  });

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'APPROVED': return '#22c55e';
      case 'REJECTED': return '#ef4444';
      case 'PENDING': return '#f59e0b';
      default: return '#64748b';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'APPROVED': return CheckCircle;
      case 'REJECTED': return XCircle;
      case 'PENDING': return Clock;
      default: return Clock;
    }
  };

  const renderStars = (rating: number) => {
    return Array.from({ length: 5 }, (_, index) => (
      <Star
        key={index}
        className={`star ${index < rating ? 'filled' : 'empty'}`}
        size={16}
      />
    ));
  };

  if (loading) {
    return (
      <div className="professional-reviews">
        <div className="professional-loading">
          <div className="professional-loading-spinner"></div>
          <p className="professional-loading-text">Chargement des avis...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="professional-reviews">
      {/* Header */}
      <div className="reviews-header">
        <div className="header-content">
          <div className="header-info">
            <h1 className="page-title">
              <Star className="title-icon" />
              Avis & Retours Clients
            </h1>
            <p className="page-subtitle">
              Gérez et analysez les retours de vos clients
            </p>
          </div>
          <div className="header-actions">
            <button className="btn btn-outline-primary">
              <Download className="btn-icon" />
              Exporter
            </button>
            <button className="btn btn-primary" onClick={loadReviews}>
              <RefreshCw className="btn-icon" />
              Actualiser
            </button>
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      {showStats && (
        <div className="reviews-stats">
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-icon">
                <Star />
              </div>
              <div className="stat-content">
                <div className="stat-value">{stats.totalReviews}</div>
                <div className="stat-label">Total Avis</div>
                <div className="stat-change positive">
                  <TrendingUp className="change-icon" />
                  +{stats.monthlyGrowth}%
                </div>
              </div>
            </div>
            <div className="stat-card">
              <div className="stat-icon">
                <Award />
              </div>
              <div className="stat-content">
                <div className="stat-value">{stats.averageRating}/5</div>
                <div className="stat-label">Note Moyenne</div>
                <div className="stat-change positive">
                  <TrendingUp className="change-icon" />
                  +0.2
                </div>
              </div>
            </div>
            <div className="stat-card">
              <div className="stat-icon">
                <Clock />
              </div>
              <div className="stat-content">
                <div className="stat-value">{stats.pendingReviews}</div>
                <div className="stat-label">En Attente</div>
                <div className="stat-change neutral">
                  <AlertTriangle className="change-icon" />
                  À traiter
                </div>
              </div>
            </div>
            <div className="stat-card">
              <div className="stat-icon">
                <CheckCircle />
              </div>
              <div className="stat-content">
                <div className="stat-value">{stats.approvedReviews}</div>
                <div className="stat-label">Approuvés</div>
                <div className="stat-change positive">
                  <TrendingUp className="change-icon" />
                  +{Math.floor(stats.approvedReviews * 0.1)}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Filters and Search */}
      <div className="reviews-filters">
        <div className="search-section">
          <div className="search-input-group">
            <Search className="search-icon" />
            <input
              type="text"
              placeholder="Rechercher par nom, commentaire ou restaurant..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
            />
          </div>
        </div>
        <div className="filter-section">
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="filter-select"
          >
            <option value="">Tous les statuts</option>
            <option value="PENDING">En attente</option>
            <option value="APPROVED">Approuvés</option>
            <option value="REJECTED">Rejetés</option>
          </select>
          <select
            value={filterRating}
            onChange={(e) => setFilterRating(e.target.value)}
            className="filter-select"
          >
            <option value="">Toutes les notes</option>
            <option value="5">5 étoiles</option>
            <option value="4">4 étoiles</option>
            <option value="3">3 étoiles</option>
            <option value="2">2 étoiles</option>
            <option value="1">1 étoile</option>
          </select>
          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value)}
            className="filter-select"
          >
            <option value="newest">Plus récents</option>
            <option value="oldest">Plus anciens</option>
            <option value="rating-high">Note élevée</option>
            <option value="rating-low">Note faible</option>
          </select>
        </div>
      </div>

      {/* Bulk Actions */}
      {selectedReviews.length > 0 && (
        <div className="bulk-actions">
          <div className="bulk-info">
            <span>{selectedReviews.length} avis sélectionnés</span>
          </div>
          <div className="bulk-buttons">
            <button 
              className="btn btn-success btn-sm"
              onClick={() => handleBulkAction('approve')}
            >
              <CheckCircle className="btn-icon" />
              Approuver
            </button>
            <button 
              className="btn btn-danger btn-sm"
              onClick={() => handleBulkAction('reject')}
            >
              <XCircle className="btn-icon" />
              Rejeter
            </button>
          </div>
        </div>
      )}

      {/* Reviews List */}
      <div className="reviews-list">
        {sortedReviews.length === 0 ? (
          <div className="professional-empty">
            <Star className="professional-empty-icon" />
            <h3 className="professional-empty-title">Aucun avis trouvé</h3>
            <p className="professional-empty-message">
              {searchTerm || filterStatus || filterRating 
                ? 'Aucun avis ne correspond à vos critères de recherche.'
                : 'Aucun avis n\'a encore été soumis.'
              }
            </p>
          </div>
        ) : (
          <div className="reviews-grid">
            {sortedReviews.map((review) => {
              const StatusIcon = getStatusIcon(review.status);
              const isSelected = selectedReviews.includes(review.id);
              
              return (
                <div 
                  key={review.id} 
                  className={`review-card ${isSelected ? 'selected' : ''}`}
                >
                  <div className="review-header">
                    <div className="review-meta">
                      <div className="review-customer">
                        <User className="customer-icon" />
                        <div className="customer-info">
                          <div className="customer-name">{review.customerName}</div>
                          <div className="customer-email">{review.customerEmail}</div>
                        </div>
                      </div>
                      <div className="review-restaurant">
                        <MapPin className="restaurant-icon" />
                        <span>{review.restaurantName}</span>
                      </div>
                    </div>
                    <div className="review-actions">
                      <input
                        type="checkbox"
                        checked={isSelected}
                        onChange={(e) => {
                          if (e.target.checked) {
                            setSelectedReviews([...selectedReviews, review.id]);
                          } else {
                            setSelectedReviews(selectedReviews.filter(id => id !== review.id));
                          }
                        }}
                        className="review-checkbox"
                      />
                      <div className="action-menu">
                        <button className="action-menu-btn">
                          <MoreVertical />
                        </button>
                      </div>
                    </div>
                  </div>

                  <div className="review-content">
                    <div className="review-rating">
                      <div className="stars">
                        {renderStars(review.rating)}
                      </div>
                      <span className="rating-number">{review.rating}/5</span>
                    </div>
                    <div className="review-comment">
                      {review.comment}
                    </div>
                    <div className="review-date">
                      <Calendar className="date-icon" />
                      <span>{new Date(review.createdAt).toLocaleDateString('fr-FR')}</span>
                    </div>
                  </div>

                  <div className="review-footer">
                    <div className="review-status">
                      <StatusIcon 
                        className="status-icon" 
                        style={{ color: getStatusColor(review.status) }}
                      />
                      <span 
                        className="status-text"
                        style={{ color: getStatusColor(review.status) }}
                      >
                        {review.status === 'PENDING' && 'En attente'}
                        {review.status === 'APPROVED' && 'Approuvé'}
                        {review.status === 'REJECTED' && 'Rejeté'}
                      </span>
                    </div>
                    <div className="review-buttons">
                      {review.status === 'PENDING' && (
                        <>
                          <button 
                            className="btn btn-success btn-sm"
                            onClick={() => handleApproveReview(review.id)}
                          >
                            <CheckCircle className="btn-icon" />
                            Approuver
                          </button>
                          <button 
                            className="btn btn-danger btn-sm"
                            onClick={() => handleRejectReview(review.id)}
                          >
                            <XCircle className="btn-icon" />
                            Rejeter
                          </button>
                        </>
                      )}
                      <button className="btn btn-outline-primary btn-sm">
                        <Eye className="btn-icon" />
                        Voir
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
  );
};

export default ProfessionalReviews;
