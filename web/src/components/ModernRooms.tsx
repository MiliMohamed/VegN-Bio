import React from 'react';
import { motion } from 'framer-motion';
import { 
  Calendar, 
  Clock, 
  Users, 
  MapPin,
  Plus,
  Edit,
  Trash2,
  Eye,
  CheckCircle,
  XCircle
} from 'lucide-react';

const ModernRooms: React.FC = () => {
  const rooms = [
    {
      id: 1,
      name: 'Salle de réunion Bastille',
      restaurant: 'VegN Bio Bastille',
      capacity: 20,
      features: ['Wi-Fi', 'Projecteur', 'Tableau blanc'],
      hourlyRate: 50,
      status: 'available'
    },
    {
      id: 2,
      name: 'Salle République A',
      restaurant: 'VegN Bio République',
      capacity: 15,
      features: ['Wi-Fi', 'Écran', 'Sonorisation'],
      hourlyRate: 45,
      status: 'booked'
    },
    {
      id: 3,
      name: 'Salle République B',
      restaurant: 'VegN Bio République',
      capacity: 25,
      features: ['Wi-Fi', 'Projecteur', 'Tableau blanc', 'Cuisine'],
      hourlyRate: 60,
      status: 'available'
    },
    {
      id: 4,
      name: 'Salle Nation',
      restaurant: 'VegN Bio Nation',
      capacity: 12,
      features: ['Wi-Fi', 'Écran'],
      hourlyRate: 40,
      status: 'maintenance'
    },
    {
      id: 5,
      name: 'Salle Place d\'Italie',
      restaurant: 'VegN Bio Place d\'Italie',
      capacity: 18,
      features: ['Wi-Fi', 'Projecteur', 'Tableau blanc'],
      hourlyRate: 50,
      status: 'available'
    },
    {
      id: 6,
      name: 'Salle Beaubourg',
      restaurant: 'VegN Bio Beaubourg',
      capacity: 16,
      features: ['Wi-Fi', 'Écran', 'Sonorisation'],
      hourlyRate: 55,
      status: 'available'
    }
  ];

  const getStatusColor = (status: string) => {
    const colors: { [key: string]: string } = {
      'available': 'success',
      'booked': 'warning',
      'maintenance': 'danger'
    };
    return colors[status] || 'primary';
  };

  const getStatusText = (status: string) => {
    const texts: { [key: string]: string } = {
      'available': 'Disponible',
      'booked': 'Réservée',
      'maintenance': 'Maintenance'
    };
    return texts[status] || 'Inconnu';
  };

  return (
    <div className="modern-rooms">
      <div className="rooms-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Salles de Réunion</h1>
          <p className="page-subtitle">
            Réservez nos salles de réunion pour vos événements professionnels
          </p>
        </motion.div>
      </div>

      <div className="rooms-actions">
        <motion.button
          className="btn btn-primary"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <Plus className="w-5 h-5" />
          Nouvelle réservation
        </motion.button>
      </div>

      <div className="rooms-grid">
        {rooms.map((room, index) => (
          <motion.div
            key={room.id}
            className="room-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
            whileHover={{ y: -5 }}
          >
            <div className="room-header">
              <div className="room-status">
                <span className={`badge badge-${getStatusColor(room.status)}`}>
                  {getStatusText(room.status)}
                </span>
              </div>
              <h3 className="room-name">{room.name}</h3>
              <div className="room-location">
                <MapPin className="w-4 h-4" />
                <span>{room.restaurant}</span>
              </div>
            </div>

            <div className="room-details">
              <div className="detail-item">
                <Users className="w-4 h-4" />
                <div className="detail-content">
                  <div className="detail-label">Capacité</div>
                  <div className="detail-value">{room.capacity} personnes</div>
                </div>
              </div>
              
              <div className="detail-item">
                <Clock className="w-4 h-4" />
                <div className="detail-content">
                  <div className="detail-label">Tarif horaire</div>
                  <div className="detail-value">{room.hourlyRate} €/h</div>
                </div>
              </div>
            </div>

            <div className="room-features">
              <h4 className="features-title">Équipements</h4>
              <div className="features-list">
                {room.features.map((feature, idx) => (
                  <div key={idx} className="feature-item">
                    <CheckCircle className="w-4 h-4" />
                    <span>{feature}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="room-actions">
              <button className="btn btn-primary btn-sm">
                <Calendar className="w-4 h-4" />
                Réserver
              </button>
              <button className="btn btn-secondary btn-sm">
                <Eye className="w-4 h-4" />
                Voir détails
              </button>
              <button className="btn btn-secondary btn-sm">
                <Edit className="w-4 h-4" />
                Modifier
              </button>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
};

export default ModernRooms;