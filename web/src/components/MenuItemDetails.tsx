import React from 'react';
import { motion } from 'framer-motion';
import { 
  X, 
  AlertTriangle, 
  Shield, 
  Leaf, 
  Star, 
  Euro,
  Info,
  ShoppingCart,
  Heart
} from 'lucide-react';
import { useCart } from '../contexts/CartContext';
import { useFavorites } from '../contexts/FavoritesContext';
import '../styles/menu-item-details.css';

interface Allergen {
  id: number;
  code: string;
  label: string;
}

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens: Allergen[];
}

interface MenuItemDetailsProps {
  item: MenuItem | null;
  isOpen: boolean;
  onClose: () => void;
  restaurantName?: string;
  allergenPreferences?: { [allergenId: number]: boolean };
}

const MenuItemDetails: React.FC<MenuItemDetailsProps> = ({
  item,
  isOpen,
  onClose,
  restaurantName,
  allergenPreferences = {}
}) => {
  const { addToCart } = useCart();
  const { addToFavorites, removeFromFavorites, isFavorite } = useFavorites();

  if (!item || !isOpen) return null;

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const getAllergenIcon = (code: string) => {
    const icons: { [key: string]: string } = {
      'GLUTEN': '🌾',
      'CRUST': '🦐',
      'EGG': '🥚',
      'FISH': '🐟',
      'PEANUT': '🥜',
      'SOY': '🫘',
      'MILK': '🥛',
      'NUTS': '🌰',
      'CELERY': '🥬',
      'MUSTARD': '🟡',
      'SESAME': '🟤',
      'SULPHITES': '⚗️',
      'LUPIN': '🟣',
      'MOLLUSCS': '🐚'
    };
    return icons[code] || '⚠️';
  };

  const getDangerousAllergens = () => {
    const userAllergens = Object.keys(allergenPreferences)
      .filter(key => allergenPreferences[Number(key)])
      .map(Number);
    
    return item.allergens.filter(allergen => 
      userAllergens.includes(allergen.id)
    );
  };

  const handleAddToCart = () => {
    addToCart({
      id: item.id,
      name: item.name,
      description: item.description,
      priceCents: item.priceCents,
      isVegan: item.isVegan,
      allergens: item.allergens,
      restaurantId: 0, // TODO: Passer l'ID du restaurant
      restaurantName: restaurantName || 'Restaurant'
    }, restaurantName || 'Restaurant');
    
    // Notification
    alert(`${item.name} ajouté au panier !`);
  };

  const handleToggleFavorite = () => {
    if (isFavorite(item.id)) {
      removeFromFavorites(item.id);
      alert(`${item.name} retiré des favoris`);
    } else {
      addToFavorites({
        id: item.id,
        name: item.name,
        description: item.description,
        priceCents: item.priceCents,
        isVegan: item.isVegan,
        allergens: item.allergens,
        restaurantId: 0, // TODO: Passer l'ID du restaurant
        restaurantName: restaurantName || 'Restaurant'
      });
      alert(`${item.name} ajouté aux favoris`);
    }
  };

  const dangerousAllergens = getDangerousAllergens();

  return (
    <motion.div
      className="menu-item-details-overlay"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      onClick={onClose}
    >
      <motion.div
        className="menu-item-details-modal"
        initial={{ opacity: 0, scale: 0.9, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.9, y: 20 }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="modal-header">
          <div className="header-content">
            <h2 className="item-title">{item.name}</h2>
            <div className="item-price">{formatPrice(item.priceCents)}</div>
          </div>
          <button className="close-btn" onClick={onClose}>
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="modal-content">
          {/* Description */}
          <div className="item-description">
            <p>{item.description}</p>
          </div>

          {/* Badges */}
          <div className="item-badges">
            {item.isVegan && (
              <div className="badge badge-vegan">
                <Leaf className="w-4 h-4" />
                <span>Végétalien</span>
              </div>
            )}
            <div className="badge badge-bio">
              <Star className="w-4 h-4" />
              <span>Bio</span>
            </div>
          </div>

          {/* Allergènes */}
          {item.allergens && item.allergens.length > 0 && (
            <div className="allergens-section">
              <div className="section-header">
                <AlertTriangle className="w-5 h-5" />
                <h3>Allergènes</h3>
              </div>
              
              <div className="allergens-list">
                {item.allergens.map((allergen) => {
                  const isDangerous = dangerousAllergens.some(da => da.id === allergen.id);
                  return (
                    <div 
                      key={allergen.id} 
                      className={`allergen-item ${isDangerous ? 'dangerous' : ''}`}
                    >
                      <span className="allergen-icon">{getAllergenIcon(allergen.code)}</span>
                      <div className="allergen-info">
                        <span className="allergen-label">{allergen.label}</span>
                        <span className="allergen-code">({allergen.code})</span>
                      </div>
                      {isDangerous && (
                        <div className="danger-indicator">
                          <Shield className="w-4 h-4" />
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>

              {/* Alerte pour les allergènes dangereux */}
              {dangerousAllergens.length > 0 && (
                <div className="allergen-warning">
                  <AlertTriangle className="w-5 h-5" />
                  <div className="warning-content">
                    <h4>⚠️ Attention !</h4>
                    <p>
                      Ce plat contient des allergènes auxquels vous êtes allergique :
                    </p>
                    <ul>
                      {dangerousAllergens.map(allergen => (
                        <li key={allergen.id}>
                          {getAllergenIcon(allergen.code)} {allergen.label}
                        </li>
                      ))}
                    </ul>
                    <p className="warning-note">
                      <strong>Recommandation :</strong> Évitez ce plat ou consultez le personnel du restaurant pour plus d'informations.
                    </p>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Informations nutritionnelles (placeholder) */}
          <div className="nutrition-section">
            <div className="section-header">
              <Info className="w-5 h-5" />
              <h3>Informations</h3>
            </div>
            <div className="nutrition-info">
              <div className="nutrition-item">
                <span className="nutrition-label">Restaurant :</span>
                <span className="nutrition-value">{restaurantName || 'Non spécifié'}</span>
              </div>
              <div className="nutrition-item">
                <span className="nutrition-label">Prix :</span>
                <span className="nutrition-value">{formatPrice(item.priceCents)}</span>
              </div>
              {item.isVegan && (
                <div className="nutrition-item">
                  <span className="nutrition-label">Type :</span>
                  <span className="nutrition-value">Plat végétalien</span>
                </div>
              )}
            </div>
          </div>
        </div>

        <div className="modal-footer">
          <button 
            className="btn btn-secondary"
            onClick={handleToggleFavorite}
          >
            <Heart className={`w-4 h-4 ${isFavorite(item.id) ? 'fill-current' : ''}`} />
            {isFavorite(item.id) ? 'Retirer des favoris' : 'Ajouter aux favoris'}
          </button>
          <button 
            className="btn btn-primary"
            onClick={handleAddToCart}
          >
            <ShoppingCart className="w-4 h-4" />
            Ajouter au panier
          </button>
        </div>
      </motion.div>
    </motion.div>
  );
};

export default MenuItemDetails;
