import React from 'react';
import { Link } from 'react-router-dom';
import { 
  Leaf, 
  Utensils, 
  Users, 
  Star, 
  ArrowRight, 
  CheckCircle,
  Globe,
  Heart,
  Zap
} from 'lucide-react';

const SimpleLandingPage: React.FC = () => {
  return (
    <div className="landing-page">
      {/* Hero Section */}
      <section className="hero-section">
        <div className="hero-background">
          <div className="hero-overlay"></div>
        </div>
        <div className="container">
          <div className="hero-content">
            <div className="hero-badge">
              <Leaf className="hero-icon" />
              <span>100% Bio & Végétarien</span>
            </div>
            
            <h1 className="hero-title">
              Découvrez l'excellence
              <span className="highlight"> végétale</span>
            </h1>
            
            <p className="hero-subtitle">
              Rejoignez la révolution culinaire avec VegN-Bio. 
              Des plats délicieux, des produits bio, une expérience unique.
            </p>
            
            <div className="hero-actions">
              <Link to="/login" className="btn btn-primary btn-lg">
                <span>Commencer maintenant</span>
                <ArrowRight className="btn-icon" />
              </Link>
              <Link to="/register" className="btn btn-outline-light btn-lg">
                Créer un compte
              </Link>
            </div>
          </div>
        </div>
        
        <div className="hero-stats">
          <div className="container">
            <div className="row">
              <div className="col-md-3 col-6">
                <div className="stat-item">
                  <div className="stat-number">50+</div>
                  <div className="stat-label">Restaurants</div>
                </div>
              </div>
              <div className="col-md-3 col-6">
                <div className="stat-item">
                  <div className="stat-number">1000+</div>
                  <div className="stat-label">Plats bio</div>
                </div>
              </div>
              <div className="col-md-3 col-6">
                <div className="stat-item">
                  <div className="stat-number">25k+</div>
                  <div className="stat-label">Clients</div>
                </div>
              </div>
              <div className="col-md-3 col-6">
                <div className="stat-item">
                  <div className="stat-number">4.9</div>
                  <div className="stat-label">Note moyenne</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="features-section">
        <div className="container">
          <div className="section-header text-center">
            <h2 className="section-title">Pourquoi choisir VegN-Bio ?</h2>
            <p className="section-subtitle">
              Une plateforme complète pour la gastronomie végétale moderne
            </p>
          </div>

          <div className="row g-4">
            <div className="col-lg-4 col-md-6">
              <div className="feature-card">
                <div className="feature-icon">
                  <Utensils />
                </div>
                <h3>Menus Innovants</h3>
                <p>Découvrez des créations culinaires uniques, 100% végétales et délicieuses.</p>
              </div>
            </div>
            
            <div className="col-lg-4 col-md-6">
              <div className="feature-card">
                <div className="feature-icon">
                  <Leaf />
                </div>
                <h3>Produits Bio</h3>
                <p>Ingrédients sélectionnés avec soin, issus de l'agriculture biologique.</p>
              </div>
            </div>
            
            <div className="col-lg-4 col-md-6">
              <div className="feature-card">
                <div className="feature-icon">
                  <Users />
                </div>
                <h3>Communauté</h3>
                <p>Rejoignez une communauté passionnée par la cuisine végétale.</p>
              </div>
            </div>
            
            <div className="col-lg-4 col-md-6">
              <div className="feature-card">
                <div className="feature-icon">
                  <Globe />
                </div>
                <h3>Écologique</h3>
                <p>Contribuez à un mode de vie plus durable et respectueux de l'environnement.</p>
              </div>
            </div>
            
            <div className="col-lg-4 col-md-6">
              <div className="feature-card">
                <div className="feature-icon">
                  <Zap />
                </div>
                <h3>Innovation</h3>
                <p>Technologie de pointe pour une expérience utilisateur exceptionnelle.</p>
              </div>
            </div>
            
            <div className="col-lg-4 col-md-6">
              <div className="feature-card">
                <div className="feature-icon">
                  <Heart />
                </div>
                <h3>Passion</h3>
                <p>Une équipe passionnée dédiée à l'excellence culinaire végétale.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="cta-section">
        <div className="container">
          <div className="cta-content text-center">
            <h2>Prêt à commencer votre voyage culinaire ?</h2>
            <p>Rejoignez VegN-Bio dès aujourd'hui et découvrez un nouveau monde de saveurs.</p>
            <div className="cta-actions">
              <Link to="/login" className="btn btn-primary btn-lg">
                <span>Se connecter</span>
                <ArrowRight className="btn-icon" />
              </Link>
              <Link to="/register" className="btn btn-outline-primary btn-lg">
                S'inscrire gratuitement
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="footer">
        <div className="container">
          <div className="row">
            <div className="col-lg-4">
              <div className="footer-brand">
                <Leaf className="footer-logo" />
                <h3>VegN-Bio</h3>
                <p>La révolution culinaire végétale commence ici.</p>
              </div>
            </div>
            <div className="col-lg-2 col-md-6">
              <div className="footer-links">
                <h4>Produit</h4>
                <ul>
                  <li><Link to="/features">Fonctionnalités</Link></li>
                  <li><Link to="/pricing">Tarifs</Link></li>
                  <li><Link to="/demo">Démo</Link></li>
                </ul>
              </div>
            </div>
            <div className="col-lg-2 col-md-6">
              <div className="footer-links">
                <h4>Support</h4>
                <ul>
                  <li><Link to="/help">Aide</Link></li>
                  <li><Link to="/contact">Contact</Link></li>
                  <li><Link to="/faq">FAQ</Link></li>
                </ul>
              </div>
            </div>
            <div className="col-lg-2 col-md-6">
              <div className="footer-links">
                <h4>Légal</h4>
                <ul>
                  <li><Link to="/privacy">Confidentialité</Link></li>
                  <li><Link to="/terms">Conditions</Link></li>
                  <li><Link to="/cookies">Cookies</Link></li>
                </ul>
              </div>
            </div>
            <div className="col-lg-2 col-md-6">
              <div className="footer-links">
                <h4>Suivez-nous</h4>
                <div className="social-links">
                  <a href="#" className="social-link">
                    <i className="fab fa-facebook"></i>
                  </a>
                  <a href="#" className="social-link">
                    <i className="fab fa-twitter"></i>
                  </a>
                  <a href="#" className="social-link">
                    <i className="fab fa-instagram"></i>
                  </a>
                </div>
              </div>
            </div>
          </div>
          <div className="footer-bottom">
            <p>&copy; 2024 VegN-Bio. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default SimpleLandingPage;
