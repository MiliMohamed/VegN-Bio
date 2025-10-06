import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Eye, EyeOff, Leaf, ArrowRight, User, Lock } from 'lucide-react';
import { authService } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

const SimpleLogin: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const response = await authService.login(email, password);
      
      const userData = {
        email: email,
        role: response.data.role,
        name: response.data.fullName || email
      };
      
      login(response.data.accessToken, userData);
      navigate('/app/dashboard');
    } catch (err: any) {
      setError('Email ou mot de passe incorrect');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <div className="row g-0 min-vh-100">
          {/* Left Side - Branding */}
          <div className="col-lg-6 d-none d-lg-flex">
            <div className="login-branding">
              <div className="branding-content">
                <div className="brand-logo">
                  <Leaf className="logo-icon" />
                  <h1>VegN-Bio</h1>
                </div>
                <h2>Bienvenue dans l'avenir culinaire</h2>
                <p>
                  Découvrez une expérience gastronomique unique avec nos plats 
                  100% végétaux et biologiques. Rejoignez la révolution verte.
                </p>
                <div className="features-list">
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Produits 100% biologiques</span>
                  </div>
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Recettes innovantes</span>
                  </div>
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Communauté passionnée</span>
                  </div>
                </div>
              </div>
              <div className="branding-decoration">
                <div className="decoration-circle decoration-1"></div>
                <div className="decoration-circle decoration-2"></div>
                <div className="decoration-circle decoration-3"></div>
              </div>
            </div>
          </div>

          {/* Right Side - Login Form */}
          <div className="col-lg-6">
            <div className="login-form-container">
              <div className="login-form-wrapper">
                <div className="login-form-header">
                  <div className="mobile-logo d-lg-none">
                    <Leaf className="logo-icon" />
                    <span>VegN-Bio</span>
                  </div>
                  <h3>Connexion</h3>
                  <p>Connectez-vous à votre compte VegN-Bio</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                  <div className="form-group">
                    <label htmlFor="email" className="form-label">
                      <User className="label-icon" />
                      Adresse email
                    </label>
                    <input
                      type="email"
                      id="email"
                      className="form-control"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="votre@email.com"
                      required
                    />
                  </div>

                  <div className="form-group">
                    <label htmlFor="password" className="form-label">
                      <Lock className="label-icon" />
                      Mot de passe
                    </label>
                    <div className="password-input-group">
                      <input
                        type={showPassword ? 'text' : 'password'}
                        id="password"
                        className="form-control"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        placeholder="••••••••"
                        required
                      />
                      <button
                        type="button"
                        className="password-toggle"
                        onClick={() => setShowPassword(!showPassword)}
                      >
                        {showPassword ? <EyeOff /> : <Eye />}
                      </button>
                    </div>
                  </div>

                  <div className="form-options">
                    <div className="form-check">
                      <input
                        type="checkbox"
                        className="form-check-input"
                        id="remember"
                      />
                      <label className="form-check-label" htmlFor="remember">
                        Se souvenir de moi
                      </label>
                    </div>
                    <Link to="/forgot-password" className="forgot-password">
                      Mot de passe oublié ?
                    </Link>
                  </div>

                  {error && (
                    <div className="alert alert-danger">
                      {error}
                    </div>
                  )}

                  <button
                    type="submit"
                    className="btn btn-primary btn-lg w-100"
                    disabled={loading}
                  >
                    {loading ? (
                      <div className="spinner-border spinner-border-sm me-2" role="status">
                        <span className="visually-hidden">Chargement...</span>
                      </div>
                    ) : (
                      <ArrowRight className="btn-icon" />
                    )}
                    {loading ? 'Connexion...' : 'Se connecter'}
                  </button>
                </form>

                <div className="login-footer">
                  <p>
                    Pas encore de compte ?{' '}
                    <Link to="/register" className="register-link">
                      Créer un compte
                    </Link>
                  </p>
                  <div className="demo-accounts">
                    <p className="demo-title">Comptes de démonstration :</p>
                    <div className="demo-buttons">
                      <button
                        className="btn btn-outline-secondary btn-sm"
                        onClick={() => {
                          setEmail('admin@vegnbio.com');
                          setPassword('admin123');
                        }}
                      >
                        Admin
                      </button>
                      <button
                        className="btn btn-outline-secondary btn-sm"
                        onClick={() => {
                          setEmail('chef@vegnbio.com');
                          setPassword('chef123');
                        }}
                      >
                        Restaurateur
                      </button>
                      <button
                        className="btn btn-outline-secondary btn-sm"
                        onClick={() => {
                          setEmail('client@vegnbio.com');
                          setPassword('client123');
                        }}
                      >
                        Client
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SimpleLogin;
