import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { 
  Mail, 
  Lock, 
  Eye, 
  EyeOff, 
  ArrowRight,
  Leaf,
  CheckCircle,
  AlertCircle
} from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { authService } from '../services/api';
import '../styles/modern-auth.css';

const ModernLogin: React.FC = () => {
  const [formData, setFormData] = useState({
    email: '',
    password: ''
  });
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
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

    try {
      const response = await authService.login(formData.email, formData.password);
      const { token, user } = response.data;
      
      // Stocker les informations de l'utilisateur
      localStorage.setItem('token', token);
      localStorage.setItem('userRole', user.role);
      localStorage.setItem('userEmail', user.email);
      localStorage.setItem('userName', user.fullName || user.email);
      
      login(token, user);
      setSuccess('Connexion réussie !');
      
      // Rediriger vers le dashboard
      setTimeout(() => {
        navigate('/app/dashboard');
      }, 1000);
      
    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur de connexion');
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
            <h1 className="auth-title">Connexion</h1>
            <p className="auth-subtitle">
              Accédez à votre espace de gestion des restaurants
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

            <div className="form-options">
              <label className="checkbox-label">
                <input type="checkbox" className="checkbox-input" />
                <span className="checkbox-text">Se souvenir de moi</span>
              </label>
              <a href="#" className="forgot-password">Mot de passe oublié ?</a>
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
                  Se connecter
                  <ArrowRight className="w-5 h-5" />
                </>
              )}
            </button>
          </form>

          <div className="auth-footer">
            <p className="auth-text">
              Pas encore de compte ?{' '}
              <Link to="/register" className="auth-link">
                Créer un compte
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
            <h2 className="info-title">Bienvenue chez VegN Bio</h2>
            <p className="info-description">
              Gérez facilement vos restaurants végétariens et biologiques depuis votre espace personnel.
            </p>
            
            <div className="info-features">
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Gestion des menus saisonniers</span>
              </div>
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Réservation de salles de réunion</span>
              </div>
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Organisation d'événements</span>
              </div>
              <div className="feature-item">
                <CheckCircle className="w-5 h-5" />
                <span>Suivi des avis clients</span>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default ModernLogin;