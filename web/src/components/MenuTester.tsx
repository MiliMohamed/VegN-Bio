import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Utensils, 
  Plus, 
  TestTube,
  CheckCircle,
  XCircle,
  AlertTriangle
} from 'lucide-react';
import { menuService } from '../services/api';
import MenuForm from './MenuForm';
import MenuItemForm from './MenuItemForm';

const MenuTester: React.FC = () => {
  const [showMenuForm, setShowMenuForm] = useState(false);
  const [showMenuItemForm, setShowMenuItemForm] = useState(false);
  const [testResults, setTestResults] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  const addTestResult = (test: string, success: boolean, message: string) => {
    setTestResults(prev => [...prev, {
      id: Date.now(),
      test,
      success,
      message,
      timestamp: new Date().toLocaleTimeString()
    }]);
  };

  const testMenuCreation = async () => {
    setLoading(true);
    addTestResult('Test création menu', false, 'Test en cours...');
    
    try {
      const testMenuData = {
        title: 'Menu Test ' + new Date().toLocaleTimeString(),
        activeFrom: new Date().toISOString().split('T')[0],
        activeTo: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        restaurantId: 68
      };

      console.log('Test création menu avec:', testMenuData);
      const response = await menuService.create(testMenuData);
      console.log('Réponse création menu:', response);
      
      addTestResult('Test création menu', true, `Menu créé avec ID: ${response.data.id}`);
    } catch (error: any) {
      console.error('Erreur test création menu:', error);
      addTestResult('Test création menu', false, `Erreur: ${error.response?.data?.message || error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const testMenuItemCreation = async () => {
    setLoading(true);
    addTestResult('Test création plat', false, 'Test en cours...');
    
    try {
      const testItemData = {
        name: 'Plat Test ' + new Date().toLocaleTimeString(),
        description: 'Description du plat de test',
        priceCents: 1500, // 15.00€
        isVegan: true,
        menuId: 1
      };

      console.log('Test création plat avec:', testItemData);
      const response = await menuService.createMenuItem(testItemData);
      console.log('Réponse création plat:', response);
      
      addTestResult('Test création plat', true, `Plat créé avec ID: ${response.data.id}`);
    } catch (error: any) {
      console.error('Erreur test création plat:', error);
      addTestResult('Test création plat', false, `Erreur: ${error.response?.data?.message || error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const testMenuFetch = async () => {
    setLoading(true);
    addTestResult('Test récupération menus', false, 'Test en cours...');
    
    try {
      const response = await menuService.getMenusByRestaurant(1);
      console.log('Réponse récupération menus:', response);
      
      addTestResult('Test récupération menus', true, `${response.data.length} menus trouvés`);
    } catch (error: any) {
      console.error('Erreur test récupération menus:', error);
      addTestResult('Test récupération menus', false, `Erreur: ${error.response?.data?.message || error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const clearResults = () => {
    setTestResults([]);
  };

  return (
    <div className="menu-tester">
      <div className="tester-header">
        <h2 className="tester-title">
          <TestTube className="w-6 h-6" />
          Testeur de Menus
        </h2>
        <p className="tester-subtitle">
          Testez les fonctionnalités de création de menus et plats
        </p>
      </div>

      <div className="tester-actions">
        <button 
          className="btn btn-primary"
          onClick={testMenuCreation}
          disabled={loading}
        >
          <Utensils className="w-4 h-4" />
          Test Création Menu
        </button>
        
        <button 
          className="btn btn-primary"
          onClick={testMenuItemCreation}
          disabled={loading}
        >
          <Plus className="w-4 h-4" />
          Test Création Plat
        </button>
        
        <button 
          className="btn btn-secondary"
          onClick={testMenuFetch}
          disabled={loading}
        >
          <Utensils className="w-4 h-4" />
          Test Récupération
        </button>
        
        <button 
          className="btn btn-outline"
          onClick={() => setShowMenuForm(true)}
        >
          <Utensils className="w-4 h-4" />
          Ouvrir Formulaire Menu
        </button>
        
        <button 
          className="btn btn-outline"
          onClick={() => setShowMenuItemForm(true)}
        >
          <Plus className="w-4 h-4" />
          Ouvrir Formulaire Plat
        </button>
        
        <button 
          className="btn btn-danger"
          onClick={clearResults}
        >
          Effacer Résultats
        </button>
      </div>

      <div className="test-results">
        <h3>Résultats des Tests</h3>
        {testResults.length === 0 ? (
          <p className="no-results">Aucun test effectué</p>
        ) : (
          <div className="results-list">
            {testResults.map((result) => (
              <motion.div
                key={result.id}
                className={`result-item ${result.success ? 'success' : 'error'}`}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.3 }}
              >
                <div className="result-icon">
                  {result.success ? (
                    <CheckCircle className="w-5 h-5" />
                  ) : (
                    <XCircle className="w-5 h-5" />
                  )}
                </div>
                <div className="result-content">
                  <div className="result-test">{result.test}</div>
                  <div className="result-message">{result.message}</div>
                  <div className="result-time">{result.timestamp}</div>
                </div>
              </motion.div>
            ))}
          </div>
        )}
      </div>

      {/* Formulaires de test */}
      <MenuForm
        isOpen={showMenuForm}
        onClose={() => setShowMenuForm(false)}
        onSuccess={() => {
          setShowMenuForm(false);
          addTestResult('Formulaire Menu', true, 'Menu créé via formulaire');
        }}
        restaurantId={68}
      />

      <MenuItemForm
        isOpen={showMenuItemForm}
        onClose={() => setShowMenuItemForm(false)}
        onSuccess={() => {
          setShowMenuItemForm(false);
          addTestResult('Formulaire Plat', true, 'Plat créé via formulaire');
        }}
        menuId={1}
      />
    </div>
  );
};

export default MenuTester;
