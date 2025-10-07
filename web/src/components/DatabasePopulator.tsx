import React, { useState } from 'react';
import { Database, Loader, CheckCircle, AlertCircle } from 'lucide-react';
import { populateDatabase } from '../utils/testData';
import { useNotificationHelpers } from './NotificationProvider';

const DatabasePopulator: React.FC = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [isCompleted, setIsCompleted] = useState(false);
  const [error, setError] = useState('');
  const { success, error: notifyError } = useNotificationHelpers();

  const handlePopulateDatabase = async () => {
    setIsLoading(true);
    setError('');
    setIsCompleted(false);

    try {
      await populateDatabase();
      setIsCompleted(true);
      success('Base de données remplie avec succès !', 'Toutes les données de test ont été ajoutées.');
    } catch (err: any) {
      const errorMessage = err.message || 'Erreur lors du remplissage de la base de données';
      setError(errorMessage);
      notifyError('Erreur lors du remplissage', errorMessage);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="modern-card">
      <div className="modern-card-header">
        <div className="flex items-center gap-3">
          <Database className="w-6 h-6 text-primary-green" />
          <h2 className="modern-card-title">Remplissage de la Base de Données</h2>
        </div>
      </div>
      
      <div className="modern-card-content">
        <div className="mb-4">
          <p className="text-gray-600 mb-2">
            Ce bouton va remplir la base de données avec des données de test réalistes :
          </p>
          <ul className="list-disc list-inside text-sm text-gray-600 space-y-1 ml-4">
            <li>5 restaurants avec leurs informations complètes</li>
            <li>2 menus avec plusieurs plats végétariens</li>
            <li>3 événements (ateliers, dégustations, conférences)</li>
            <li>3 fournisseurs de produits bio</li>
            <li>3 offres sur le marketplace</li>
          </ul>
        </div>

        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
            <div className="flex items-center gap-2">
              <AlertCircle className="w-5 h-5 text-red-500" />
              <span className="text-red-700 font-medium">Erreur</span>
            </div>
            <p className="text-red-600 text-sm mt-1">{error}</p>
          </div>
        )}

        {isCompleted && (
          <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-md">
            <div className="flex items-center gap-2">
              <CheckCircle className="w-5 h-5 text-green-500" />
              <span className="text-green-700 font-medium">Succès</span>
            </div>
            <p className="text-green-600 text-sm mt-1">
              La base de données a été remplie avec succès avec toutes les données de test !
            </p>
          </div>
        )}

        <button
          onClick={handlePopulateDatabase}
          disabled={isLoading || isCompleted}
          className={`btn btn-primary ${isLoading ? 'opacity-50 cursor-not-allowed' : ''}`}
        >
          {isLoading ? (
            <>
              <Loader className="w-4 h-4 animate-spin" />
              Remplissage en cours...
            </>
          ) : isCompleted ? (
            <>
              <CheckCircle className="w-4 h-4" />
              Base de données remplie
            </>
          ) : (
            <>
              <Database className="w-4 h-4" />
              Remplir la Base de Données
            </>
          )}
        </button>

        <div className="mt-4 p-3 bg-blue-50 border border-blue-200 rounded-md">
          <h4 className="font-medium text-blue-800 mb-2">⚠️ Important</h4>
          <p className="text-blue-700 text-sm">
            Cette action est destinée aux administrateurs uniquement. 
            Elle va ajouter des données de test à votre base de données existante.
            Assurez-vous d'être connecté avec un compte administrateur.
          </p>
        </div>
      </div>
    </div>
  );
};

export default DatabasePopulator;
