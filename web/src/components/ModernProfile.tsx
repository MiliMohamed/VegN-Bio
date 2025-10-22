import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  User, 
  Mail, 
  Phone, 
  MapPin, 
  Calendar, 
  Edit, 
  Save, 
  X,
  Camera,
  Shield,
  Star,
  Heart,
  ShoppingCart,
  Clock
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useCart } from '../contexts/CartContext';
import { useFavorites } from '../contexts/FavoritesContext';
import '../styles/profile-styles.css';

const ModernProfile: React.FC = () => {
  const { user } = useAuth();
  const { getTotalItems } = useCart();
  const { getFavoritesCount } = useFavorites();
  const [isEditing, setIsEditing] = useState(false);
  const [profileData, setProfileData] = useState({
    fullName: user?.name || '',
    email: user?.email || '',
    phone: '',
    address: '',
    bio: 'Passionné de cuisine végétarienne bio et de produits locaux.',
    joinDate: 'Janvier 2024'
  });

  const handleSave = () => {
    // TODO: Implémenter la sauvegarde du profil
    console.log('Sauvegarde du profil:', profileData);
    setIsEditing(false);
    alert('Profil mis à jour avec succès !');
  };

  const handleCancel = () => {
    setProfileData({
      fullName: user?.name || '',
      email: user?.email || '',
      phone: '',
      address: '',
      bio: 'Passionné de cuisine végétarienne bio et de produits locaux.',
      joinDate: 'Janvier 2024'
    });
    setIsEditing(false);
  };

  const stats = [
    {
      icon: <ShoppingCart className="w-6 h-6" />,
      label: 'Commandes',
      value: '24',
      color: 'blue'
    },
    {
      icon: <Heart className="w-6 h-6" />,
      label: 'Favoris',
      value: getFavoritesCount().toString(),
      color: 'red'
    },
    {
      icon: <Star className="w-6 h-6" />,
      label: 'Avis',
      value: '12',
      color: 'yellow'
    },
    {
      icon: <Clock className="w-6 h-6" />,
      label: 'Points',
      value: '1,250',
      color: 'green'
    }
  ];

  return (
    <div className="modern-profile">
      <div className="profile-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Mon Profil</h1>
          <p className="page-subtitle">
            Gérez vos informations personnelles et préférences
          </p>
        </motion.div>
      </div>

      <div className="profile-content">
        {/* Carte de profil principale */}
        <motion.div
          className="profile-card"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <div className="profile-avatar-section">
            <div className="profile-avatar">
              <User className="w-16 h-16" />
              <button className="avatar-edit-btn">
                <Camera className="w-4 h-4" />
              </button>
            </div>
            <div className="profile-info">
              <h2 className="profile-name">{profileData.fullName}</h2>
              <p className="profile-role">
                <Shield className="w-4 h-4" />
                {user?.role || 'CLIENT'}
              </p>
              <p className="profile-join-date">
                <Calendar className="w-4 h-4" />
                Membre depuis {profileData.joinDate}
              </p>
            </div>
          </div>

          <div className="profile-actions">
            {!isEditing ? (
              <button 
                className="btn btn-primary"
                onClick={() => setIsEditing(true)}
              >
                <Edit className="w-4 h-4" />
                Modifier le profil
              </button>
            ) : (
              <div className="edit-actions">
                <button 
                  className="btn btn-success"
                  onClick={handleSave}
                >
                  <Save className="w-4 h-4" />
                  Sauvegarder
                </button>
                <button 
                  className="btn btn-secondary"
                  onClick={handleCancel}
                >
                  <X className="w-4 h-4" />
                  Annuler
                </button>
              </div>
            )}
          </div>
        </motion.div>

        {/* Statistiques */}
        <motion.div
          className="stats-grid"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
        >
          {stats.map((stat, index) => (
            <div key={index} className={`stat-card ${stat.color}`}>
              <div className="stat-icon">{stat.icon}</div>
              <div className="stat-content">
                <div className="stat-value">{stat.value}</div>
                <div className="stat-label">{stat.label}</div>
              </div>
            </div>
          ))}
        </motion.div>

        {/* Informations personnelles */}
        <motion.div
          className="profile-details"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
        >
          <div className="details-card">
            <h3>Informations personnelles</h3>
            
            <div className="form-group">
              <label htmlFor="fullName">
                <User className="w-4 h-4" />
                Nom complet
              </label>
              {isEditing ? (
                <input
                  type="text"
                  id="fullName"
                  value={profileData.fullName}
                  onChange={(e) => setProfileData({...profileData, fullName: e.target.value})}
                  className="form-input"
                />
              ) : (
                <div className="form-display">{profileData.fullName}</div>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="email">
                <Mail className="w-4 h-4" />
                Email
              </label>
              {isEditing ? (
                <input
                  type="email"
                  id="email"
                  value={profileData.email}
                  onChange={(e) => setProfileData({...profileData, email: e.target.value})}
                  className="form-input"
                />
              ) : (
                <div className="form-display">{profileData.email}</div>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="phone">
                <Phone className="w-4 h-4" />
                Téléphone
              </label>
              {isEditing ? (
                <input
                  type="tel"
                  id="phone"
                  value={profileData.phone}
                  onChange={(e) => setProfileData({...profileData, phone: e.target.value})}
                  className="form-input"
                  placeholder="+33 6 12 34 56 78"
                />
              ) : (
                <div className="form-display">{profileData.phone || 'Non renseigné'}</div>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="address">
                <MapPin className="w-4 h-4" />
                Adresse
              </label>
              {isEditing ? (
                <textarea
                  id="address"
                  value={profileData.address}
                  onChange={(e) => setProfileData({...profileData, address: e.target.value})}
                  className="form-input"
                  rows={3}
                  placeholder="Votre adresse complète"
                />
              ) : (
                <div className="form-display">{profileData.address || 'Non renseignée'}</div>
              )}
            </div>

            <div className="form-group">
              <label htmlFor="bio">
                <User className="w-4 h-4" />
                Bio
              </label>
              {isEditing ? (
                <textarea
                  id="bio"
                  value={profileData.bio}
                  onChange={(e) => setProfileData({...profileData, bio: e.target.value})}
                  className="form-input"
                  rows={3}
                />
              ) : (
                <div className="form-display">{profileData.bio}</div>
              )}
            </div>
          </div>
        </motion.div>

        {/* Préférences */}
        <motion.div
          className="preferences-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.5 }}
        >
          <div className="preferences-card">
            <h3>Préférences</h3>
            
            <div className="preference-item">
              <div className="preference-info">
                <h4>Notifications par email</h4>
                <p>Recevoir les nouvelles promotions et menus</p>
              </div>
              <div className="preference-toggle">
                <input type="checkbox" id="email-notifications" defaultChecked />
                <label htmlFor="email-notifications" className="toggle-switch">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="preference-item">
              <div className="preference-info">
                <h4>Notifications push</h4>
                <p>Alertes pour les réservations et commandes</p>
              </div>
              <div className="preference-toggle">
                <input type="checkbox" id="push-notifications" defaultChecked />
                <label htmlFor="push-notifications" className="toggle-switch">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="preference-item">
              <div className="preference-info">
                <h4>Partage de données</h4>
                <p>Autoriser l'utilisation des données pour améliorer le service</p>
              </div>
              <div className="preference-toggle">
                <input type="checkbox" id="data-sharing" />
                <label htmlFor="data-sharing" className="toggle-switch">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default ModernProfile;
