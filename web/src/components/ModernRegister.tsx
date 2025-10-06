import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Eye, EyeOff, Leaf, ArrowRight, User, Lock, Mail, UserCheck } from 'lucide-react';
import { authService } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

const ModernRegister: React.FC = () => {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    fullName: '',
    role: 'CLIENT' as 'CLIENT' | 'RESTAURATEUR' | 'FOURNISSEUR' | 'ADMIN'
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    // Validation côté client
    if (formData.password !== formData.confirmPassword) {
      setError('Les mots de passe ne correspondent pas');
      return;
    }

    if (formData.password.length < 6) {
      setError('Le mot de passe doit contenir au moins 6 caractères');
      return;
    }

    setLoading(true);

    try {
      const { confirmPassword, ...registerData } = formData;
      const response = await authService.register(registerData);
      
      const userData = {
        email: formData.email,
        role: response.data.role,
        name: response.data.fullName || formData.email
      };
      
      login(response.data.accessToken, userData);
      navigate('/app/dashboard');
    } catch (err: any) {
      if (err.response?.data?.message) {
        setError(err.response.data.message);
      } else if (err.response?.status === 400) {
        setError('Email déjà utilisé ou données invalides');
      } else {
        setError('Erreur lors de la création du compte');
      }
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
                <motion.div
                  initial={{ opacity: 0, x: -50 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.8 }}
                >
                  <div className="brand-logo">
                    <Leaf className="logo-icon" />
                    <h1>VegN-Bio</h1>
                  </div>
                  <h2>Rejoignez notre communauté</h2>
                  <p>
                    Créez votre compte et découvrez une expérience gastronomique unique 
                    avec nos plats 100% végétaux et biologiques. Commencez votre voyage culinaire dès aujourd'hui.
                  </p>
                  <div className="features-list">
                    <motion.div 
                      className="feature-item"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.2 }}
                    >
                      <div className="feature-check">✓</div>
                      <span>Accès à tous nos restaurants</span>
                    </motion.div>
                    <motion.div 
                      className="feature-item"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.3 }}
                    >
                      <div className="feature-check">✓</div>
                      <span>Réservations en ligne</span>
                    </motion.div>
                    <motion.div 
                      className="feature-item"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.4 }}
                    >
                      <div className="feature-check">✓</div>
                      <span>Événements exclusifs</span>
                    </motion.div>
                    <motion.div 
                      className="feature-item"
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.5 }}
                    >
                      <div className="feature-check">✓</div>
                      <span>Marketplace bio</span>
                    </motion.div>
                  </div>
                </motion.div>
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
              <motion.div
                initial={{ opacity: 0, x: 50 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.8, delay: 0.2 }}
                className="login-form-wrapper"
              >
                <div className="login-form-header">
                  <div className="mobile-logo d-lg-none">
                    <Leaf className="logo-icon" />
                    <span>VegN-Bio</span>
                  </div>
                  <h3>Créer un compte</h3>
                  <p>Rejoignez la communauté VegN-Bio</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                  <motion.div 
                    className="form-group"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.3 }}
                  >
                    <label htmlFor="fullName" className="form-label">
                      <UserCheck className="label-icon" />
                      Nom complet
                    </label>
                    <input
                      type="text"
                      id="fullName"
                      name="fullName"
                      className="form-control"
                      value={formData.fullName}
                      onChange={handleInputChange}
                      placeholder="Jean Dupont"
                      required
                    />
                  </motion.div>

                  <motion.div 
                    className="form-group"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.4 }}
                  >
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
                      placeholder="jean.dupont@email.com"
                      required
                    />
                  </motion.div>

                  <motion.div 
                    className="form-group"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.5 }}
                  >
                    <label htmlFor="role" className="form-label">
                      <User className="label-icon" />
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
                      <option value="CLIENT">Client</option>
                      <option value="RESTAURATEUR">Restaurateur</option>
                      <option value="FOURNISSEUR">Fournisseur</option>
                      <option value="ADMIN">Administrateur</option>
                    </select>
                  </motion.div>

                  <motion.div 
                    className="form-group"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.6 }}
                  >
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
                        minLength={6}
                      />
                      <button
                        type="button"
                        className="password-toggle"
                        onClick={() => setShowPassword(!showPassword)}
                      >
                        {showPassword ? <EyeOff /> : <Eye />}
                      </button>
                    </div>
                  </motion.div>

                  <motion.div 
                    className="form-group"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.7 }}
                  >
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
                        minLength={6}
                      />
                      <button
                        type="button"
                        className="password-toggle"
                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      >
                        {showConfirmPassword ? <EyeOff /> : <Eye />}
                      </button>
                    </div>
                  </motion.div>

                  {error && (
                    <motion.div
                      initial={{ opacity: 0, y: -10 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="alert alert-danger"
                    >
                      {error}
                    </motion.div>
                  )}

                  <motion.button
                    type="submit"
                    className="btn btn-primary btn-lg w-100"
                    disabled={loading}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, delay: 0.8 }}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    {loading ? (
                      <div className="spinner-border spinner-border-sm me-2" role="status">
                        <span className="visually-hidden">Chargement...</span>
                      </div>
                    ) : (
                      <ArrowRight className="btn-icon" />
                    )}
                    {loading ? 'Création du compte...' : 'Créer mon compte'}
                  </motion.button>
                </form>

                <motion.div 
                  className="login-footer"
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.6, delay: 0.9 }}
                >
                  <p>
                    Déjà un compte ?{' '}
                    <Link to="/login" className="register-link">
                      Se connecter
                    </Link>
                  </p>
                </motion.div>
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ModernRegister;
