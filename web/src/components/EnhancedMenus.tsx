import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { 
  Utensils, 
  Plus, 
  Edit, 
  Trash2, 
  Eye,
  Star,
  Clock,
  Users,
  AlertTriangle,
  Shield,
  Leaf,
  Search,
  Filter,
  Info,
  X
} from 'lucide-react';
import { menuService, allergenService } from '../services/api';

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens?: string[];
  category?: string;
  nutritionalInfo?: {
    calories?: number;
    protein?: number;
    carbs?: number;
    fat?: number;
  };
}

interface Menu {
  id: number;
  title: string;
  activeFrom: string;
  activeTo: string;
  menuItems: MenuItem[];
}

interface Allergen {
  id: string;
  name: string;
  description: string;
}

const EnhancedMenus: React.FC = () => {
  const [menus, setMenus] = useState<Menu[]>([]);
  const [allergens, setAllergens] = useState<Allergen[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRestaurant, setSelectedRestaurant] = useState<number>(1);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedAllergens, setSelectedAllergens] = useState<string[]>([]);
  const [showAllergenInfo, setShowAllergenInfo] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [showNutritionalInfo, setShowNutritionalInfo] = useState<number | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [menusResponse, allergensResponse] = await Promise.all([
          menuService.getMenusByRestaurant(selectedRestaurant),
          allergenService.getAll()
        ]);
        setMenus(menusResponse.data);
        setAllergens(allergensResponse.data);
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [selectedRestaurant]);

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const filteredMenus = menus.map(menu => ({
    ...menu,
    menuItems: menu.menuItems.filter(item => {
      const matchesSearch = item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                           item.description.toLowerCase().includes(searchTerm.toLowerCase());
      
      const matchesCategory = selectedCategory === 'all' || item.category === selectedCategory;
      
      const hasSelectedAllergens = selectedAllergens.length === 0 || 
        (item.allergens && item.allergens.some(allergen => selectedAllergens.includes(allergen)));
      
      return matchesSearch && matchesCategory && !hasSelectedAllergens;
    })
  })).filter(menu => menu.menuItems.length > 0);

  const getAllergenInfo = (allergenId: string) => {
    return allergens.find(a => a.id === allergenId);
  };

  const getCategories = () => {
    const categories = new Set<string>();
    menus.forEach(menu => {
      menu.menuItems.forEach(item => {
        if (item.category) categories.add(item.category);
      });
    });
    return Array.from(categories);
  };

  const toggleAllergen = (allergen: string) => {
    setSelectedAllergens(prev => 
      prev.includes(allergen) 
        ? prev.filter(a => a !== allergen)
        : [...prev, allergen]
    );
  };

  if (loading) {
    return (
      <div className="enhanced-menus">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des menus...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="enhanced-menus">
      <div className="menus-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Menus Végétariens Bio</h1>
          <p className="page-subtitle">
            Découvrez nos cartes saisonnières avec informations détaillées sur les allergènes
          </p>
        </motion.div>
      </div>

      {/* Barre de recherche et filtres */}
      <div className="search-filters">
        <div className="search-bar">
          <Search className="search-icon" />
          <input
            type="text"
            placeholder="Rechercher un plat..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="search-input"
          />
        </div>

        <div className="filters">
          <div className="filter-group">
            <Filter className="filter-icon" />
            <select 
              value={selectedCategory} 
              onChange={(e) => setSelectedCategory(e.target.value)}
              className="category-filter"
            >
              <option value="all">Toutes les catégories</option>
              {getCategories().map(category => (
                <option key={category} value={category}>{category}</option>
              ))}
            </select>
          </div>

          <button 
            className="allergen-info-btn"
            onClick={() => setShowAllergenInfo(!showAllergenInfo)}
          >
            <AlertTriangle className="w-4 h-4" />
            Allergènes
          </button>
        </div>
      </div>

      {/* Filtres d'allergènes */}
      {showAllergenInfo && (
        <motion.div 
          className="allergen-filters"
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto' }}
          exit={{ opacity: 0, height: 0 }}
        >
          <div className="allergen-header">
            <h3>Filtrer par allergènes (exclure)</h3>
            <button onClick={() => setShowAllergenInfo(false)}>
              <X className="w-4 h-4" />
            </button>
          </div>
          <div className="allergen-chips">
            {allergens.map(allergen => (
              <button
                key={allergen.id}
                className={`allergen-chip ${selectedAllergens.includes(allergen.id) ? 'selected' : ''}`}
                onClick={() => toggleAllergen(allergen.id)}
                title={allergen.description}
              >
                {allergen.name}
              </button>
            ))}
          </div>
        </motion.div>
      )}

      {/* Affichage des menus */}
      <div className="menus-content">
        {filteredMenus.map((menu, index) => (
          <motion.div
            key={menu.id}
            className="menu-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
          >
            <div className="menu-header">
              <h2 className="menu-title">{menu.title}</h2>
              <div className="menu-period">
                <Clock className="w-4 h-4" />
                <span>
                  Du {new Date(menu.activeFrom).toLocaleDateString('fr-FR')} au{' '}
                  {new Date(menu.activeTo).toLocaleDateString('fr-FR')}
                </span>
              </div>
            </div>

            <div className="menu-items">
              {menu.menuItems.map((item, itemIndex) => (
                <motion.div
                  key={item.id}
                  className="menu-item"
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.4, delay: itemIndex * 0.05 }}
                >
                  <div className="item-header">
                    <h3 className="item-name">{item.name}</h3>
                    <div className="item-price">{formatPrice(item.priceCents)}</div>
                  </div>
                  
                  <p className="item-description">{item.description}</p>
                  
                  {/* Informations nutritionnelles */}
                  {item.nutritionalInfo && (
                    <div className="nutritional-info">
                      <button 
                        className="nutrition-toggle"
                        onClick={() => setShowNutritionalInfo(
                          showNutritionalInfo === item.id ? null : item.id
                        )}
                      >
                        <Info className="w-4 h-4" />
                        Informations nutritionnelles
                      </button>
                      
                      {showNutritionalInfo === item.id && (
                        <motion.div 
                          className="nutrition-details"
                          initial={{ opacity: 0, height: 0 }}
                          animate={{ opacity: 1, height: 'auto' }}
                          exit={{ opacity: 0, height: 0 }}
                        >
                          <div className="nutrition-grid">
                            {item.nutritionalInfo.calories && (
                              <div className="nutrition-item">
                                <span className="nutrition-label">Calories</span>
                                <span className="nutrition-value">{item.nutritionalInfo.calories} kcal</span>
                              </div>
                            )}
                            {item.nutritionalInfo.protein && (
                              <div className="nutrition-item">
                                <span className="nutrition-label">Protéines</span>
                                <span className="nutrition-value">{item.nutritionalInfo.protein}g</span>
                              </div>
                            )}
                            {item.nutritionalInfo.carbs && (
                              <div className="nutrition-item">
                                <span className="nutrition-label">Glucides</span>
                                <span className="nutrition-value">{item.nutritionalInfo.carbs}g</span>
                              </div>
                            )}
                            {item.nutritionalInfo.fat && (
                              <div className="nutrition-item">
                                <span className="nutrition-label">Lipides</span>
                                <span className="nutrition-value">{item.nutritionalInfo.fat}g</span>
                              </div>
                            )}
                          </div>
                        </motion.div>
                      )}
                    </div>
                  )}

                  {/* Allergènes */}
                  {item.allergens && item.allergens.length > 0 && (
                    <div className="allergens-section">
                      <div className="allergens-header">
                        <AlertTriangle className="w-4 h-4" />
                        <span>Allergènes présents</span>
                      </div>
                      <div className="allergens-list">
                        {item.allergens.map(allergenId => {
                          const allergen = getAllergenInfo(allergenId);
                          return (
                            <span 
                              key={allergenId} 
                              className="allergen-badge"
                              title={allergen?.description}
                            >
                              {allergen?.name || allergenId}
                            </span>
                          );
                        })}
                      </div>
                    </div>
                  )}

                  <div className="item-badges">
                    {item.isVegan && (
                      <span className="badge badge-vegan">
                        <Star className="w-3 h-3" />
                        Végétalien
                      </span>
                    )}
                    <span className="badge badge-bio">
                      <Leaf className="w-3 h-3" />
                      Bio
                    </span>
                    {item.category && (
                      <span className="badge badge-category">
                        <Utensils className="w-3 h-3" />
                        {item.category}
                      </span>
                    )}
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        ))}
      </div>

      {filteredMenus.length === 0 && (
        <div className="no-results">
          <p>Aucun plat ne correspond à vos critères de recherche.</p>
          <button 
            className="clear-filters-btn"
            onClick={() => {
              setSearchTerm('');
              setSelectedAllergens([]);
              setSelectedCategory('all');
            }}
          >
            Effacer les filtres
          </button>
        </div>
      )}
    </div>
  );
};

export default EnhancedMenus;
