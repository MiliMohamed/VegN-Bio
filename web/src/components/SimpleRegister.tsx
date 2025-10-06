import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Eye, EyeOff, Leaf, ArrowRight, User, Lock, Mail, UserCheck } from 'lucide-react';
import { authService } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

const SimpleRegister: React.FC = () => {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    fullName: '',
    role: 'CLIENT' as 'CLIENT' | 'RESTAURATEUR' | 'FOURNISSEUR'
  });
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const validateForm = () => {
    if (!formData.email || !formData.password || !formData.fullName) {
      setError('Tous les champs sont obligatoires');
      return false;
    }

    if (formData.password !== formData.confirmPassword) {
      setError('Les mots de passe ne correspondent pas');
      return false;
    }

    if (formData.password.length < 6) {
      setError('Le mot de passe doit contenir au moins 6 caractères');
      return false;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(formData.email)) {
      setError('Veuillez entrer une adresse email valide');
      return false;
    }

    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!validateForm()) {
      return;
    }

    setLoading(true);

    try {
      const response = await authService.register({
        email: formData.email,
        password: formData.password,
        fullName: formData.fullName,
        role: formData.role
      });
      
      const userData = {
        email: formData.email,
        role: response.data.role,
        name: formData.fullName
      };
      
      login(response.data.accessToken, userData);
      navigate('/app/dashboard');
    } catch (err: any) {
      if (err.response?.data?.message) {
        setError(err.response.data.message);
      } else if (err.response?.status === 409) {
        setError('Cette adresse email est déjà utilisée');
      } else {
        setError('Erreur lors de la création du compte');
      }
    } finally {
      setLoading(false);
    }
  };

  const roleOptions = [
    { value: 'CLIENT', label: 'Client', description: 'Découvrir et commander des plats végétaux' },
    { value: 'RESTAURATEUR', label: 'Restaurateur', description: 'Gérer votre restaurant et vos menus' },
    { value: 'FOURNISSEUR', label: 'Fournisseur', description: 'Proposer vos produits biologiques' }
  ];

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
                <h2>Rejoignez la révolution verte</h2>
                <p>
                  Créez votre compte et participez à la transformation de l'alimentation 
                  vers un mode de vie plus sain et durable.
                </p>
                <div className="features-list">
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Accès à tous les restaurants partenaires</span>
                  </div>
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Réservation d'événements exclusifs</span>
                  </div>
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Marketplace de produits bio</span>
                  </div>
                  <div className="feature-item">
                    <div className="feature-check">✓</div>
                    <span>Communauté engagée</span>
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

          {/* Right Side - Register Form */}
          <div className="col-lg-6">
            <div className="login-form-container">
              <div className="login-form-wrapper">
                <div className="login-form-header">
                  <div className="mobile-logo d-lg-none">
                    <Leaf className="logo-icon" />
                    <span>VegN-Bio</span>
                  </div>
                  <h3>Créer un compte</h3>
                  <p>Rejoignez la communauté VegN-Bio</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                  <div className="form-group">
                    <label htmlFor="fullName" className="form-label">
                      <User className="label-icon" />
                      Nom complet
                    </label>
                    <input
                      type="text"
                      id="fullName"
                      name="fullName"
                      className="form-control"
                      value={formData.fullName}
                      onChange={handleInputChange}
                      placeholder="Votre nom complet"
                      required
                    />
                  </div>

                  <div className="form-group">
                    <label htmlFor="email" className="form-label">
                      <Mail className="label-icon" />
                      Adresse email
                    </label>
                    <input
                      type="email"
                      id="email"
                      name="email"
                      className="form-control"
                      value={formData.email}
                      onChange={handleInputChange}
                      placeholder="votre@email.com"
                      required
                    />
                  </div>

                  <div className="form-group">
                    <label htmlFor="role" className="form-label">
                      <UserCheck className="label-icon" />
                      Type de compte
                    </label>
                    <select
                      id="role"
                      name="role"
                      className="form-control"
                      value={formData.role}
                      onChange={handleInputChange}
                      required
                    >
                      {roleOptions.map(option => (
                        <option key={option.value} value={option.value}>
                          {option.label} - {option.description}
                        </option>
                      ))}
                    </select>
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
                        name="password"
                        className="form-control"
                        value={formData.password}
                        onChange={handleInputChange}
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

                  <div className="form-group">
                    <label htmlFor="confirmPassword" className="form-label">
                      <Lock className="label-icon" />
                      Confirmer le mot de passe
                    </label>
                    <div className="password-input-group">
                      <input
                        type={showConfirmPassword ? 'text' : 'password'}
                        id="confirmPassword"
                        name="confirmPassword"
                        className="form-control"
                        value={formData.confirmPassword}
                        onChange={handleInputChange}
                        placeholder="••••••••"
                        required
                      />
                      <button
                        type="button"
                        className="password-toggle"
                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      >
                        {showConfirmPassword ? <EyeOff /> : <Eye />}
                      </button>
                    </div>
                  </div>

                  <div className="form-options">
                    <div className="form-check">
                      <input
                        type="checkbox"
                        className="form-check-input"
                        id="terms"
                        required
                      />
                      <label className="form-check-label" htmlFor="terms">
                        J'accepte les{' '}
                        <Link to="/terms" className="terms-link">
                          conditions d'utilisation
                        </Link>{' '}
                        et la{' '}
                        <Link to="/privacy" className="terms-link">
                          politique de confidentialité
                        </Link>
                      </label>
                    </div>
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
                    {loading ? 'Création du compte...' : 'Créer mon compte'}
                  </button>
                </form>

                <div className="login-footer">
                  <p>
                    Déjà un compte ?{' '}
                    <Link to="/login" className="register-link">
                      Se connecter
                    </Link>
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SimpleRegister;