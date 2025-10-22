import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { 
  Leaf,
  ArrowRight,
  CheckCircle,
  Star,
  Users,
  MapPin,
  Utensils,
  Calendar,
  MessageCircle,
  Heart,
  ShoppingCart,
  Play,
  Menu,
  X,
  ChevronDown
} from 'lucide-react';

const ModernLandingPage: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [activeTestimonial, setActiveTestimonial] = useState(0);

  const features = [
    {
      icon: <Utensils className="w-8 h-8" />,
      title: 'Menus Saisonniers',
      description: 'Découvrez nos plats végétariens et biologiques préparés avec des ingrédients frais et locaux.',
      color: 'text-green-500'
    },
    {
      icon: <Calendar className="w-8 h-8" />,
      title: 'Événements',
      description: 'Participez à nos conférences, ateliers culinaires et événements sur l\'alimentation durable.',
      color: 'text-blue-500'
    },
    {
      icon: <MapPin className="w-8 h-8" />,
      title: '3 Restaurants',
      description: 'Retrouvez-nous dans nos trois établissements à Paris : République, Bastille et Nation.',
      color: 'text-purple-500'
    },
    {
      icon: <MessageCircle className="w-8 h-8" />,
      title: 'Assistant IA',
      description: 'Notre chatbot intelligent vous aide à choisir vos plats selon vos préférences et allergies.',
      color: 'text-orange-500'
    }
  ];

  const testimonials = [
    {
      name: 'Marie Dubois',
      role: 'Cliente fidèle',
      content: 'Les plats sont délicieux et respectent parfaitement mes convictions végétariennes. L\'ambiance est chaleureuse et le service impeccable.',
      rating: 5,
      avatar: 'MD'
    },
    {
      name: 'Jean Martin',
      role: 'Entrepreneur',
      content: 'J\'organise régulièrement des déjeuners d\'affaires ici. L\'espace est parfait et la qualité des produits exceptionnelle.',
      rating: 5,
      avatar: 'JM'
    },
    {
      name: 'Sophie Laurent',
      role: 'Nutritionniste',
      content: 'En tant que professionnelle de la nutrition, je recommande vivement VegN Bio. L\'équilibre nutritionnel est parfait.',
      rating: 5,
      avatar: 'SL'
    }
  ];

  const stats = [
    { number: '3', label: 'Restaurants', icon: <MapPin className="w-6 h-6" /> },
    { number: '156', label: 'Clients satisfaits', icon: <Users className="w-6 h-6" /> },
    { number: '4.8', label: 'Note moyenne', icon: <Star className="w-6 h-6" /> },
    { number: '12', label: 'Années d\'expérience', icon: <Leaf className="w-6 h-6" /> }
  ];

  return (
    <div className="modern-landing">
      {/* Navigation */}
      <nav className="landing-nav">
        <div className="nav-container">
          <Link to="/" className="nav-logo">
            <Leaf className="w-8 h-8" />
            <span>VEG'N BIO</span>
          </Link>
          
          <div className={`nav-menu ${isMenuOpen ? 'open' : ''}`}>
            <Link to="#features" className="nav-link">Fonctionnalités</Link>
            <Link to="#testimonials" className="nav-link">Témoignages</Link>
            <Link to="#about" className="nav-link">À propos</Link>
            <Link to="/login" className="nav-link">Connexion</Link>
            <Link to="/register" className="btn btn-primary">
              Créer un compte
            </Link>
          </div>
          
          <button 
            className="nav-toggle"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            {isMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="hero-section">
        <div className="hero-container">
          <motion.div 
            className="hero-content"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="hero-title">
              Bienvenue chez <span className="text-green-500">VegN Bio</span>
            </h1>
            <p className="hero-subtitle">
              Découvrez une nouvelle façon de manger sainement avec nos restaurants végétariens et biologiques. 
              Des plats délicieux, des ingrédients frais et une approche respectueuse de l'environnement.
            </p>
            <div className="hero-actions">
              <Link to="/register" className="btn btn-primary btn-lg">
                Commencer maintenant
                <ArrowRight className="w-5 h-5" />
              </Link>
              <button className="btn btn-secondary btn-lg">
                <Play className="w-5 h-5" />
                Voir la vidéo
              </button>
            </div>
          </motion.div>
          
          <motion.div 
            className="hero-image"
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            <div className="hero-card">
              <div className="card-header">
                <div className="card-avatar">
                  <Leaf className="w-6 h-6" />
                </div>
                <div className="card-info">
                  <div className="card-title">Menu du jour</div>
                  <div className="card-subtitle">République</div>
                </div>
                <div className="card-status">
                  <div className="status-dot"></div>
                  Ouvert
                </div>
              </div>
              <div className="card-content">
                <div className="menu-item">
                  <div className="item-name">Salade de quinoa bio</div>
                  <div className="item-price">12€</div>
                </div>
                <div className="menu-item">
                  <div className="item-name">Curry de légumes</div>
                  <div className="item-price">14€</div>
                </div>
                <div className="menu-item">
                  <div className="item-name">Tarte aux légumes</div>
                  <div className="item-price">11€</div>
                </div>
              </div>
            </div>
          </motion.div>
        </div>
        
        {/* Scroll Indicator */}
        <motion.div 
          className="scroll-indicator"
          animate={{ y: [0, 10, 0] }}
          transition={{ duration: 2, repeat: Infinity }}
        >
          <ChevronDown className="w-6 h-6" />
        </motion.div>
      </section>

      {/* Stats Section */}
      <section className="stats-section">
        <div className="stats-container">
          {stats.map((stat, index) => (
            <motion.div 
              key={stat.label}
              className="stat-item"
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              viewport={{ once: true }}
            >
              <div className="stat-icon">{stat.icon}</div>
              <div className="stat-number">{stat.number}</div>
              <div className="stat-label">{stat.label}</div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="features-section">
        <div className="features-container">
          <motion.div 
            className="section-header"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="section-title">Pourquoi choisir VegN Bio ?</h2>
            <p className="section-subtitle">
              Découvrez les avantages qui font de nous votre choix numéro 1 pour une alimentation saine et responsable.
            </p>
          </motion.div>
          
          <div className="features-grid">
            {features.map((feature, index) => (
              <motion.div 
                key={feature.title}
                className="feature-card"
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                whileHover={{ y: -5 }}
              >
                <div className={`feature-icon ${feature.color}`}>
                  {feature.icon}
                </div>
                <h3 className="feature-title">{feature.title}</h3>
                <p className="feature-description">{feature.description}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section id="testimonials" className="testimonials-section">
        <div className="testimonials-container">
          <motion.div 
            className="section-header"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="section-title">Ce que disent nos clients</h2>
            <p className="section-subtitle">
              Découvrez les témoignages de nos clients satisfaits qui ont choisi VegN Bio.
            </p>
          </motion.div>
          
          <div className="testimonials-slider">
            {testimonials.map((testimonial, index) => (
              <motion.div 
                key={testimonial.name}
                className={`testimonial-card ${activeTestimonial === index ? 'active' : ''}`}
                initial={{ opacity: 0, x: 50 }}
                whileInView={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
              >
                <div className="testimonial-content">
                  <div className="testimonial-rating">
                    {[...Array(testimonial.rating)].map((_, i) => (
                      <Star key={i} className="w-5 h-5 fill-current text-yellow-400" />
                    ))}
                  </div>
                  <p className="testimonial-text">"{testimonial.content}"</p>
                  <div className="testimonial-author">
                    <div className="author-avatar">{testimonial.avatar}</div>
                    <div className="author-info">
                      <div className="author-name">{testimonial.name}</div>
                      <div className="author-role">{testimonial.role}</div>
                    </div>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
          
          <div className="testimonial-controls">
            {testimonials.map((_, index) => (
              <button
                key={index}
                className={`control-dot ${activeTestimonial === index ? 'active' : ''}`}
                onClick={() => setActiveTestimonial(index)}
              />
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="cta-section">
        <div className="cta-container">
          <motion.div 
            className="cta-content"
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="cta-title">Prêt à commencer votre aventure culinaire ?</h2>
            <p className="cta-subtitle">
              Rejoignez la communauté VegN Bio et découvrez une nouvelle façon de manger sainement.
            </p>
            <div className="cta-actions">
              <Link to="/register" className="btn btn-primary btn-lg">
                Créer mon compte
                <ArrowRight className="w-5 h-5" />
              </Link>
              <Link to="/login" className="btn btn-secondary btn-lg">
                Se connecter
              </Link>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Footer */}
      <footer className="landing-footer">
        <div className="footer-container">
          <div className="footer-content">
            <div className="footer-brand">
              <Link to="/" className="footer-logo">
                <Leaf className="w-6 h-6" />
                <span>VEG'N BIO</span>
              </Link>
              <p className="footer-description">
                Restaurants végétariens et biologiques depuis 2014. 
                Une approche respectueuse de l'environnement et de votre santé.
              </p>
            </div>
            
            <div className="footer-links">
              <div className="link-group">
                <h4 className="link-title">Restaurants</h4>
                <Link to="#" className="footer-link">République</Link>
                <Link to="#" className="footer-link">Bastille</Link>
                <Link to="#" className="footer-link">Nation</Link>
              </div>
              
              <div className="link-group">
                <h4 className="link-title">Services</h4>
                <Link to="#" className="footer-link">Menus</Link>
                <Link to="#" className="footer-link">Événements</Link>
                <Link to="#" className="footer-link">Réservations</Link>
              </div>
              
              <div className="link-group">
                <h4 className="link-title">Support</h4>
                <Link to="#" className="footer-link">Contact</Link>
                <Link to="#" className="footer-link">FAQ</Link>
                <Link to="#" className="footer-link">Aide</Link>
              </div>
            </div>
          </div>
          
          <div className="footer-bottom">
            <p className="footer-copyright">
              © 2024 VegN Bio. Tous droits réservés.
            </p>
            <div className="footer-social">
              <Link to="#" className="social-link">
                <Heart className="w-5 h-5" />
              </Link>
              <Link to="#" className="social-link">
                <ShoppingCart className="w-5 h-5" />
              </Link>
              <Link to="#" className="social-link">
                <MessageCircle className="w-5 h-5" />
              </Link>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default ModernLandingPage;