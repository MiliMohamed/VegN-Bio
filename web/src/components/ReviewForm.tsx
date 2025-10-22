import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Star, 
  X, 
  Send, 
  MessageCircle,
  User,
  Calendar,
  ThumbsUp,
  ThumbsDown
} from 'lucide-react';
import { feedbackService } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

interface ReviewFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  restaurantId?: number;
  menuItemId?: number;
}

const ReviewForm: React.FC<ReviewFormProps> = ({ 
  isOpen, 
  onClose, 
  onSuccess, 
  restaurantId,
  menuItemId 
}) => {
  const { user } = useAuth();
  const [formData, setFormData] = useState({
    rating: 0,
    comment: '',
    restaurantId: restaurantId || 1,
    menuItemId: menuItemId || null
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [hoveredStar, setHoveredStar] = useState(0);

  const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError('');
  };

  const handleStarClick = (rating: number) => {
    setFormData({
      ...formData,
      rating
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (formData.rating === 0) {
      setError('Veuillez sélectionner une note');
      return;
    }

    if (formData.comment.trim().length < 10) {
      setError('Le commentaire doit contenir au moins 10 caractères');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const reviewData = {
        ...formData,
        userId: user?.id,
        userName: user?.name || 'Utilisateur anonyme',
        userEmail: user?.email || 'anonyme@example.com'
      };

      await feedbackService.createReview(reviewData);
      onSuccess();
      onClose();
      setFormData({
        rating: 0,
        comment: '',
        restaurantId: restaurantId || 1,
        menuItemId: menuItemId || null
      });
    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur lors de la création de l\'avis');
    } finally {
      setLoading(false);
    }
  };

  const getRatingText = (rating: number) => {
    const texts = {
      1: 'Très décevant',
      2: 'Décevant',
      3: 'Correct',
      4: 'Bien',
      5: 'Excellent'
    };
    return texts[rating as keyof typeof texts] || '';
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <motion.div 
        className="modal-content review-form-modal"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.3 }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="modal-header">
          <h2 className="modal-title">
            <MessageCircle className="w-6 h-6" />
            Écrire un avis
          </h2>
          <button className="modal-close" onClick={onClose}>
            <X className="w-6 h-6" />
          </button>
        </div>

        {error && (
          <div className="alert alert-error">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="modal-form">
          <div className="form-group">
            <label className="form-label">
              <Star className="w-4 h-4" />
              Votre note *
            </label>
            <div className="rating-container">
              <div className="stars-input">
                {[1, 2, 3, 4, 5].map((star) => (
                  <button
                    key={star}
                    type="button"
                    className={`star-button ${
                      star <= (hoveredStar || formData.rating) ? 'active' : ''
                    }`}
                    onClick={() => handleStarClick(star)}
                    onMouseEnter={() => setHoveredStar(star)}
                    onMouseLeave={() => setHoveredStar(0)}
                  >
                    <Star className="w-8 h-8" />
                  </button>
                ))}
              </div>
              {formData.rating > 0 && (
                <div className="rating-text">
                  {getRatingText(formData.rating)}
                </div>
              )}
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="comment" className="form-label">
              <MessageCircle className="w-4 h-4" />
              Votre commentaire *
            </label>
            <textarea
              id="comment"
              name="comment"
              value={formData.comment}
              onChange={handleChange}
              className="form-textarea"
              placeholder="Partagez votre expérience avec nous..."
              rows={4}
              required
              maxLength={500}
            />
            <small className="form-help">
              {formData.comment.length}/500 caractères (minimum 10)
            </small>
          </div>

          <div className="form-group">
            <label className="form-label">
              <User className="w-4 h-4" />
              Publié par
            </label>
            <div className="user-info-display">
              <div className="user-avatar">
                <User className="w-6 h-6" />
              </div>
              <div className="user-details">
                <div className="user-name">{user?.name || 'Utilisateur anonyme'}</div>
                <div className="user-email">{user?.email || 'anonyme@example.com'}</div>
              </div>
            </div>
          </div>

          <div className="modal-actions">
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              Annuler
            </button>
            <button 
              type="submit" 
              className={`btn btn-primary ${loading ? 'loading' : ''}`}
              disabled={loading || formData.rating === 0 || formData.comment.trim().length < 10}
            >
              {loading ? (
                <div className="loading-spinner"></div>
              ) : (
                <>
                  <Send className="w-4 h-4" />
                  Publier l'avis
                </>
              )}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default ReviewForm;
