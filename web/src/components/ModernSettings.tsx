import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Settings, 
  Moon, 
  Sun, 
  Monitor, 
  Bell, 
  Shield, 
  Globe, 
  Palette,
  Save,
  RotateCcw,
  Eye,
  EyeOff,
  Volume2,
  VolumeX,
  Wifi,
  WifiOff,
  AlertTriangle
} from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';
import AllergenManager from './AllergenManager';
import '../styles/settings-styles.css';

import '../styles/allergen-manager.css';

const ModernSettings: React.FC = () => {
  const { theme, actualTheme, setTheme, toggleTheme } = useTheme();
  const [settings, setSettings] = useState({
    notifications: {
      email: true,
      push: true,
      sms: false,
      marketing: false
    },
    privacy: {
      profilePublic: true,
      showEmail: false,
      showPhone: false,
      dataSharing: false
    },
    display: {
      language: 'fr',
      currency: 'EUR',
      timezone: 'Europe/Paris',
      dateFormat: 'DD/MM/YYYY'
    },
    audio: {
      soundEnabled: true,
      volume: 70,
      notificationsSound: true
    },
    accessibility: {
      highContrast: false,
      largeText: false,
      reducedMotion: false
    }
  });

  const handleSave = () => {
    // TODO: Implémenter la sauvegarde des paramètres
    console.log('Sauvegarde des paramètres:', settings);
    alert('Paramètres sauvegardés avec succès !');
  };

  const handleReset = () => {
    if (window.confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres ?')) {
      // TODO: Implémenter la réinitialisation
      alert('Paramètres réinitialisés !');
    }
  };

  const updateSettings = (section: string, key: string, value: any) => {
    setSettings(prev => ({
      ...prev,
      [section]: {
        ...prev[section as keyof typeof prev],
        [key]: value
      }
    }));
  };

  const themeOptions = [
    { value: 'light', label: 'Clair', icon: <Sun className="w-4 h-4" /> },
    { value: 'dark', label: 'Sombre', icon: <Moon className="w-4 h-4" /> },
    { value: 'system', label: 'Système', icon: <Monitor className="w-4 h-4" /> }
  ];

  const languageOptions = [
    { value: 'fr', label: 'Français' },
    { value: 'en', label: 'English' },
    { value: 'es', label: 'Español' },
    { value: 'de', label: 'Deutsch' }
  ];

  const currencyOptions = [
    { value: 'EUR', label: 'Euro (€)' },
    { value: 'USD', label: 'Dollar ($)' },
    { value: 'GBP', label: 'Livre (£)' }
  ];

  return (
    <div className="modern-settings">
      <div className="settings-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Paramètres</h1>
          <p className="page-subtitle">
            Personnalisez votre expérience VegN-Bio
          </p>
        </motion.div>
      </div>

      <div className="settings-content">
        {/* Thème */}
        <motion.div
          className="settings-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.1 }}
        >
          <div className="section-header">
            <Palette className="w-5 h-5" />
            <h2>Apparence</h2>
          </div>
          
          <div className="settings-card">
            <div className="setting-item">
              <div className="setting-info">
                <h3>Thème</h3>
                <p>Choisissez votre thème préféré</p>
              </div>
              <div className="theme-options">
                {themeOptions.map((option) => (
                  <button
                    key={option.value}
                    className={`theme-option ${theme === option.value ? 'active' : ''}`}
                    onClick={() => setTheme(option.value as any)}
                  >
                    {option.icon}
                    <span>{option.label}</span>
                  </button>
                ))}
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Mode sombre rapide</h3>
                <p>Basculer rapidement entre clair et sombre</p>
              </div>
              <button 
                className="theme-toggle"
                onClick={toggleTheme}
              >
                {actualTheme === 'dark' ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
              </button>
            </div>
          </div>
        </motion.div>

        {/* Gestion des Allergènes */}
        <motion.div
          className="settings-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.15 }}
        >
          <div className="section-header">
            <AlertTriangle className="w-5 h-5" />
            <h2>Gestion des Allergènes</h2>
          </div>
          
          <div className="settings-card">
            <div className="setting-item">
              <div className="setting-info">
                <h3>Allergies Alimentaires</h3>
                <p>Configurez vos allergies pour filtrer automatiquement les plats dangereux</p>
              </div>
              <AllergenManager 
                onPreferencesChange={(preferences) => {
                  console.log('Préférences d\'allergènes mises à jour:', preferences);
                }}
                className="allergen-manager-settings"
              />
            </div>
            
            <div className="allergen-info-box">
              <div className="info-header">
                <Shield className="w-4 h-4" />
                <h4>Pourquoi configurer mes allergies ?</h4>
              </div>
              <ul className="info-list">
                <li>🔍 <strong>Filtrage automatique</strong> : Les plats contenant vos allergènes sont automatiquement exclus</li>
                <li>⚠️ <strong>Alertes de sécurité</strong> : Mise en évidence des plats potentiellement dangereux</li>
                <li>💾 <strong>Sauvegarde persistante</strong> : Vos préférences sont sauvegardées automatiquement</li>
                <li>📱 <strong>Disponible partout</strong> : Configuration accessible depuis tous vos appareils</li>
              </ul>
            </div>
          </div>
        </motion.div>

        {/* Notifications */}
        <motion.div
          className="settings-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <div className="section-header">
            <Bell className="w-5 h-5" />
            <h2>Notifications</h2>
          </div>
          
          <div className="settings-card">
            <div className="setting-item">
              <div className="setting-info">
                <h3>Notifications par email</h3>
                <p>Recevoir les nouvelles et promotions par email</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="email-notifications"
                  checked={settings.notifications.email}
                  onChange={(e) => updateSettings('notifications', 'email', e.target.checked)}
                />
                <label htmlFor="email-notifications">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Notifications push</h3>
                <p>Alertes pour les réservations et commandes</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="push-notifications"
                  checked={settings.notifications.push}
                  onChange={(e) => updateSettings('notifications', 'push', e.target.checked)}
                />
                <label htmlFor="push-notifications">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Notifications SMS</h3>
                <p>Alertes importantes par SMS</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="sms-notifications"
                  checked={settings.notifications.sms}
                  onChange={(e) => updateSettings('notifications', 'sms', e.target.checked)}
                />
                <label htmlFor="sms-notifications">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Marketing</h3>
                <p>Recevoir les offres promotionnelles</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="marketing-notifications"
                  checked={settings.notifications.marketing}
                  onChange={(e) => updateSettings('notifications', 'marketing', e.target.checked)}
                />
                <label htmlFor="marketing-notifications">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Confidentialité */}
        <motion.div
          className="settings-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
        >
          <div className="section-header">
            <Shield className="w-5 h-5" />
            <h2>Confidentialité</h2>
          </div>
          
          <div className="settings-card">
            <div className="setting-item">
              <div className="setting-info">
                <h3>Profil public</h3>
                <p>Rendre votre profil visible aux autres utilisateurs</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="profile-public"
                  checked={settings.privacy.profilePublic}
                  onChange={(e) => updateSettings('privacy', 'profilePublic', e.target.checked)}
                />
                <label htmlFor="profile-public">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Afficher l'email</h3>
                <p>Permettre aux autres de voir votre adresse email</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="show-email"
                  checked={settings.privacy.showEmail}
                  onChange={(e) => updateSettings('privacy', 'showEmail', e.target.checked)}
                />
                <label htmlFor="show-email">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Partage de données</h3>
                <p>Autoriser l'utilisation des données pour améliorer le service</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="data-sharing"
                  checked={settings.privacy.dataSharing}
                  onChange={(e) => updateSettings('privacy', 'dataSharing', e.target.checked)}
                />
                <label htmlFor="data-sharing">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Préférences d'affichage */}
        <motion.div
          className="settings-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
        >
          <div className="section-header">
            <Globe className="w-5 h-5" />
            <h2>Préférences</h2>
          </div>
          
          <div className="settings-card">
            <div className="setting-item">
              <div className="setting-info">
                <h3>Langue</h3>
                <p>Choisissez votre langue préférée</p>
              </div>
              <select
                className="setting-select"
                value={settings.display.language}
                onChange={(e) => updateSettings('display', 'language', e.target.value)}
              >
                {languageOptions.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Devise</h3>
                <p>Monnaie pour l'affichage des prix</p>
              </div>
              <select
                className="setting-select"
                value={settings.display.currency}
                onChange={(e) => updateSettings('display', 'currency', e.target.value)}
              >
                {currencyOptions.map((option) => (
                  <option key={option.value} value={option.value}>
                    {option.label}
                  </option>
                ))}
              </select>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Format de date</h3>
                <p>Comment afficher les dates</p>
              </div>
              <select
                className="setting-select"
                value={settings.display.dateFormat}
                onChange={(e) => updateSettings('display', 'dateFormat', e.target.value)}
              >
                <option value="DD/MM/YYYY">DD/MM/YYYY</option>
                <option value="MM/DD/YYYY">MM/DD/YYYY</option>
                <option value="YYYY-MM-DD">YYYY-MM-DD</option>
              </select>
            </div>
          </div>
        </motion.div>

        {/* Audio */}
        <motion.div
          className="settings-section"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.5 }}
        >
          <div className="section-header">
            <Volume2 className="w-5 h-5" />
            <h2>Audio</h2>
          </div>
          
          <div className="settings-card">
            <div className="setting-item">
              <div className="setting-info">
                <h3>Son activé</h3>
                <p>Activer les sons de l'application</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="sound-enabled"
                  checked={settings.audio.soundEnabled}
                  onChange={(e) => updateSettings('audio', 'soundEnabled', e.target.checked)}
                />
                <label htmlFor="sound-enabled">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Volume</h3>
                <p>Niveau de volume général</p>
              </div>
              <div className="volume-control">
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={settings.audio.volume}
                  onChange={(e) => updateSettings('audio', 'volume', parseInt(e.target.value))}
                  className="volume-slider"
                />
                <span className="volume-value">{settings.audio.volume}%</span>
              </div>
            </div>

            <div className="setting-item">
              <div className="setting-info">
                <h3>Son des notifications</h3>
                <p>Jouer un son pour les notifications</p>
              </div>
              <div className="toggle-switch">
                <input
                  type="checkbox"
                  id="notifications-sound"
                  checked={settings.audio.notificationsSound}
                  onChange={(e) => updateSettings('audio', 'notificationsSound', e.target.checked)}
                />
                <label htmlFor="notifications-sound">
                  <span className="toggle-slider"></span>
                </label>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Actions */}
        <motion.div
          className="settings-actions"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
        >
          <button className="btn btn-primary" onClick={handleSave}>
            <Save className="w-4 h-4" />
            Sauvegarder
          </button>
          <button className="btn btn-secondary" onClick={handleReset}>
            <RotateCcw className="w-4 h-4" />
            Réinitialiser
          </button>
        </motion.div>
      </div>
    </div>
  );
};

export default ModernSettings;
