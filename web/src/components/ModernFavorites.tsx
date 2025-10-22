import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Heart, 
  Trash2, 
  ShoppingCart, 
  MapPin,
  Star,
  Clock,
  X,
  Plus,
  Minus
} from 'lucide-react';
import { useFavorites } from '../contexts/FavoritesContext';
import { useCart } from '../contexts/CartContext';
import '../styles/favorites-styles.css';

const ModernFavorites: React.FC = () => {
  const { favorites, removeFromFavorites, clearFavorites } = useFavorites();
  const { addToCart } = useCart();
  const [showClearModal, setShowClearModal] = useState(false);

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const formatDate = (date: Date) => {
    return new Date(date).toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const handleAddToCart = (item: any) => {
    addToCart({
      id: item.id,
      name: item.name,
      description: item.description,
      priceCents: item.priceCents,
      isVegan: item.isVegan,
      allergens: item.allergens,
      restaurantId: item.restaurantId,
      restaurantName: item.restaurantName
    }, item.restaurantName);
    
    // Notification visuelle
    alert(`Ajouté au panier: ${item.name}`);
  };

  const handleClearFavorites = () => {
    clearFavorites();
    setShowClearModal(false);
  };

  if (favorites.length === 0) {
    return (
      <div className="modern-favorites">
        <div className="page-header">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h1 className="page-title">Mes Favoris</h1>
            <p className="page-subtitle">
              Vos plats préférés sauvegardés pour plus tard
            </p>
          </motion.div>
        </div>
        
        <div className="empty-favorites">
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
            className="empty-favorites-content"
          >
            <Heart className="w-16 h-16 text-gray-400" />
            <h2>Vos favoris sont vides</h2>
            <p>Ajoutez des plats à vos favoris en cliquant sur l'icône cœur</p>
            <div className="empty-favorites-actions">
              <a href="/app/restaurants" className="btn btn-primary">
                <MapPin className="w-4 h-4" />
                Voir les restaurants
              </a>
              <a href="/app/menus" className="btn btn-secondary">
                <ShoppingCart className="w-4 h-4" />
                Voir les menus
              </a>
              <a href="/app/my-bookings" className="btn btn-info">
                <Clock className="w-4 h-4" />
                Mes réservations
              </a>
            </div>
          </motion.div>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-favorites">
      <div className="page-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Mes Favoris</h1>
          <p className="page-subtitle">
            {favorites.length} plat{favorites.length > 1 ? 's' : ''} sauvegardé{favorites.length > 1 ? 's' : ''}
          </p>
        </motion.div>
      </div>

      <div className="favorites-actions">
        <motion.button 
          className="btn btn-danger"
          onClick={() => setShowClearModal(true)}
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
        >
          <Trash2 className="w-4 h-4" />
          Vider les favoris
        </motion.button>
      </div>

      <div className="favorites-grid">
        {favorites.map((item, index) => (
          <motion.div
            key={item.id}
            className="favorite-card"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4, delay: index * 0.1 }}
          >
            <div className="card-header">
              <div className="item-info">
                <h3 className="item-name">{item.name}</h3>
                <p className="item-description">{item.description}</p>
              </div>
              <div className="item-price">{formatPrice(item.priceCents)}</div>
            </div>

            <div className="card-details">
              <div className="detail-item">
                <MapPin className="w-4 h-4" />
                <span>{item.restaurantName}</span>
              </div>
              
              <div className="detail-item">
                <Clock className="w-4 h-4" />
                <span>Ajouté le {formatDate(item.addedAt)}</span>
              </div>
              
              {item.isVegan && (
                <div className="detail-item">
                  <Star className="w-4 h-4" />
                  <span>Végétalien</span>
                </div>
              )}
            </div>

            {item.allergens && item.allergens.length > 0 && (
              <div className="allergens-section">
                <div className="allergens-label">
                  <span className="allergens-icon">⚠️</span>
                  Allergènes :
                </div>
                <div className="allergens-list">
                  {item.allergens.map((allergen) => (
                    <span key={allergen.id} className="allergen-badge">
                      {allergen.label}
                    </span>
                  ))}
                </div>
              </div>
            )}

            <div className="card-actions">
              <button 
                className="btn btn-primary"
                onClick={() => handleAddToCart(item)}
              >
                <ShoppingCart className="w-4 h-4" />
                Ajouter au panier
              </button>
              
              <button 
                className="btn btn-danger btn-outline"
                onClick={() => removeFromFavorites(item.id)}
                title="Retirer des favoris"
              >
                <Heart className="w-4 h-4" />
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Modal de confirmation pour vider les favoris */}
      {showClearModal && (
        <div className="modal-overlay" onClick={() => setShowClearModal(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Vider les favoris</h3>
              <button 
                className="modal-close"
                onClick={() => setShowClearModal(false)}
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="modal-content">
              <p>Êtes-vous sûr de vouloir supprimer tous vos favoris ?</p>
              <p className="text-muted">Cette action est irréversible.</p>
              <div className="modal-actions">
                <button 
                  className="btn btn-secondary"
                  onClick={() => setShowClearModal(false)}
                >
                  Annuler
                </button>
                <button 
                  className="btn btn-danger"
                  onClick={handleClearFavorites}
                >
                  <Trash2 className="w-4 h-4" />
                  Supprimer tout
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ModernFavorites;
