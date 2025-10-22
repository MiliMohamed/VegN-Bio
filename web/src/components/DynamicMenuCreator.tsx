import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../contexts/AuthContext';
import { 
  Plus, 
  X, 
  Save, 
  Utensils,
  Building2,
  Calendar,
  CheckCircle,
  AlertCircle,
  Loader2,
  Download,
  FileText
} from 'lucide-react';
import { restaurantService, menuService } from '../services/api';
import '../styles/dynamic-menu-creator.css';

interface Restaurant {
  id: number;
  name: string;
  code: string;
  address: string;
  city: string;
  phone: string;
  email: string;
}

interface MenuTemplate {
  name: string;
  description: string;
  price_cents: number;
  is_vegan: boolean;
}

const DynamicMenuCreator: React.FC = () => {
  const { user } = useAuth();
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [selectedRestaurant, setSelectedRestaurant] = useState<Restaurant | null>(null);
  const [menuTitle, setMenuTitle] = useState('');
  const [activeFrom, setActiveFrom] = useState('');
  const [activeTo, setActiveTo] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [generatedSQL, setGeneratedSQL] = useState('');

  // Templates de plats pour chaque restaurant
  const menuTemplates: { [key: string]: MenuTemplate[] } = {
    'BAS': [ // Bastille
      { name: 'Burger Tofu Bio', description: 'Burger au tofu grillé, salade croquante, tomates, sauce sésame, pain complet bio', price_cents: 1290, is_vegan: true },
      { name: 'Velouté de Courge', description: 'Velouté de courge butternut bio, graines de courge, crème de coco', price_cents: 790, is_vegan: true },
      { name: 'Salade Quinoa', description: 'Salade de quinoa bio, légumes de saison, noix, vinaigrette citron', price_cents: 1090, is_vegan: true }
    ],
    'REP': [ // République
      { name: 'Curry de Légumes', description: 'Curry de légumes bio, lait de coco, riz basmati, coriandre fraîche', price_cents: 1190, is_vegan: true },
      { name: 'Poke Bowl Végétal', description: 'Bowl de quinoa, avocat, edamame, carottes, sauce tahini', price_cents: 1390, is_vegan: true },
      { name: 'Wrap Falafel', description: 'Wrap de falafel maison, houmous, légumes croquants, sauce tahini', price_cents: 1090, is_vegan: true }
    ],
    'NAT': [ // Nation
      { name: 'Tartine Avocat', description: 'Tartine de pain complet, avocat, tomates cerises, graines, citron', price_cents: 890, is_vegan: true },
      { name: 'Wrap Falafel', description: 'Wrap de falafel maison, houmous, légumes croquants, sauce tahini', price_cents: 1090, is_vegan: true },
      { name: 'Bowl Buddha', description: 'Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines', price_cents: 1390, is_vegan: true }
    ],
    'ITA': [ // Place d'Italie
      { name: 'Pâtes Carbonara Végétale', description: 'Pâtes complètes, sauce crémeuse aux champignons, noix de cajou', price_cents: 1190, is_vegan: true },
      { name: 'Risotto aux Champignons', description: 'Risotto crémeux aux champignons de saison, parmesan végétal', price_cents: 1290, is_vegan: true },
      { name: 'Pizza Margherita Végétale', description: 'Pizza à la tomate, mozzarella végétale, basilic frais', price_cents: 1190, is_vegan: true }
    ],
    'BOU': [ // Beaubourg
      { name: 'Bowl Buddha', description: 'Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines', price_cents: 1390, is_vegan: true },
      { name: 'Soupe Miso', description: 'Soupe miso traditionnelle, algues, tofu, légumes croquants', price_cents: 690, is_vegan: true },
      { name: 'Salade César Végétale', description: 'Salade romaine, croûtons, sauce césar végétale, parmesan végétal', price_cents: 1090, is_vegan: true }
    ]
  };

  useEffect(() => {
    fetchRestaurants();
  }, []);

  const fetchRestaurants = async () => {
    try {
      setLoading(true);
      const response = await restaurantService.getAll();
      setRestaurants(response.data);
    } catch (error) {
      console.error('Erreur lors du chargement des restaurants:', error);
      setError('Erreur lors du chargement des restaurants');
    } finally {
      setLoading(false);
    }
  };

  const generateSQL = () => {
    if (!selectedRestaurant || !menuTitle || !activeFrom || !activeTo) {
      setError('Veuillez remplir tous les champs obligatoires');
      return;
    }

    const restaurantId = selectedRestaurant.id;
    const restaurantCode = selectedRestaurant.code;
    const templates = menuTemplates[restaurantCode] || [];

    let sql = `-- Menu pour ${selectedRestaurant.name} (ID: ${restaurantId})\n`;
    sql += `INSERT INTO menus (restaurant_id, title, active_from, active_to)\n`;
    sql += `VALUES (${restaurantId}, '${menuTitle}', '${activeFrom}', '${activeTo}');\n\n`;

    sql += `-- Ajouter des éléments de menu pour ${selectedRestaurant.name} (ID: ${restaurantId})\n`;
    
    templates.forEach((template, index) => {
      sql += `INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)\n`;
      sql += `SELECT \n`;
      sql += `    m.id,\n`;
      sql += `    '${template.name}',\n`;
      sql += `    '${template.description}',\n`;
      sql += `    ${template.price_cents},\n`;
      sql += `    ${template.is_vegan}\n`;
      sql += `FROM menus m \n`;
      sql += `WHERE m.restaurant_id = ${restaurantId} AND m.title = '${menuTitle}';\n\n`;
    });

    setGeneratedSQL(sql);
    setShowModal(true);
  };

  const createMenuViaAPI = async () => {
    if (!selectedRestaurant || !menuTitle || !activeFrom || !activeTo) {
      setError('Veuillez remplir tous les champs obligatoires');
      return;
    }

    try {
      setLoading(true);
      setError('');
      setSuccess('');

      // Créer le menu principal
      const menuData = {
        restaurantId: selectedRestaurant.id,
        title: menuTitle,
        activeFrom: activeFrom,
        activeTo: activeTo
      };

      const menuResponse = await menuService.create(menuData);
      const createdMenu = menuResponse.data;

      // Ajouter les éléments de menu
      const restaurantCode = selectedRestaurant.code;
      const templates = menuTemplates[restaurantCode] || [];

      for (const template of templates) {
        await menuService.createMenuItem({
          menuId: createdMenu.id,
          name: template.name,
          description: template.description,
          priceCents: template.price_cents,
          isVegan: template.is_vegan
        });
      }

      setSuccess(`Menu créé avec succès pour ${selectedRestaurant.name} avec ${templates.length} plats !`);
      
      // Reset form
      setMenuTitle('');
      setActiveFrom('');
      setActiveTo('');
      setSelectedRestaurant(null);

    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur lors de la création du menu');
    } finally {
      setLoading(false);
    }
  };

  const downloadSQL = () => {
    const blob = new Blob([generatedSQL], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `menu_${selectedRestaurant?.code}_${Date.now()}.sql`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  const canCreateMenu = () => {
    return user?.role === 'RESTAURATEUR' || user?.role === 'ADMIN';
  };

  if (!canCreateMenu()) {
    return (
      <div className="dynamic-menu-creator">
        <div className="access-denied">
          <AlertCircle className="w-8 h-8 text-red-500" />
          <h2>Accès refusé</h2>
          <p>Vous devez être restaurateur ou administrateur pour créer des menus.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="dynamic-menu-creator">
      <div className="creator-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">
            <Utensils className="w-8 h-8" />
            Créateur de Menus Dynamique
          </h1>
          <p className="page-subtitle">
            Créez des menus automatiquement pour tous vos restaurants
          </p>
        </motion.div>
      </div>

      {loading && restaurants.length === 0 && (
        <div className="loading-container">
          <Loader2 className="w-8 h-8 animate-spin" />
          <p>Chargement des restaurants...</p>
        </div>
      )}

      {error && (
        <div className="alert alert-error">
          <AlertCircle className="w-5 h-5" />
          {error}
        </div>
      )}

      {success && (
        <div className="alert alert-success">
          <CheckCircle className="w-5 h-5" />
          {success}
        </div>
      )}

      <motion.div 
        className="creator-form"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="form-card">
          <div className="form-header">
            <h2 className="form-title">
              <Building2 className="w-6 h-6" />
              Sélection du Restaurant
            </h2>
          </div>

          <div className="form-group">
            <label htmlFor="restaurant" className="form-label">
              Restaurant *
            </label>
            <select
              id="restaurant"
              value={selectedRestaurant?.id || ''}
              onChange={(e) => {
                const restaurant = restaurants.find(r => r.id === parseInt(e.target.value));
                setSelectedRestaurant(restaurant || null);
                setError('');
              }}
              className="form-select"
              required
            >
              <option value="">Sélectionnez un restaurant...</option>
              {restaurants.map(restaurant => (
                <option key={restaurant.id} value={restaurant.id}>
                  {restaurant.name} ({restaurant.code}) - {restaurant.city}
                </option>
              ))}
            </select>
          </div>

          {selectedRestaurant && (
            <div className="restaurant-info">
              <h3 className="info-title">Restaurant sélectionné</h3>
              <div className="info-grid">
                <div className="info-item">
                  <strong>Nom:</strong> {selectedRestaurant.name}
                </div>
                <div className="info-item">
                  <strong>Code:</strong> {selectedRestaurant.code}
                </div>
                <div className="info-item">
                  <strong>Adresse:</strong> {selectedRestaurant.address}, {selectedRestaurant.city}
                </div>
                <div className="info-item">
                  <strong>ID:</strong> {selectedRestaurant.id}
                </div>
              </div>
            </div>
          )}

          <div className="form-group">
            <label htmlFor="menuTitle" className="form-label">
              Titre du menu *
            </label>
            <input
              type="text"
              id="menuTitle"
              value={menuTitle}
              onChange={(e) => setMenuTitle(e.target.value)}
              className="form-input"
              placeholder="Ex: Menu Automne 2024"
              required
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="activeFrom" className="form-label">
                <Calendar className="w-4 h-4" />
                Date de début *
              </label>
              <input
                type="date"
                id="activeFrom"
                value={activeFrom}
                onChange={(e) => setActiveFrom(e.target.value)}
                className="form-input"
                min={new Date().toISOString().split('T')[0]}
                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="activeTo" className="form-label">
                <Calendar className="w-4 h-4" />
                Date de fin *
              </label>
              <input
                type="date"
                id="activeTo"
                value={activeTo}
                onChange={(e) => setActiveTo(e.target.value)}
                className="form-input"
                min={activeFrom || new Date().toISOString().split('T')[0]}
                required
              />
            </div>
          </div>

          {selectedRestaurant && (
            <div className="menu-preview">
              <h3 className="preview-title">Aperçu du menu</h3>
              <div className="preview-list">
                {(menuTemplates[selectedRestaurant.code] || []).map((item, index) => (
                  <div key={index} className="preview-item">
                    <div className="item-name">{item.name}</div>
                    <div className="item-price">{(item.price_cents / 100).toFixed(2)}€</div>
                  </div>
                ))}
              </div>
            </div>
          )}

          <div className="form-actions">
            <button 
              type="button" 
              className="btn btn-secondary"
              onClick={generateSQL}
              disabled={!selectedRestaurant || !menuTitle || !activeFrom || !activeTo}
            >
              <FileText className="w-4 h-4" />
              Générer SQL
            </button>
            
            <button 
              type="button" 
              className={`btn btn-primary ${loading ? 'loading' : ''}`}
              onClick={createMenuViaAPI}
              disabled={!selectedRestaurant || !menuTitle || !activeFrom || !activeTo || loading}
            >
              {loading ? (
                <Loader2 className="w-4 h-4 animate-spin" />
              ) : (
                <Save className="w-4 h-4" />
              )}
              Créer le menu via API
            </button>
          </div>
        </div>
      </motion.div>

      {/* Modal pour afficher le SQL généré */}
      {showModal && (
        <div className="modal-overlay" onClick={() => setShowModal(false)}>
          <motion.div 
            className="modal-content modal-large"
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.3 }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="modal-header">
              <h2 className="modal-title">
                <FileText className="w-6 h-6" />
                SQL Généré Dynamiquement
              </h2>
              <button className="modal-close" onClick={() => setShowModal(false)}>
                <X className="w-6 h-6" />
              </button>
            </div>

            <div className="modal-body">
              <div className="sql-preview">
                <pre className="sql-code">{generatedSQL}</pre>
              </div>
            </div>

            <div className="modal-footer">
              <button 
                className="btn btn-secondary"
                onClick={() => setShowModal(false)}
              >
                Fermer
              </button>
              <button 
                className="btn btn-primary"
                onClick={downloadSQL}
              >
                <Download className="w-4 h-4" />
                Télécharger SQL
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default DynamicMenuCreator;
