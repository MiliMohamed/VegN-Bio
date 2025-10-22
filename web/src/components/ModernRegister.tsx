import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { 
  Mail, 
  Lock, 
  Eye, 
  EyeOff, 
  User,
  ArrowRight,
  Leaf,
  CheckCircle,
  AlertCircle
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { authService } from '../services/api';
import '../styles/modern-auth.css';

const ModernRegister: React.FC = () => {
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    password: '',
    confirmPassword: '',
    role: 'CLIENT'
  });
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError('');
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    // Validation
    if (formData.password !== formData.confirmPassword) {
      setError('Les mots de passe ne correspondent pas');
      setLoading(false);
      return;
    }

    if (formData.password.length < 6) {
      setError('Le mot de passe doit contenir au moins 6 caractères');
      setLoading(false);
      return;
    }

    try {
      const response = await authService.register(formData);
      const { accessToken, role, fullName } = response.data;
      
      // Stocker les informations de l'utilisateur
      localStorage.setItem('token', accessToken);
      localStorage.setItem('userRole', role);
      localStorage.setItem('userEmail', formData.email);
      localStorage.setItem('userName', fullName);
      
      // Créer l'objet user pour le contexte
      const user = {
        email: formData.email,
        role: role,
        name: fullName
      };
      
      login(accessToken, user);
      setSuccess('Inscription réussie !');
      
      // Rediriger vers le dashboard
      setTimeout(() => {
        navigate('/app/dashboard');
      }, 1000);
      
    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur lors de l\'inscription');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modern-auth">
      <div className="auth-background">
        <div className="auth-pattern"></div>
      </div>
      
      <div className="auth-container">
        <motion.div 
          className="auth-card"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="auth-header">
            <div className="auth-logo">
              <Leaf className="logo-icon" />
              <span className="logo-text">VEG'N BIO</span>
            </div>
            <h1 className="auth-title">Inscription</h1>
            <p className="auth-subtitle">
              Créez votre compte pour accéder à nos services
            </p>
          </div>

          {error && (
            <motion.div 
              className="alert alert-error"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3 }}
            >
              <AlertCircle className="w-5 h-5" />
              {error}
            </motion.div>
          )}

          {success && (
            <motion.div 
              className="alert alert-success"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3 }}
            >
              <CheckCircle className="w-5 h-5" />
              {success}
            </motion.div>
          )}

          <form onSubmit={handleSubmit} className="auth-form">
            <div className="form-group">
              <label htmlFor="fullName" className="form-label">
                <User className="w-4 h-4" />
                Nom complet
              </label>
              <input
                type="text"
                id="fullName"
                name="fullName"
                value={formData.fullName}
                onChange={handleChange}
                className="form-input"
                placeholder="Votre nom complet"
                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="email" className="form-label">
                <Mail className="w-4 h-4" />
                Adresse email
              </label>
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                className="form-input"
                placeholder="votre@email.com"
                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="role" className="form-label">
                Type de compte
              </label>
              <select
                id="role"
                name="role"
                value={formData.role}
                onChange={handleChange}
                className="form-select"
                required
              >
                <option value="CLIENT">Client</option>
                <option value="RESTAURATEUR">Restaurateur</option>
              </select>
            </div>

            <div className="form-group">
              <label htmlFor="password" className="form-label">
                <Lock className="w-4 h-4" />
                Mot de passe
              </label>
              <div className="password-input-container">
                <input
                  type={showPassword ? 'text' : 'password'}
                  id="password"
                  name="password"
                  value={formData.password}
                  onChange={handleChange}
                  className="form-input"
                  placeholder="Votre mot de passe"
                  required
                />
                <button
                  type="button"
                  className="password-toggle"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="confirmPassword" className="form-label">
                <Lock className="w-4 h-4" />
                Confirmer le mot de passe
              </label>
              <div className="password-input-container">
                <input
                  type={showConfirmPassword ? 'text' : 'password'}
                  id="confirmPassword"
                  name="confirmPassword"
                  value={formData.confirmPassword}
                  onChange={handleChange}
                  className="form-input"
                  placeholder="Confirmez votre mot de passe"
                  required
                />
                <button
                  type="button"
                  className="password-toggle"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                >
                  {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            <div className="form-options">
              <label className="checkbox-label">
                <input type="checkbox" className="checkbox-input" required />
                <span className="checkbox-text">
                  J'accepte les{' '}
                  <a href="#" className="terms-link">conditions d'utilisation</a>
                </span>
              </label>
            </div>

            <button 
              type="submit" 
              className={`btn btn-primary btn-lg ${loading ? 'loading' : ''}`}
              disabled={loading}
            >
              {loading ? (
                <div className="loading-spinner"></div>
              ) : (
                <>
                  Créer mon compte
                  <ArrowRight className="w-5 h-5" />
                </>
              )}
            </button>
          </form>

          <div className="auth-footer">
            <p className="auth-text">
              Déjà un compte ?{' '}
              <Link to="/login" className="auth-link">
                Se connecter
              </Link>
            </p>
            <Link to="/" className="back-home">
              ← Retour à l'accueil
            </Link>
          </div>
        </motion.div>

        <motion.div 
          className="auth-info"
          initial={{ opacity: 0, x: 30 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <div className="info-content">
            <h2 className="info-title">Rejoignez la communauté VegN Bio</h2>
            <p className="info-description">
              Créez votre compte et découvrez tous nos services pour une alimentation saine et durable.
            </p>
            
            <div className="info-features">
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Accès à tous nos restaurants</span>
              </div>
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Réservation en ligne</span>
              </div>
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Événements exclusifs</span>
              </div>
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Programme de fidélité</span>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default ModernRegister;