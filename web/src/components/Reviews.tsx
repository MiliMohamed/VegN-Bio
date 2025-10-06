import React, { useState, useEffect } from 'react';
import { feedbackService } from '../services/api';
import { useRestaurants } from '../hooks/useRestaurants';

interface Review {
  id: number;
  restaurantId: number;
  customerName: string;
  customerEmail: string;
  rating: number;
  comment: string;
  status: string;
  createdAt: string;
}

interface Report {
  id: number;
  restaurantId: number;
  reporterName: string;
  reporterEmail: string;
  reportType: string;
  description: string;
  status: string;
  createdAt: string;
  resolvedAt: string | null;
}

const Reviews: React.FC = () => {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [reports, setReports] = useState<Report[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeTab, setActiveTab] = useState<'reviews' | 'reports'>('reviews');
  const [deletingReview, setDeletingReview] = useState<number | null>(null);

  // Hook pour récupérer les restaurants
  const { getRestaurantName } = useRestaurants();

  // Vérifier si l'utilisateur est admin
  const userRole = localStorage.getItem('userRole');
  const isAdmin = userRole === 'ADMIN';
  
  // Fonction pour vérifier si l'utilisateur peut modifier/supprimer un avis
  const canModifyReview = (review: Review) => {
    // Les admins peuvent tout modifier
    if (isAdmin) return true;
    
    // Les utilisateurs peuvent modifier leurs propres avis
    const currentUserEmail = localStorage.getItem('userEmail');
    return review.customerEmail === currentUserEmail;
  };

  // Fonction pour supprimer un avis
  const handleDeleteReview = async (reviewId: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer cet avis ?')) {
      return;
    }

    try {
      setDeletingReview(reviewId);
      // Note: Il faudrait implémenter l'endpoint DELETE dans l'API
      // await feedbackService.deleteReview(reviewId);
      
      // Pour l'instant, on simule la suppression en retirant l'avis de la liste
      setReviews(reviews.filter(review => review.id !== reviewId));
      
      alert('Avis supprimé avec succès');
    } catch (err) {
      console.error('Erreur lors de la suppression:', err);
      alert('Erreur lors de la suppression de l\'avis');
    } finally {
      setDeletingReview(null);
    }
  };

  // Fonction pour approuver/rejeter un avis (Admin seulement)
  const handleReviewStatusChange = async (reviewId: number, newStatus: 'APPROVED' | 'REJECTED') => {
    try {
      await feedbackService.updateReviewStatus(reviewId, { status: newStatus });
      
      // Mettre à jour l'avis dans la liste
      setReviews(reviews.map(review => 
        review.id === reviewId ? { ...review, status: newStatus } : review
      ));
      
      alert(`Avis ${newStatus === 'APPROVED' ? 'approuvé' : 'rejeté'} avec succès`);
    } catch (err) {
      console.error('Erreur lors de la mise à jour du statut:', err);
      alert('Erreur lors de la mise à jour du statut de l\'avis');
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      
      // Charger les avis (disponible pour tous)
      const reviewsResponse = await feedbackService.getReviews();
      setReviews(reviewsResponse.data);
      
      // Charger les rapports seulement si l'utilisateur est admin
      if (isAdmin) {
        try {
          const reportsResponse = await feedbackService.getReports();
          setReports(reportsResponse.data);
        } catch (reportsErr) {
          console.warn('Impossible de charger les rapports:', reportsErr);
          setReports([]); // Initialiser avec un tableau vide
        }
      } else {
        setReports([]); // Pas de rapports pour les non-admin
      }
    } catch (err: any) {
      setError('Erreur lors du chargement des données');
      console.error('Error fetching data:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="reviews">
      <div className="page-header">
        <h1>{isAdmin ? 'Avis et Signalements' : 'Avis'}</h1>
      </div>
      
      <div className="tabs">
        <button 
          className={`tab ${activeTab === 'reviews' ? 'active' : ''}`}
          onClick={() => setActiveTab('reviews')}
        >
          Avis ({reviews.length})
        </button>
        {isAdmin && (
          <button 
            className={`tab ${activeTab === 'reports' ? 'active' : ''}`}
            onClick={() => setActiveTab('reports')}
          >
            Signalements ({reports.length})
          </button>
        )}
      </div>

      {activeTab === 'reviews' && (
        <div className="reviews-section">
          <div className="reviews-grid">
            {reviews.length === 0 ? (
              <div className="empty-state">
                <p>Aucun avis trouvé</p>
              </div>
            ) : (
              reviews.map((review) => (
                <div key={review.id} className={`review-card ${canModifyReview(review) ? 'own-review' : ''}`}>
                  <div className="review-header">
                    <h4>{getRestaurantName(review.restaurantId)}</h4>
                    <div className="rating">
                      {'★'.repeat(review.rating)}{'☆'.repeat(5 - review.rating)}
                    </div>
                  </div>
                  <p className="review-comment">{review.comment}</p>
                  <div className="review-footer">
                    <span className="reviewer">Par {review.customerName}</span>
                    <span className="review-date">
                      {new Date(review.createdAt).toLocaleDateString('fr-FR')}
                    </span>
                    <span className={`review-status status-${review.status.toLowerCase()}`}>
                      {review.status}
                    </span>
                  </div>
                  <div className="card-actions">
                    {isAdmin && review.status === 'PENDING' && (
                      <>
                        <button 
                          className="btn-success"
                          onClick={() => handleReviewStatusChange(review.id, 'APPROVED')}
                        >
                          Approuver
                        </button>
                        <button 
                          className="btn-warning"
                          onClick={() => handleReviewStatusChange(review.id, 'REJECTED')}
                        >
                          Rejeter
                        </button>
                      </>
                    )}
                    
                    {canModifyReview(review) && (
                      <>
                        <button className="btn-secondary">Modifier</button>
                        <button 
                          className="btn-danger"
                          onClick={() => handleDeleteReview(review.id)}
                          disabled={deletingReview === review.id}
                        >
                          {deletingReview === review.id ? 'Suppression...' : 'Supprimer'}
                        </button>
                      </>
                    )}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      )}

      {isAdmin && activeTab === 'reports' && (
        <div className="reports-section">
          <div className="reports-grid">
            {reports.length === 0 ? (
              <div className="empty-state">
                <p>Aucun signalement trouvé</p>
              </div>
            ) : (
              reports.map((report) => (
                <div key={report.id} className="report-card">
                  <div className="report-header">
                    <h4>Signalement #{report.id}</h4>
                    <span className={`report-status status-${report.status.toLowerCase()}`}>
                      {report.status}
                    </span>
                  </div>
                  <p className="report-type">Type: {report.reportType}</p>
                  <p className="report-description">{report.description}</p>
                  <div className="report-footer">
                    <span className="reporter">Signalé par {report.reporterName}</span>
                    <span className="report-target">Restaurant #{report.restaurantId}</span>
                    <span className="report-date">
                      {new Date(report.createdAt).toLocaleDateString('fr-FR')}
                    </span>
                  </div>
                  <div className="card-actions">
                    <button className="btn-primary">Traiter</button>
                    <button className="btn-secondary">Enquêter</button>
                    <button className="btn-danger">Archiver</button>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default Reviews;
