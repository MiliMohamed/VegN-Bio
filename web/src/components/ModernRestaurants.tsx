import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  MapPin, 
  Phone, 
  Clock, 
  Users, 
  Wifi, 
  Coffee,
  Calendar,
  Star,
  Plus,
  Edit,
  Trash2,
  Eye,
  Search,
  Filter,
  CheckCircle,
  Utensils
} from 'lucide-react';
import { restaurantService } from '../services/api';
import '../styles/menu-improvements.css';

interface Restaurant {
  id: number;
  name: string;
  code: string;
  address: string;
  city: string;
  phone: string;
}

const ModernRestaurants: React.FC = () => {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedRestaurant, setSelectedRestaurant] = useState<Restaurant | null>(null);
  const [showModal, setShowModal] = useState(false);

  useEffect(() => {
  const fetchRestaurants = async () => {
    try {
      const response = await restaurantService.getAll();
      setRestaurants(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des restaurants:', error);
    } finally {
      setLoading(false);
    }
  };

    fetchRestaurants();
  }, []);

  const getRestaurantDetails = (code: string) => {
    const details: { [key: string]: any } = {
      'BAS': {
        name: 'VEG\'N BIO BASTILLE',
        features: ['Wi-Fi très haut débit', 'Plateaux membres', '2 salles de réunion réservables', '100 places de restaurant', '1 imprimante'],
        hours: {
          weekdays: 'Lundi à Jeudi : de 9h à 24h',
          friday: 'Vendredi : de 9h à 1h du matin',
          saturday: 'Samedi : de 9h à 5h du matin',
          sunday: 'Dimanche : de 11h à 24h du matin'
        },
        services: ['Réservation de salles', 'Plateaux repas', 'Événements privés']
      },
      'REP': {
        name: 'VEG\'N BIO REPUBLIQUE',
        features: ['Wi-Fi très haut débit', '4 salles de réunion réservables', '150 places de restaurant', '1 imprimante', 'Plateaux repas livrables sur demande'],
        hours: {
          weekdays: 'Lundi à Jeudi : de 9h à 24h',
          friday: 'Vendredi : de 9h à 1h du matin',
          saturday: 'Samedi : de 9h à 5h du matin',
          sunday: 'Dimanche : de 11h à 24h du matin'
        },
        services: ['Réservation de salles', 'Livraison plateaux', 'Événements privés']
      },
      'NAT': {
        name: 'VEG\'N BIO NATION',
        features: ['Wi-Fi très haut débit', 'Plateaux membres', '1 salle de réunion réservable', '80 places de restaurant', '1 imprimante', 'Plateaux repas livrables sur demande', 'Conférences et animations tous les mardi après-midi'],
        hours: {
          weekdays: 'Lundi à Jeudi : de 9h à 24h',
          friday: 'Vendredi : de 9h à 1h du matin',
          saturday: 'Samedi : de 9h à 5h du matin',
          sunday: 'Dimanche : de 11h à 24h du matin'
        },
        services: ['Réservation de salles', 'Livraison plateaux', 'Animations mardi', 'Événements privés']
      },
      'ITA': {
        name: 'VEG\'N BIO PLACE D\'ITALIE',
        features: ['Wi-Fi très haut débit', 'Plateaux membres', '2 salles de réunion réservables', '70 places de restaurant', '1 imprimante', 'Plateaux repas livrables sur demande'],
        hours: {
          weekdays: 'Lundi à Jeudi : de 9h à 23h',
          friday: 'Vendredi : de 9h à 1h du matin',
          saturday: 'Samedi : de 9h à 5h du matin',
          sunday: 'Dimanche : de 11h à 23h du matin'
        },
        services: ['Réservation de salles', 'Livraison plateaux', 'Événements privés']
      },
      'BOU': {
        name: 'VEG\'N BIO BEAUBOURG',
        features: ['Wi-Fi très haut débit', 'Plateaux membres', '2 salles de réunion réservables', '70 places de restaurant', '1 imprimante', 'Plateaux repas livrables sur demande'],
        hours: {
          weekdays: 'Lundi à Jeudi : de 9h à 23h',
          friday: 'Vendredi : de 9h à 1h du matin',
          saturday: 'Samedi : de 9h à 5h du matin',
          sunday: 'Dimanche : de 11h à 23h du matin'
        },
        services: ['Réservation de salles', 'Livraison plateaux', 'Événements privés']
      }
    };
    return details[code] || {};
  };

  const filteredRestaurants = restaurants.filter(restaurant =>
    restaurant.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    restaurant.address.toLowerCase().includes(searchTerm.toLowerCase()) ||
    restaurant.city.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleViewDetails = (restaurant: Restaurant) => {
    setSelectedRestaurant(restaurant);
    setShowModal(true);
  };

  const handleEditRestaurant = (restaurant: Restaurant) => {
    // TODO: Implémenter l'édition de restaurant
    console.log('Édition du restaurant:', restaurant);
  };

  const handleViewMenus = (restaurant: Restaurant) => {
    // TODO: Rediriger vers la page des menus avec le restaurant sélectionné
    console.log('Voir les menus du restaurant:', restaurant);
    // window.location.href = `/app/menus?restaurant=${restaurant.id}`;
  };

  const handleReserveRoom = (restaurant: Restaurant) => {
    // TODO: Implémenter la réservation de salle
    console.log('Réserver une salle pour:', restaurant);
  };

  const handleViewRestaurantMenus = (restaurant: Restaurant) => {
    // TODO: Rediriger vers la page des menus
    console.log('Voir les menus de:', restaurant);
  };

  const handleContactRestaurant = (restaurant: Restaurant) => {
    // Ouvrir l'application de téléphonie ou d'email
    window.open(`tel:${restaurant.phone}`, '_self');
  };

  if (loading) {
    return (
      <div className="modern-restaurants">
        <div className="loading-container">
          <div className="loading-spinner"></div>
            <p>Chargement des restaurants...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-restaurants">
      <div className="restaurants-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Nos Restaurants</h1>
            <p className="page-subtitle">
            Découvrez nos 5 restaurants VegN Bio dans Paris
          </p>
        </motion.div>
      </div>

      {/* Barre de recherche et filtres */}
      <motion.div 
        className="search-section"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="search-bar">
          <div className="search-input-container">
            <Search className="search-icon" />
            <input
              type="text"
              placeholder="Rechercher un restaurant..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
            />
          </div>
          <button className="filter-btn">
            <Filter className="w-5 h-5" />
            Filtres
          </button>
        </div>
      </motion.div>

      {/* Grille des restaurants */}
      <div className="restaurants-grid">
        {filteredRestaurants.map((restaurant, index) => {
          const details = getRestaurantDetails(restaurant.code);
          return (
            <motion.div
              key={restaurant.id}
              className="restaurant-card"
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.3 + index * 0.1 }}
              whileHover={{ y: -5 }}
            >
              <div className="restaurant-header">
                <div className="restaurant-badge">
                  {restaurant.code}
          </div>
                <h3 className="restaurant-name">{restaurant.name}</h3>
                <div className="restaurant-location">
                  <MapPin className="w-4 h-4" />
                  <span>{restaurant.address}, {restaurant.city}</span>
        </div>
      </div>

              <div className="restaurant-features">
                <div className="features-grid">
                  {details.features?.slice(0, 3).map((feature: string, idx: number) => (
                    <div key={idx} className="feature-item">
                      <div className="feature-icon">
                        {feature.includes('Wi-Fi') && <Wifi className="w-4 h-4" />}
                        {feature.includes('salle') && <Calendar className="w-4 h-4" />}
                        {feature.includes('place') && <Users className="w-4 h-4" />}
                        {feature.includes('imprimante') && <Coffee className="w-4 h-4" />}
                        {feature.includes('plateau') && <Coffee className="w-4 h-4" />}
                        {feature.includes('conférence') && <Star className="w-4 h-4" />}
            </div>
                      <span className="feature-text">{feature}</span>
                    </div>
                  ))}
                    </div>
                  </div>
                  
              <div className="restaurant-info">
                <div className="info-item">
                  <Phone className="w-4 h-4" />
                  <span>{restaurant.phone}</span>
                </div>
                <div className="info-item">
                  <Clock className="w-4 h-4" />
                  <span>Ouvert maintenant</span>
                </div>
            </div>

              <div className="restaurant-actions">
                <button 
                  className="btn btn-primary btn-sm"
                  onClick={() => handleViewDetails(restaurant)}
                >
                  <Eye className="w-4 h-4" />
                  Voir détails
                </button>
                <button 
                  className="btn btn-secondary btn-sm"
                  onClick={() => handleEditRestaurant(restaurant)}
                >
                  <Edit className="w-4 h-4" />
                  Modifier
                </button>
                <button 
                  className="btn btn-success btn-sm"
                  onClick={() => handleViewMenus(restaurant)}
                >
                  <Utensils className="w-4 h-4" />
                  Voir menus
                </button>
          </div>
            </motion.div>
          );
        })}
        </div>

      {/* Modal de détails */}
      {showModal && selectedRestaurant && (
        <div className="modal-overlay" onClick={() => setShowModal(false)}>
          <motion.div 
            className="modal-content"
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.3 }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="modal-header">
              <h2 className="modal-title">{selectedRestaurant.name}</h2>
              <button 
                className="modal-close"
                onClick={() => setShowModal(false)}
              >
                ×
              </button>
                  </div>
                  
            <div className="modal-body">
              {(() => {
                const details = getRestaurantDetails(selectedRestaurant.code);
                return (
                  <>
                    <div className="modal-section">
                      <h3 className="section-title">Informations générales</h3>
                      <div className="info-grid">
                        <div className="info-item">
                          <MapPin className="w-4 h-4" />
                          <span>{selectedRestaurant.address}, {selectedRestaurant.city}</span>
                        </div>
                        <div className="info-item">
                          <Phone className="w-4 h-4" />
                          <span>{selectedRestaurant.phone}</span>
                        </div>
                        </div>
                      </div>

                    <div className="modal-section">
                      <h3 className="section-title">Équipements disponibles</h3>
                      <div className="features-list">
                        {details.features?.map((feature: string, idx: number) => (
                          <div key={idx} className="feature-item">
                            <div className="feature-icon">
                              {feature.includes('Wi-Fi') && <Wifi className="w-4 h-4" />}
                              {feature.includes('salle') && <Calendar className="w-4 h-4" />}
                              {feature.includes('place') && <Users className="w-4 h-4" />}
                              {feature.includes('imprimante') && <Coffee className="w-4 h-4" />}
                              {feature.includes('plateau') && <Coffee className="w-4 h-4" />}
                              {feature.includes('conférence') && <Star className="w-4 h-4" />}
                        </div>
                            <span>{feature}</span>
                      </div>
                        ))}
                    </div>
                  </div>
                  
                    <div className="modal-section">
                      <h3 className="section-title">Horaires d'ouverture</h3>
                    <div className="hours-list">
                        {details.hours && Object.entries(details.hours).map(([key, value]) => (
                          <div key={key} className="hour-item">
                            <span className="hour-label">{key.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase())}</span>
                            <span className="hour-value">{value as string}</span>
                        </div>
                        ))}
                        </div>
                    </div>

                    <div className="modal-section">
                      <h3 className="section-title">Services proposés</h3>
                      <div className="services-list">
                        {details.services?.map((service: string, idx: number) => (
                          <div key={idx} className="service-item">
                            <CheckCircle className="w-4 h-4" />
                            <span>{service}</span>
                  </div>
                        ))}
                    </div>
                    </div>
                  </>
                );
              })()}
                  </div>
                  
            <div className="modal-footer">
              <button 
                className="btn btn-primary"
                onClick={() => handleReserveRoom(selectedRestaurant)}
              >
                <Calendar className="w-4 h-4" />
                Réserver une salle
              </button>
              <button 
                className="btn btn-secondary"
                onClick={() => handleViewRestaurantMenus(selectedRestaurant)}
              >
                <Utensils className="w-4 h-4" />
                Voir le menu
              </button>
              <button 
                className="btn btn-success"
                onClick={() => handleContactRestaurant(selectedRestaurant)}
              >
                <Phone className="w-4 h-4" />
                Contacter
              </button>
            </div>
          </motion.div>
          </div>
        )}
    </div>
  );
};

export default ModernRestaurants;