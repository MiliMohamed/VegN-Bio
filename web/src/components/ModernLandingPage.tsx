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
      title: 'Menus Végétariens & Bio',
      description: 'Nos menus sont obligatoirement végétariens, construits à partir de produits biologiques achetés auprès de producteurs franciliens.',
      color: 'text-green-500'
    },
    {
      icon: <Calendar className="w-8 h-8" />,
      title: 'Menus Changeants',
      description: 'Nos menus changent fréquemment, en fonction des propositions des producteurs locaux pour une fraîcheur optimale.',
      color: 'text-blue-500'
    },
    {
      icon: <Users className="w-8 h-8" />,
      title: 'Programme de Fidélisation',
      description: 'Les clients peuvent contribuer au développement de la chaîne en s\'inscrivant à notre programme de fidélisation.',
      color: 'text-purple-500'
    },
    {
      icon: <Heart className="w-8 h-8" />,
      title: 'Services Événementiels',
      description: 'Nous proposons toute une série de services pour vos événements : anniversaires, conférences, fêtes, séminaires.',
      color: 'text-orange-500'
    }
  ];

  const testimonials = [
    {
      name: 'Marie Dubois',
      role: 'Cliente fidèle depuis 2016',
      content: 'Je suis cliente de Veg\'n Bio depuis leur ouverture ! La qualité des produits bio et l\'engagement envers les producteurs locaux me convainquent à chaque visite.',
      rating: 5,
      avatar: 'MD'
    },
    {
      name: 'Jean Martin',
      role: 'Entrepreneur',
      content: 'J\'organise régulièrement des séminaires dans leurs restaurants. L\'espace est parfait, le service impeccable et mes clients adorent la cuisine végétarienne.',
      rating: 5,
      avatar: 'JM'
    },
    {
      name: 'Sophie Laurent',
      role: 'Nutritionniste',
      content: 'En tant que professionnelle de la nutrition, je recommande vivement Veg\'n Bio. L\'équilibre nutritionnel et la qualité bio sont exceptionnels.',
      rating: 5,
      avatar: 'SL'
    },
    {
      name: 'Pierre Moreau',
      role: 'Producteur local',
      content: 'C\'est un plaisir de travailler avec Veg\'n Bio. Ils valorisent vraiment nos produits et créent une vraie relation de confiance avec les producteurs.',
      rating: 5,
      avatar: 'PM'
    }
  ];

  const stats = [
    { number: '5', label: 'Restaurants', icon: <MapPin className="w-6 h-6" /> },
    { number: '500+', label: 'Clients fidèles', icon: <Users className="w-6 h-6" /> },
    { number: '4.9', label: 'Note moyenne', icon: <Star className="w-6 h-6" /> },
    { number: '10', label: 'Années d\'expérience', icon: <Leaf className="w-6 h-6" /> }
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
            <h2 className="section-title">Nos Engagements</h2>
            <p className="section-subtitle">
              Découvrez les valeurs qui guident Veg'n Bio depuis 2014 pour une alimentation saine et responsable.
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

      {/* About Section */}
      <section id="about" className="about-section">
        <div className="about-container">
          <motion.div 
            className="section-header"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="section-title">À propos de Veg'n Bio</h2>
            <p className="section-subtitle">
              Notre histoire et nos valeurs depuis 2014
            </p>
          </motion.div>
          
          <div className="about-content">
            <motion.div 
              className="about-text"
              initial={{ opacity: 0, x: -30 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.6 }}
              viewport={{ once: true }}
            >
              <div className="about-story">
                <h3>Notre Histoire</h3>
                <p>
                  Créée en 2014, la chaîne Veg'n Bio est une entreprise de restaurants végétariens et biologiques 
                  installés dans la capitale. La société a bâti son image autour de concepts simples :
                </p>
                <ul className="about-features">
                  <li><CheckCircle className="w-5 h-5" /> Les menus sont obligatoirement végétariens</li>
                  <li><CheckCircle className="w-5 h-5" /> Ils sont construits à partir de produits biologiques achetés auprès de producteurs franciliens</li>
                  <li><CheckCircle className="w-5 h-5" /> Ils changent fréquemment, en fonction des propositions des producteurs</li>
                  <li><CheckCircle className="w-5 h-5" /> Les clients peuvent contribuer au développement de la chaîne en s'inscrivant à un programme de fidélisation</li>
                  <li><CheckCircle className="w-5 h-5" /> La société propose toute une série de services à ses clients tout au long de l'année</li>
                </ul>
              </div>
            </motion.div>
            
            <motion.div 
              className="about-services"
              initial={{ opacity: 0, x: 30 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.6 }}
              viewport={{ once: true }}
            >
              <h3>Services Proposés</h3>
              <div className="services-grid">
                <div className="service-item">
                  <Calendar className="w-6 h-6" />
                  <div>
                    <h4>Réservation de salles</h4>
                    <p>Réservation de certaines salles de restaurants ou de restaurants entiers pour le déjeuner ou pour la soirée</p>
                  </div>
                </div>
                <div className="service-item">
                  <ShoppingCart className="w-6 h-6" />
                  <div>
                    <h4>Plateaux repas</h4>
                    <p>Plateaux repas livrés à domicile</p>
                  </div>
                </div>
                <div className="service-item">
                  <Heart className="w-6 h-6" />
                  <div>
                    <h4>Anniversaires d'enfants</h4>
                    <p>Organisation d'anniversaires d'enfants en après-midi</p>
                  </div>
                </div>
                <div className="service-item">
                  <Star className="w-6 h-6" />
                  <div>
                    <h4>Événements & animations</h4>
                    <p>Invitations à des événements et à des animations</p>
                  </div>
                </div>
                <div className="service-item">
                  <Users className="w-6 h-6" />
                  <div>
                    <h4>Rencontres producteurs</h4>
                    <p>Rencontres avec les producteurs alimentaires</p>
                  </div>
                </div>
              </div>
            </motion.div>
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
            <h2 className="cta-title">Rejoignez la communauté Veg'n Bio</h2>
            <p className="cta-subtitle">
              Découvrez une nouvelle façon de manger sainement et rejoignez notre programme de fidélisation.
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