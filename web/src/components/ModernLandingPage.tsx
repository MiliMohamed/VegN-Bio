import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { 
  Leaf, 
  Users, 
  Clock, 
  MapPin, 
  Phone, 
  Mail, 
  Star,
  ArrowRight,
  Menu,
  X,
  Heart,
  Utensils,
  Calendar,
  Truck
} from 'lucide-react';
import '../styles/modern-landing.css';

const ModernLandingPage: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const restaurants = [
    {
      id: 1,
      name: "VEG'N BIO BASTILLE",
      address: "Place de la Bastille, 75011 Paris",
      phone: "+33 1 23 45 67 01",
      features: ["Wi-Fi très haut débit", "Plateaux membres", "2 salles de réunion", "100 places"],
      hours: "Lun-Jeu: 9h-24h, Ven: 9h-1h, Sam: 9h-5h, Dim: 11h-24h"
    },
    {
      id: 2,
      name: "VEG'N BIO REPUBLIQUE",
      address: "Place de la République, 75003 Paris",
      phone: "+33 1 23 45 67 02",
      features: ["Wi-Fi très haut débit", "4 salles de réunion", "150 places", "Plateaux livrables"],
      hours: "Lun-Jeu: 9h-24h, Ven: 9h-1h, Sam: 9h-5h, Dim: 11h-24h"
    },
    {
      id: 3,
      name: "VEG'N BIO NATION",
      address: "Place de la Nation, 75011 Paris",
      phone: "+33 1 23 45 67 03",
      features: ["Wi-Fi très haut débit", "1 salle de réunion", "80 places", "Conférences mardi"],
      hours: "Lun-Jeu: 9h-24h, Ven: 9h-1h, Sam: 9h-5h, Dim: 11h-24h"
    },
    {
      id: 4,
      name: "VEG'N BIO PLACE D'ITALIE",
      address: "Place d'Italie, 75013 Paris",
      phone: "+33 1 23 45 67 04",
      features: ["Wi-Fi très haut débit", "2 salles de réunion", "70 places", "Plateaux livrables"],
      hours: "Lun-Jeu: 9h-23h, Ven: 9h-1h, Sam: 9h-5h, Dim: 11h-23h"
    },
    {
      id: 5,
      name: "VEG'N BIO BEAUBOURG",
      address: "Centre Pompidou, 75004 Paris",
      phone: "+33 1 23 45 67 05",
      features: ["Wi-Fi très haut débit", "2 salles de réunion", "70 places", "Plateaux livrables"],
      hours: "Lun-Jeu: 9h-23h, Ven: 9h-1h, Sam: 9h-5h, Dim: 11h-23h"
    }
  ];

  const services = [
    {
      icon: <Calendar className="w-8 h-8" />,
      title: "Réservation de salles",
      description: "Réservez nos salles de réunion pour vos déjeuners et soirées"
    },
    {
      icon: <Truck className="w-8 h-8" />,
      title: "Livraison plateaux",
      description: "Plateaux repas livrés à domicile ou au bureau"
    },
    {
      icon: <Heart className="w-8 h-8" />,
      title: "Anniversaires enfants",
      description: "Organisation d'anniversaires pour enfants en après-midi"
    },
    {
      icon: <Users className="w-8 h-8" />,
      title: "Événements exclusifs",
      description: "Invitations à des événements, conférences et animations"
    },
    {
      icon: <Utensils className="w-8 h-8" />,
      title: "Rencontres producteurs",
      description: "Rencontres avec nos producteurs partenaires franciliens"
    }
  ];

  return (
    <div className="modern-landing">
      {/* Header */}
      <header className="modern-landing-header">
        <div className="container">
          <div className="header-content">
            <div className="logo">
              <Leaf className="logo-icon" />
              <span className="logo-text">VEG'N BIO</span>
            </div>
            
            <nav className={`nav ${isMenuOpen ? 'nav-open' : ''}`}>
              <a href="#restaurants" className="nav-link">Nos Restaurants</a>
              <a href="#services" className="nav-link">Services</a>
              <a href="#about" className="nav-link">À Propos</a>
              <Link to="/login" className="nav-link">Connexion</Link>
              <Link to="/register" className="nav-link btn-primary">S'inscrire</Link>
            </nav>
            
            <button 
              className="menu-toggle"
              onClick={() => setIsMenuOpen(!isMenuOpen)}
            >
              {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="hero">
        <div className="hero-background">
          <div className="hero-overlay"></div>
        </div>
        <div className="container">
          <motion.div 
            className="hero-content"
            initial={{ opacity: 0, y: 50 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="hero-title">
              Bienvenue chez <span className="highlight">VEG'N BIO</span>
            </h1>
            <p className="hero-subtitle">
              Chaîne de restaurants végétariens et biologiques au cœur de Paris depuis 2014. 
              Une alimentation saine, locale et respectueuse de l'environnement.
            </p>
            <div className="hero-actions">
              <Link to="/register" className="btn btn-primary btn-lg">
                Découvrir nos restaurants
                <ArrowRight className="w-5 h-5" />
              </Link>
              <Link to="/login" className="btn btn-secondary btn-lg">
                Se connecter
              </Link>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Restaurants Section */}
      <section id="restaurants" className="restaurants-section">
        <div className="container">
          <motion.div 
            className="section-header"
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="section-title">Nos Restaurants</h2>
            <p className="section-subtitle">
              5 restaurants Veg'N Bio dans Paris pour vous accueillir
            </p>
          </motion.div>

          <div className="restaurants-grid">
            {restaurants.map((restaurant, index) => (
              <motion.div 
                key={restaurant.id}
                className="restaurant-card"
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
              >
                <div className="restaurant-header">
                  <h3 className="restaurant-name">{restaurant.name}</h3>
                  <div className="restaurant-location">
                    <MapPin className="w-4 h-4" />
                    <span>{restaurant.address}</span>
                  </div>
                </div>
                
                <div className="restaurant-features">
                  {restaurant.features.map((feature, idx) => (
                    <div key={idx} className="feature-item">
                      <Star className="w-4 h-4" />
                      <span>{feature}</span>
                    </div>
                  ))}
                </div>
                
                <div className="restaurant-info">
                  <div className="info-item">
                    <Phone className="w-4 h-4" />
                    <span>{restaurant.phone}</span>
                  </div>
                  <div className="info-item">
                    <Clock className="w-4 h-4" />
                    <span>{restaurant.hours}</span>
                  </div>
                </div>
                
                <div className="restaurant-actions">
                  <Link to="/register" className="btn btn-primary btn-sm">
                    Réserver
                  </Link>
                  <Link to="/login" className="btn btn-outline btn-sm">
                    Voir le menu
                  </Link>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Services Section */}
      <section id="services" className="services-section">
        <div className="container">
          <motion.div 
            className="section-header"
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="section-title">Nos Services</h2>
            <p className="section-subtitle">
              Des services adaptés à tous vos besoins
            </p>
          </motion.div>

          <div className="services-grid">
            {services.map((service, index) => (
              <motion.div 
                key={index}
                className="service-card"
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                whileHover={{ y: -5 }}
              >
                <div className="service-icon">
                  {service.icon}
                </div>
                <h3 className="service-title">{service.title}</h3>
                <p className="service-description">{service.description}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* About Section */}
      <section id="about" className="about-section">
        <div className="container">
          <div className="about-content">
            <motion.div 
              className="about-text"
              initial={{ opacity: 0, x: -50 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8 }}
              viewport={{ once: true }}
            >
              <h2 className="section-title">Notre Histoire</h2>
              <p className="about-description">
                Créée en 2014, Veg'N Bio est une chaîne de restaurants végétariens et biologiques 
                installés au cœur de la capitale. Depuis ses débuts, l'entreprise s'engage à promouvoir 
                une alimentation saine, locale et respectueuse de l'environnement.
              </p>
              <p className="about-description">
                Nos menus sont entièrement végétariens et composés de produits biologiques issus de 
                producteurs franciliens. Ils changent régulièrement au gré des saisons et des propositions 
                de nos partenaires agricoles.
              </p>
              <div className="about-stats">
                <div className="stat">
                  <div className="stat-number">2014</div>
                  <div className="stat-label">Année de création</div>
                </div>
                <div className="stat">
                  <div className="stat-number">5</div>
                  <div className="stat-label">Restaurants</div>
                </div>
                <div className="stat">
                  <div className="stat-number">100%</div>
                  <div className="stat-label">Bio & Végétarien</div>
                </div>
              </div>
            </motion.div>
            
            <motion.div 
              className="about-image"
              initial={{ opacity: 0, x: 50 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8 }}
              viewport={{ once: true }}
            >
              <div className="image-placeholder">
                <Utensils className="w-24 h-24" />
                <p>Image du restaurant</p>
              </div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="modern-footer">
        <div className="container">
          <div className="footer-content">
            <div className="footer-section">
              <div className="footer-logo">
                <Leaf className="logo-icon" />
                <span className="logo-text">VEG'N BIO</span>
              </div>
              <p className="footer-description">
                Chaîne de restaurants végétariens et biologiques au cœur de Paris
              </p>
            </div>
            
            <div className="footer-section">
              <h4 className="footer-title">Contact</h4>
              <div className="footer-contact">
                <div className="contact-item">
                  <Mail className="w-4 h-4" />
                  <span>contact@vegnbio.fr</span>
                </div>
                <div className="contact-item">
                  <Phone className="w-4 h-4" />
                  <span>+33 1 23 45 67 00</span>
                </div>
              </div>
            </div>
            
            <div className="footer-section">
              <h4 className="footer-title">Liens utiles</h4>
              <div className="footer-links">
                <Link to="/login" className="footer-link">Connexion</Link>
                <Link to="/register" className="footer-link">Inscription</Link>
                <a href="#restaurants" className="footer-link">Nos restaurants</a>
                <a href="#services" className="footer-link">Services</a>
              </div>
            </div>
          </div>
          
          <div className="footer-bottom">
            <p>&copy; 2024 Veg'N Bio. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default ModernLandingPage;
