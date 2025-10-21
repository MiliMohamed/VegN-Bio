import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  ShoppingCart, 
  Trash2, 
  Plus, 
  Minus, 
  CreditCard, 
  X,
  MapPin,
  Calendar,
  Clock,
  Users
} from 'lucide-react';
import { useCart } from '../contexts/CartContext';
import '../styles/cart-styles.css';

const ModernCart: React.FC = () => {
  const { cartItems, removeFromCart, updateQuantity, clearCart, getTotalPrice, getTotalItems } = useCart();
  const [showCheckout, setShowCheckout] = useState(false);
  const [showRoomBooking, setShowRoomBooking] = useState(false);
  const [showEventBooking, setShowEventBooking] = useState(false);

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const handleQuantityChange = (itemId: number, newQuantity: number) => {
    updateQuantity(itemId, newQuantity);
  };

  const handleCheckout = () => {
    setShowCheckout(true);
    // TODO: Implémenter la logique de paiement
  };

  const handleRoomBooking = () => {
    setShowRoomBooking(true);
  };

  const handleEventBooking = () => {
    setShowEventBooking(true);
  };

  if (cartItems.length === 0) {
    return (
      <div className="modern-cart">
        <div className="cart-header">
          <h1 className="page-title">Mon Panier</h1>
          <div className="cart-icon">
            <ShoppingCart className="w-8 h-8" />
            <span className="cart-count">0</span>
          </div>
        </div>
        
        <div className="empty-cart">
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
            className="empty-cart-content"
          >
            <ShoppingCart className="w-16 h-16 text-gray-400" />
            <h2>Votre panier est vide</h2>
            <p>Ajoutez des plats délicieux à votre panier pour commencer votre commande</p>
            <button className="btn btn-primary">
              Voir les menus
            </button>
          </motion.div>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-cart">
      <div className="cart-header">
        <h1 className="page-title">Mon Panier</h1>
        <div className="cart-icon">
          <ShoppingCart className="w-8 h-8" />
          <span className="cart-count">{getTotalItems()}</span>
        </div>
      </div>

      <div className="cart-content">
        <div className="cart-items">
          {cartItems.map((item, index) => (
            <motion.div
              key={item.id}
              className="cart-item"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.4, delay: index * 0.1 }}
            >
              <div className="item-info">
                <h3 className="item-name">{item.name}</h3>
                <p className="item-description">{item.description}</p>
                <div className="item-details">
                  <span className="restaurant-name">
                    <MapPin className="w-4 h-4" />
                    {item.restaurantName}
                  </span>
                  {item.isVegan && (
                    <span className="badge badge-vegan">Végétalien</span>
                  )}
                </div>
                {item.allergens && item.allergens.length > 0 && (
                  <div className="allergens-info">
                    <span className="allergens-label">⚠️ Allergènes:</span>
                    <div className="allergens-list">
                      {item.allergens.map((allergen) => (
                        <span key={allergen.id} className="allergen-badge">
                          {allergen.label}
                        </span>
                      ))}
                    </div>
                  </div>
                )}
              </div>

              <div className="item-controls">
                <div className="quantity-controls">
                  <button
                    className="btn btn-sm btn-outline"
                    onClick={() => handleQuantityChange(item.id, item.quantity - 1)}
                  >
                    <Minus className="w-4 h-4" />
                  </button>
                  <span className="quantity">{item.quantity}</span>
                  <button
                    className="btn btn-sm btn-outline"
                    onClick={() => handleQuantityChange(item.id, item.quantity + 1)}
                  >
                    <Plus className="w-4 h-4" />
                  </button>
                </div>
                
                <div className="item-price">
                  {formatPrice(item.priceCents * item.quantity)}
                </div>
                
                <button
                  className="btn btn-sm btn-danger"
                  onClick={() => removeFromCart(item.id)}
                  title="Supprimer"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </motion.div>
          ))}
        </div>

        <div className="cart-summary">
          <div className="summary-card">
            <h3>Résumé de la commande</h3>
            
            <div className="summary-line">
              <span>Articles ({getTotalItems()})</span>
              <span>{formatPrice(getTotalPrice())}</span>
            </div>
            
            <div className="summary-line">
              <span>Frais de service</span>
              <span>Gratuit</span>
            </div>
            
            <div className="summary-line total">
              <span>Total</span>
              <span>{formatPrice(getTotalPrice())}</span>
            </div>
            
            <div className="summary-actions">
              <button 
                className="btn btn-primary btn-lg"
                onClick={handleCheckout}
              >
                <CreditCard className="w-5 h-5" />
                Commander maintenant
              </button>
              
              <button 
                className="btn btn-secondary"
                onClick={clearCart}
              >
                Vider le panier
              </button>
            </div>
          </div>

          {/* Options de réservation */}
          <div className="booking-options">
            <h3>Options supplémentaires</h3>
            
            <div className="booking-cards">
              <motion.div
                className="booking-card"
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={handleRoomBooking}
              >
                <div className="booking-icon">
                  <Users className="w-8 h-8" />
                </div>
                <h4>Réserver une salle</h4>
                <p>Organisez un événement privé dans nos salles</p>
                <button className="btn btn-outline">Réserver</button>
              </motion.div>
              
              <motion.div
                className="booking-card"
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={handleEventBooking}
              >
                <div className="booking-icon">
                  <Calendar className="w-8 h-8" />
                </div>
                <h4>Créer un événement</h4>
                <p>Organisez une soirée spéciale avec menu personnalisé</p>
                <button className="btn btn-outline">Créer</button>
              </motion.div>
            </div>
          </div>
        </div>
      </div>

      {/* Modales */}
      {showCheckout && (
        <div className="modal-overlay" onClick={() => setShowCheckout(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Finaliser la commande</h3>
              <button 
                className="modal-close"
                onClick={() => setShowCheckout(false)}
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="modal-content">
              <p>Fonctionnalité de paiement à implémenter...</p>
              <div className="modal-actions">
                <button 
                  className="btn btn-primary"
                  onClick={() => setShowCheckout(false)}
                >
                  Fermer
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {showRoomBooking && (
        <div className="modal-overlay" onClick={() => setShowRoomBooking(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Réserver une salle</h3>
              <button 
                className="modal-close"
                onClick={() => setShowRoomBooking(false)}
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="modal-content">
              <p>Fonctionnalité de réservation de salle à implémenter...</p>
              <div className="modal-actions">
                <button 
                  className="btn btn-primary"
                  onClick={() => setShowRoomBooking(false)}
                >
                  Fermer
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {showEventBooking && (
        <div className="modal-overlay" onClick={() => setShowEventBooking(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Créer un événement</h3>
              <button 
                className="modal-close"
                onClick={() => setShowEventBooking(false)}
              >
                <X className="w-6 h-6" />
              </button>
            </div>
            <div className="modal-content">
              <p>Fonctionnalité de création d'événement à implémenter...</p>
              <div className="modal-actions">
                <button 
                  className="btn btn-primary"
                  onClick={() => setShowEventBooking(false)}
                >
                  Fermer
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ModernCart;