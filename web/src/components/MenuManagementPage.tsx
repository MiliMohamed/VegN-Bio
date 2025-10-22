import React from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../contexts/AuthContext';
import { 
  Utensils, 
  Building2, 
  Zap, 
  Database,
  ArrowRight,
  CheckCircle,
  Star
} from 'lucide-react';
import DynamicMenuCreator from './DynamicMenuCreator';
import '../styles/dynamic-menu-creator.css';

const MenuManagementPage: React.FC = () => {
  const { user } = useAuth();

  const features = [
    {
      icon: <Database className="w-6 h-6" />,
      title: "Récupération Dynamique",
      description: "Les IDs des restaurants sont récupérés automatiquement depuis l'API"
    },
    {
      icon: <Zap className="w-6 h-6" />,
      title: "Création Automatique",
      description: "Génération automatique des menus avec les bons IDs"
    },
    {
      icon: <Building2 className="w-6 h-6" />,
      title: "Multi-Restaurants",
      description: "Support de tous les restaurants VegN Bio"
    },
    {
      icon: <CheckCircle className="w-6 h-6" />,
      title: "Templates Prédéfinis",
      description: "Plats adaptés à chaque restaurant"
    }
  ];

  return (
    <div className="menu-management-page">
      <div className="page-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">
            <Utensils className="w-8 h-8" />
            Gestion des Menus Dynamique
          </h1>
          <p className="page-subtitle">
            Créez et gérez vos menus de manière intelligente et automatique
          </p>
        </motion.div>
      </div>

      {/* Section des fonctionnalités */}
      <motion.div 
        className="features-section"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="features-grid">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              className="feature-card"
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.3 + index * 0.1 }}
              whileHover={{ y: -5 }}
            >
              <div className="feature-icon">
                {feature.icon}
              </div>
              <h3 className="feature-title">{feature.title}</h3>
              <p className="feature-description">{feature.description}</p>
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* Section d'information */}
      <motion.div 
        className="info-section"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
      >
        <div className="info-card">
          <div className="info-header">
            <Star className="w-6 h-6 text-yellow-500" />
            <h2 className="info-title">Avantages du Système Dynamique</h2>
          </div>
          <div className="info-content">
            <div className="benefits-list">
              <div className="benefit-item">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span><strong>Plus de codes en dur :</strong> Les IDs sont récupérés automatiquement</span>
              </div>
              <div className="benefit-item">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span><strong>Mise à jour automatique :</strong> Nouveaux restaurants détectés automatiquement</span>
              </div>
              <div className="benefit-item">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span><strong>Interface intuitive :</strong> Sélection visuelle des restaurants</span>
              </div>
              <div className="benefit-item">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span><strong>Génération SQL :</strong> Export automatique du code SQL</span>
              </div>
              <div className="benefit-item">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span><strong>API Directe :</strong> Création des menus via l'API REST</span>
              </div>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Instructions d'utilisation */}
      <motion.div 
        className="instructions-section"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.5 }}
      >
        <div className="instructions-card">
          <h2 className="instructions-title">Comment utiliser le Créateur Dynamique</h2>
          <div className="steps-list">
            <div className="step-item">
              <div className="step-number">1</div>
              <div className="step-content">
                <h3>Sélectionnez un restaurant</h3>
                <p>Choisissez parmi la liste des restaurants récupérés automatiquement depuis l'API</p>
              </div>
            </div>
            <div className="step-item">
              <div className="step-number">2</div>
              <div className="step-content">
                <h3>Configurez le menu</h3>
                <p>Définissez le titre, les dates de validité et visualisez l'aperçu des plats</p>
              </div>
            </div>
            <div className="step-item">
              <div className="step-number">3</div>
              <div className="step-content">
                <h3>Créez le menu</h3>
                <p>Utilisez l'API directe ou générez le SQL pour l'exécuter manuellement</p>
              </div>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Composant principal */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
      >
        <DynamicMenuCreator />
      </motion.div>
    </div>
  );
};

export default MenuManagementPage;
