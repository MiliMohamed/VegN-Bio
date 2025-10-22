import React, { useState } from 'react';
import { 
  Play, 
  CheckCircle, 
  XCircle, 
  AlertCircle, 
  Loader,
  Database,
  Globe,
  Activity
} from 'lucide-react';
import { useNotificationHelpers } from './NotificationProvider';

interface TestResult {
  name: string;
  success: boolean;
  status?: number;
  statusText?: string;
  error?: string;
  url: string;
}

interface TestSuite {
  name: string;
  icon: React.ReactNode;
  tests: TestResult[];
  success: boolean;
}

const BackendTester: React.FC = () => {
  const [isRunning, setIsRunning] = useState(false);
  const [results, setResults] = useState<TestSuite[]>([]);
  const [isConnected, setIsConnected] = useState<boolean | null>(null);
  const { success, error: notifyError, info } = useNotificationHelpers();

  const API_BASE_URL = process.env.REACT_APP_API_URL || 'https://vegn-bio-backend.onrender.com/api/v1';

  // Fonction utilitaire pour faire des requêtes
  const makeRequest = async (url: string, options: any = {}) => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch(url, {
        headers: {
          'Content-Type': 'application/json',
          ...(token && { 'Authorization': `Bearer ${token}` }),
          ...options.headers
        },
        ...options
      });
      
      const data = await response.json().catch(() => null);
      
      return {
        success: response.ok,
        status: response.status,
        statusText: response.statusText,
        data,
        url
      };
    } catch (err: any) {
      return {
        success: false,
        error: err.message,
        url
      };
    }
  };

  // Test de connectivité de base
  const testConnectivity = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/restaurants`);
      const isConnected = response.ok;
      setIsConnected(isConnected);
      return isConnected;
    } catch (err) {
      setIsConnected(false);
      return false;
    }
  };

  // Tests des endpoints d'authentification
  const testAuthEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'POST /auth/login',
        test: () => makeRequest(`${API_BASE_URL}/auth/login`, {
          method: 'POST',
          body: JSON.stringify({
            email: 'admin@vegnbio.com',
            password: 'Admin123!'
          })
        })
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Tests des endpoints de restaurants
  const testRestaurantEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'GET /restaurants',
        test: () => makeRequest(`${API_BASE_URL}/restaurants`)
      },
      {
        name: 'GET /restaurants/68',
        test: () => makeRequest(`${API_BASE_URL}/restaurants/68`)
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Tests des endpoints de menus
  const testMenuEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'GET /menus/restaurant/68',
        test: () => makeRequest(`${API_BASE_URL}/menus/restaurant/68`)
      },
      {
        name: 'GET /menus/restaurant/68/active',
        test: () => makeRequest(`${API_BASE_URL}/menus/restaurant/68/active`)
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Tests des endpoints d'événements
  const testEventEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'GET /events',
        test: () => makeRequest(`${API_BASE_URL}/events`)
      },
      {
        name: 'GET /events?restaurantId=68',
        test: () => makeRequest(`${API_BASE_URL}/events?restaurantId=68`)
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Tests des endpoints de fournisseurs
  const testSupplierEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'GET /suppliers',
        test: () => makeRequest(`${API_BASE_URL}/suppliers`)
      },
      {
        name: 'GET /suppliers?search=bio',
        test: () => makeRequest(`${API_BASE_URL}/suppliers?search=bio`)
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Tests des endpoints d'offres
  const testOfferEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'GET /offers',
        test: () => makeRequest(`${API_BASE_URL}/offers`)
      },
      {
        name: 'GET /offers?search=legumes',
        test: () => makeRequest(`${API_BASE_URL}/offers?search=legumes`)
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Tests des endpoints d'allergènes
  const testAllergenEndpoints = async (): Promise<TestResult[]> => {
    const tests = [
      {
        name: 'GET /allergens',
        test: () => makeRequest(`${API_BASE_URL}/allergens`)
      }
    ];
    
    const results = [];
    for (const test of tests) {
      const result = await test.test();
      results.push({ name: test.name, ...result });
    }
    
    return results;
  };

  // Lancement de tous les tests
  const runAllTests = async () => {
    setIsRunning(true);
    setResults([]);
    
    try {
      // Test de connectivité
      const connected = await testConnectivity();
      if (!connected) {
        notifyError('Connexion échouée', 'Le backend n\'est pas accessible');
        setIsRunning(false);
        return;
      }

      success('Connexion réussie', 'Le backend est accessible');

      // Tests par catégorie
      const testSuites = [
        {
          name: 'Authentification',
          icon: <AlertCircle className="w-5 h-5" />,
          tests: await testAuthEndpoints()
        },
        {
          name: 'Restaurants',
          icon: <Database className="w-5 h-5" />,
          tests: await testRestaurantEndpoints()
        },
        {
          name: 'Menus',
          icon: <Database className="w-5 h-5" />,
          tests: await testMenuEndpoints()
        },
        {
          name: 'Événements',
          icon: <Activity className="w-5 h-5" />,
          tests: await testEventEndpoints()
        },
        {
          name: 'Fournisseurs',
          icon: <Globe className="w-5 h-5" />,
          tests: await testSupplierEndpoints()
        },
        {
          name: 'Offres',
          icon: <Globe className="w-5 h-5" />,
          tests: await testOfferEndpoints()
        },
        {
          name: 'Allergènes',
          icon: <AlertCircle className="w-5 h-5" />,
          tests: await testAllergenEndpoints()
        }
      ];

      // Calculer les résultats
      const processedSuites = testSuites.map(suite => ({
        ...suite,
        success: suite.tests.every(test => test.success)
      }));

      setResults(processedSuites);

      // Statistiques
      const totalTests = processedSuites.reduce((sum, suite) => sum + suite.tests.length, 0);
      const successfulTests = processedSuites.reduce((sum, suite) => 
        sum + suite.tests.filter(test => test.success).length, 0);
      const successRate = ((successfulTests / totalTests) * 100).toFixed(1);

      info('Tests terminés', `${successfulTests}/${totalTests} tests réussis (${successRate}%)`);

    } catch (err: any) {
      notifyError('Erreur lors des tests', err.message);
    } finally {
      setIsRunning(false);
    }
  };

  const getStatusIcon = (success: boolean) => {
    return success ? (
      <CheckCircle className="w-4 h-4 text-green-500" />
    ) : (
      <XCircle className="w-4 h-4 text-red-500" />
    );
  };

  const getStatusColor = (success: boolean) => {
    return success ? 'text-green-600' : 'text-red-600';
  };

  return (
    <div className="modern-card">
      <div className="modern-card-header">
        <div className="flex items-center gap-3">
          <Database className="w-6 h-6 text-primary-green" />
          <h2 className="modern-card-title">Tests Backend</h2>
        </div>
        <button
          onClick={runAllTests}
          disabled={isRunning}
          className="btn btn-primary"
        >
          {isRunning ? (
            <>
              <Loader className="w-4 h-4 animate-spin" />
              Tests en cours...
            </>
          ) : (
            <>
              <Play className="w-4 h-4" />
              Lancer les Tests
            </>
          )}
        </button>
      </div>
      
      <div className="modern-card-content">
        {/* Statut de connectivité */}
        <div className="mb-6">
          <h3 className="text-lg font-semibold mb-3">Connexion Backend</h3>
          <div className="flex items-center gap-3">
            {isConnected === null ? (
              <div className="flex items-center gap-2 text-gray-500">
                <AlertCircle className="w-5 h-5" />
                <span>Non testé</span>
              </div>
            ) : isConnected ? (
              <div className="flex items-center gap-2 text-green-600">
                <CheckCircle className="w-5 h-5" />
                <span>Backend accessible</span>
              </div>
            ) : (
              <div className="flex items-center gap-2 text-red-600">
                <XCircle className="w-5 h-5" />
                <span>Backend inaccessible</span>
              </div>
            )}
            <span className="text-sm text-gray-500">
              ({API_BASE_URL})
            </span>
          </div>
        </div>

        {/* Résultats des tests */}
        {results.length > 0 && (
          <div>
            <h3 className="text-lg font-semibold mb-3">Résultats des Tests</h3>
            <div className="space-y-4">
              {results.map((suite, index) => (
                <div key={index} className="border border-gray-200 rounded-lg p-4">
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-2">
                      {suite.icon}
                      <h4 className="font-medium">{suite.name}</h4>
                    </div>
                    {getStatusIcon(suite.success)}
                  </div>
                  
                  <div className="space-y-2">
                    {suite.tests.map((test, testIndex) => (
                      <div key={testIndex} className="flex items-center justify-between text-sm">
                        <span className="font-mono">{test.name}</span>
                        <div className="flex items-center gap-2">
                          {getStatusIcon(test.success)}
                          <span className={getStatusColor(test.success)}>
                            {test.success ? 'OK' : `${test.status || 'Error'}`}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Instructions */}
        <div className="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <h4 className="font-medium text-blue-800 mb-2">💡 Instructions</h4>
          <ul className="text-sm text-blue-700 space-y-1">
            <li>• Cliquez sur "Lancer les Tests" pour vérifier tous les endpoints</li>
            <li>• Les tests vérifient la connectivité et les réponses des APIs</li>
            <li>• Les erreurs 401/403 sont normales sans authentification</li>
            <li>• Les erreurs 404 peuvent indiquer des données manquantes</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default BackendTester;
