import React from 'react';
import { motion } from 'framer-motion';
import { 
  Palette, 
  Moon, 
  Sun, 
  Star, 
  Heart, 
  ShoppingCart,
  MapPin,
  Phone,
  Clock,
  Users,
  Utensils,
  Coffee,
  CheckCircle,
  ArrowRight,
  Sparkles
} from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';
import '../styles/modern-theme-system.css';

const UIImprovementsDemo: React.FC = () => {
  const { actualTheme, toggleTheme } = useTheme();

  const features = [
    {
      icon: <Palette className="w-6 h-6" />,
      title: "Mode Sombre Professionnel",
      description: "Interface moderne avec thème sombre/clair adaptatif",
      color: "var(--primary-color)"
    },
    {
      icon: <Star className="w-6 h-6" />,
      title: "Design Moderne",
      description: "Cartes élégantes avec animations fluides et gradients",
      color: "var(--accent-color)"
    },
    {
      icon: <Heart className="w-6 h-6" />,
      title: "UX Améliorée",
      description: "Interactions intuitives et feedback visuel",
      color: "var(--error-color)"
    },
    {
      icon: <Sparkles className="w-6 h-6" />,
      title: "Animations Fluides",
      description: "Transitions et micro-interactions avec Framer Motion",
      color: "var(--secondary-color)"
    }
  ];

  const sampleRestaurant = {
    name: "VEG'N BIO BASTILLE",
    code: "BAS",
    address: "Place de la Bastille",
    city: "Paris",
    phone: "01 23 45 67 89",
    features: ["Wi-Fi très haut débit", "2 salles de réunion", "100 places"]
  };

  const sampleMenuItems = [
    { name: "Salade Quinoa Bio", price: "12.50€", isVegan: true },
    { name: "Burger Végétarien", price: "15.90€", isVegan: true },
    { name: "Smoothie Vert", price: "6.50€", isVegan: true }
  ];

  return (
    <div className="ui-demo-container">
      {/* Header avec toggle de thème */}
      <div className="demo-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="demo-header-content"
        >
          <div className="demo-title-section">
            <h1 className="demo-title">
              <Sparkles className="w-8 h-8 inline mr-3" />
              Améliorations UI/UX
            </h1>
            <p className="demo-subtitle">
              Interface moderne avec mode sombre et design professionnel
            </p>
          </div>
          <button 
            className="theme-toggle-demo"
            onClick={toggleTheme}
            title={`Basculer vers le mode ${actualTheme === 'light' ? 'sombre' : 'clair'}`}
          >
            {actualTheme === 'light' ? <Moon className="w-6 h-6" /> : <Sun className="w-6 h-6" />}
          </button>
        </motion.div>
      </div>

      {/* Fonctionnalités principales */}
      <div className="demo-features">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="features-grid"
        >
          {features.map((feature, index) => (
            <motion.div
              key={index}
              className="feature-card"
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.3 + index * 0.1 }}
              whileHover={{ y: -8, scale: 1.02 }}
            >
              <div 
                className="feature-icon"
                style={{ backgroundColor: feature.color + '20', color: feature.color }}
              >
                {feature.icon}
              </div>
              <h3 className="feature-title">{feature.title}</h3>
              <p className="feature-description">{feature.description}</p>
            </motion.div>
          ))}
        </motion.div>
      </div>

      {/* Démonstration des composants */}
      <div className="demo-components">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
          className="demo-section"
        >
          <h2 className="section-title">Restaurant Moderne</h2>
          <div className="restaurant-demo-card">
            <div className="restaurant-demo-header">
              <div className="restaurant-demo-badge">{sampleRestaurant.code}</div>
              <h3 className="restaurant-demo-name">{sampleRestaurant.name}</h3>
              <div className="restaurant-demo-location">
                <MapPin className="w-4 h-4" />
                <span>{sampleRestaurant.address}, {sampleRestaurant.city}</span>
              </div>
            </div>
            <div className="restaurant-demo-features">
              {sampleRestaurant.features.map((feature, index) => (
                <div key={index} className="restaurant-demo-feature">
                  <div className="restaurant-demo-feature-icon">
                    {feature.includes('Wi-Fi') && <Coffee className="w-4 h-4" />}
                    {feature.includes('salle') && <Users className="w-4 h-4" />}
                    {feature.includes('place') && <Utensils className="w-4 h-4" />}
                  </div>
                  <span>{feature}</span>
                </div>
              ))}
            </div>
            <div className="restaurant-demo-info">
              <div className="restaurant-demo-info-item">
                <Phone className="w-4 h-4" />
                <span>{sampleRestaurant.phone}</span>
              </div>
              <div className="restaurant-demo-info-item">
                <Clock className="w-4 h-4" />
                <span>Ouvert maintenant</span>
              </div>
            </div>
            <div className="restaurant-demo-actions">
              <button className="btn btn-primary btn-sm">
                <Utensils className="w-4 h-4" />
                Voir menus
              </button>
              <button className="btn btn-secondary btn-sm">
                <MapPin className="w-4 h-4" />
                Localiser
              </button>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.8 }}
          className="demo-section"
        >
          <h2 className="section-title">Menu Items</h2>
          <div className="menu-items-demo">
            {sampleMenuItems.map((item, index) => (
              <motion.div
                key={index}
                className="menu-item-demo"
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.4, delay: 0.9 + index * 0.1 }}
                whileHover={{ x: 8 }}
              >
                <div className="menu-item-demo-icon">
                  <Utensils className="w-5 h-5" />
                </div>
                <div className="menu-item-demo-content">
                  <h4 className="menu-item-demo-name">{item.name}</h4>
                  <div className="menu-item-demo-meta">
                    <span className="menu-item-demo-price">{item.price}</span>
                    {item.isVegan && (
                      <span className="menu-item-demo-badge vegan">Vegan</span>
                    )}
                  </div>
                </div>
                <div className="menu-item-demo-actions">
                  <button className="btn btn-sm btn-primary">
                    <ShoppingCart className="w-4 h-4" />
                  </button>
                  <button className="btn btn-sm btn-secondary">
                    <Heart className="w-4 h-4" />
                  </button>
                </div>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Call to action */}
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 1.0 }}
        className="demo-cta"
      >
        <div className="cta-content">
          <h2 className="cta-title">Prêt à découvrir ?</h2>
          <p className="cta-description">
            Explorez l'interface moderne avec le mode sombre et les nouvelles fonctionnalités
          </p>
          <button className="btn btn-primary btn-lg">
            Commencer l'exploration
            <ArrowRight className="w-5 h-5" />
          </button>
        </div>
      </motion.div>
    </div>
  );
};

export default UIImprovementsDemo;
