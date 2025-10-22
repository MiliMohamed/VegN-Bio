import React from 'react';
import { motion } from 'framer-motion';
import { 
  Star, 
  MessageCircle, 
  ThumbsUp,
  ThumbsDown,
  CheckCircle,
  XCircle,
  Clock,
  User,
  Calendar,
  Plus,
  Edit,
  Trash2
} from 'lucide-react';
import { feedbackService } from '../services/api';
import { useAuth } from '../contexts/AuthContext';
import ReviewForm from './ReviewForm';
import '../styles/review-form.css';

interface Review {
  id: number;
  rating: number;
  comment: string;
  createdAt: string;
  user: {
    fullName: string;
    email: string;
  };
}

const ModernReviews: React.FC = () => {
  const { user } = useAuth();
  const [reviews, setReviews] = React.useState<Review[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [filter, setFilter] = React.useState<'all' | 'pending' | 'approved' | 'rejected'>('all');
  const [showReviewForm, setShowReviewForm] = React.useState(false);
  const [editingReview, setEditingReview] = React.useState<Review | null>(null);

  const handleReviewSuccess = () => {
    fetchReviews();
    setShowReviewForm(false);
    setEditingReview(null);
  };

  const handleEditReview = (review: Review) => {
    setEditingReview(review);
    setShowReviewForm(true);
  };

  const handleDeleteReview = async (reviewId: number) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer cet avis ?')) {
      try {
        await feedbackService.deleteReview(reviewId);
        setReviews(reviews.filter(review => review.id !== reviewId));
      } catch (error) {
        console.error('Erreur lors de la suppression:', error);
      }
    }
  };

  const canEditReview = (review: Review) => {
    return user?.email === review.user?.email || user?.role === 'ADMIN';
  };

  React.useEffect(() => {
    fetchReviews();
  }, []);

  const fetchReviews = async () => {
    try {
      const response = await feedbackService.getReviews();
      setReviews(response.data);
    } catch (error) {
      console.error('Erreur lors du chargement des avis:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const renderStars = (rating: number) => {
    return Array.from({ length: 5 }, (_, index) => (
      <Star
        key={index}
        className={`w-4 h-4 ${
          index < rating ? 'text-yellow-400 fill-current' : 'text-gray-300'
        }`}
      />
    ));
  };

  const getRatingColor = (rating: number) => {
    if (rating >= 4) return 'success';
    if (rating >= 3) return 'warning';
    return 'danger';
  };

  const filteredReviews = reviews.filter(review => {
    if (filter === 'all') return true;
    // Pour l'instant, on considère tous les avis comme approuvés
    // Dans une vraie application, il faudrait vérifier le statut
    return filter === 'approved';
  });

  if (loading) {
    return (
      <div className="modern-reviews">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des avis...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-reviews">
      <div className="reviews-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="header-content">
            <div className="header-text">
              <h1 className="page-title">Avis Clients</h1>
              <p className="page-subtitle">
                Gérez les retours et évaluations de vos clients
              </p>
            </div>
            <button 
              className="btn btn-primary"
              onClick={() => setShowReviewForm(true)}
            >
              <Plus className="w-4 h-4" />
              Écrire un avis
            </button>
          </div>
        </motion.div>
      </div>

      <div className="reviews-filters">
        <motion.div
          className="filter-tabs"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <button
            className={`filter-tab ${filter === 'all' ? 'active' : ''}`}
            onClick={() => setFilter('all')}
          >
            Tous ({reviews.length})
          </button>
          <button
            className={`filter-tab ${filter === 'pending' ? 'active' : ''}`}
            onClick={() => setFilter('pending')}
          >
            <Clock className="w-4 h-4" />
            En attente (0)
          </button>
          <button
            className={`filter-tab ${filter === 'approved' ? 'active' : ''}`}
            onClick={() => setFilter('approved')}
          >
            <CheckCircle className="w-4 h-4" />
            Approuvés ({reviews.length})
          </button>
          <button
            className={`filter-tab ${filter === 'rejected' ? 'active' : ''}`}
            onClick={() => setFilter('rejected')}
          >
            <XCircle className="w-4 h-4" />
            Rejetés (0)
          </button>
        </motion.div>
      </div>

      <div className="reviews-stats">
        <motion.div
          className="stats-grid"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
        >
          <div className="stat-card">
            <div className="stat-icon">
              <Star className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">
                {reviews.length > 0 
                  ? (reviews.reduce((sum, review) => sum + review.rating, 0) / reviews.length).toFixed(1)
                  : '0.0'
                }
              </div>
              <div className="stat-label">Note moyenne</div>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon">
              <MessageCircle className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">{reviews.length}</div>
              <div className="stat-label">Total avis</div>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon">
              <ThumbsUp className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">
                {reviews.filter(r => r.rating >= 4).length}
              </div>
              <div className="stat-label">Avis positifs</div>
            </div>
          </div>
          
          <div className="stat-card">
            <div className="stat-icon">
              <ThumbsDown className="w-6 h-6" />
            </div>
            <div className="stat-content">
              <div className="stat-value">
                {reviews.filter(r => r.rating <= 2).length}
              </div>
              <div className="stat-label">Avis négatifs</div>
            </div>
          </div>
        </motion.div>
      </div>

      <div className="reviews-list">
        {filteredReviews.map((review, index) => (
          <motion.div
            key={review.id}
            className="review-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
          >
            <div className="review-header">
              <div className="review-user">
                <div className="user-avatar">
                  <User className="w-6 h-6" />
                </div>
                <div className="user-info">
                  <div className="user-name">{review.user.fullName}</div>
                  <div className="user-email">{review.user.email}</div>
                </div>
              </div>
              <div className="review-date">
                <Calendar className="w-4 h-4" />
                <span>{formatDate(review.createdAt)}</span>
              </div>
            </div>

            <div className="review-rating">
              <div className="stars">
                {renderStars(review.rating)}
              </div>
              <span className={`rating-badge rating-${getRatingColor(review.rating)}`}>
                {review.rating}/5
              </span>
            </div>

            <div className="review-comment">
              <p>{review.comment}</p>
            </div>

            <div className="review-actions">
              {canEditReview(review) && (
                <>
                  <button 
                    className="btn btn-secondary btn-sm"
                    onClick={() => handleEditReview(review)}
                  >
                    <Edit className="w-4 h-4" />
                    Modifier
                  </button>
                  <button 
                    className="btn btn-danger btn-sm"
                    onClick={() => handleDeleteReview(review.id)}
                  >
                    <Trash2 className="w-4 h-4" />
                    Supprimer
                  </button>
                </>
              )}
              {user?.role === 'ADMIN' && (
                <>
                  <button className="btn btn-success btn-sm">
                    <CheckCircle className="w-4 h-4" />
                    Approuver
                  </button>
                  <button className="btn btn-danger btn-sm">
                    <XCircle className="w-4 h-4" />
                    Rejeter
                  </button>
                </>
              )}
              <button className="btn btn-secondary btn-sm">
                <MessageCircle className="w-4 h-4" />
                Répondre
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {filteredReviews.length === 0 && (
        <motion.div
          className="empty-state"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <MessageCircle className="w-16 h-16" />
          <h3>Aucun avis</h3>
          <p>Aucun avis client pour le moment</p>
        </motion.div>
      )}

      {/* Review Form Modal */}
      <ReviewForm
        isOpen={showReviewForm}
        onClose={() => {
          setShowReviewForm(false);
          setEditingReview(null);
        }}
        onSuccess={handleReviewSuccess}
        restaurantId={1}
      />
    </div>
  );
};

export default ModernReviews;
