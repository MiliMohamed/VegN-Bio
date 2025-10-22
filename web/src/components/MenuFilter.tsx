import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Filter, 
  Search, 
  X, 
  SlidersHorizontal,
  Heart,
  Leaf,
  Euro,
  Clock,
  Star,
  MapPin
} from 'lucide-react';
import AllergenManager from './AllergenManager';
import '../styles/menu-filter.css';

interface Allergen {
  id: number;
  code: string;
  label: string;
}

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens: Allergen[];
}

interface MenuFilterProps {
  items: MenuItem[];
  onFilteredItems: (items: MenuItem[]) => void;
  className?: string;
}

interface FilterState {
  searchTerm: string;
  priceRange: [number, number];
  showVeganOnly: boolean;
  allergenPreferences: { [allergenId: number]: boolean };
  sortBy: 'name' | 'price' | 'popularity';
  sortOrder: 'asc' | 'desc';
}

const MenuFilter: React.FC<MenuFilterProps> = ({ 
  items, 
  onFilteredItems, 
  className = '' 
}) => {
  const [showFilters, setShowFilters] = useState(false);
  const [filters, setFilters] = useState<FilterState>({
    searchTerm: '',
    priceRange: [0, 50],
    showVeganOnly: false,
    allergenPreferences: {},
    sortBy: 'name',
    sortOrder: 'asc'
  });

  // Appliquer les filtres quand ils changent
  useEffect(() => {
    const filtered = applyFilters(items, filters);
    onFilteredItems(filtered);
  }, [items, filters, onFilteredItems]);

  const applyFilters = (itemsToFilter: MenuItem[], currentFilters: FilterState): MenuItem[] => {
    let filtered = [...itemsToFilter];

    // Filtre par terme de recherche
    if (currentFilters.searchTerm) {
      const searchTerm = currentFilters.searchTerm.toLowerCase();
      filtered = filtered.filter(item => 
        item.name.toLowerCase().includes(searchTerm) ||
        item.description.toLowerCase().includes(searchTerm)
      );
    }

    // Filtre par prix
    filtered = filtered.filter(item => {
      const price = item.priceCents / 100;
      return price >= currentFilters.priceRange[0] && price <= currentFilters.priceRange[1];
    });

    // Filtre végétalien
    if (currentFilters.showVeganOnly) {
      filtered = filtered.filter(item => item.isVegan);
    }

    // Filtre par allergènes (exclure les plats contenant les allergènes sélectionnés)
    const selectedAllergens = Object.keys(currentFilters.allergenPreferences)
      .filter(key => currentFilters.allergenPreferences[Number(key)])
      .map(Number);

    if (selectedAllergens.length > 0) {
      filtered = filtered.filter(item => {
        const itemAllergenIds = item.allergens.map(allergen => allergen.id);
        return !selectedAllergens.some(allergenId => itemAllergenIds.includes(allergenId));
      });
    }

    // Tri
    filtered.sort((a, b) => {
      let comparison = 0;
      
      switch (currentFilters.sortBy) {
        case 'name':
          comparison = a.name.localeCompare(b.name);
          break;
        case 'price':
          comparison = a.priceCents - b.priceCents;
          break;
        case 'popularity':
          // Pour l'instant, on utilise le prix comme proxy pour la popularité
          comparison = a.priceCents - b.priceCents;
          break;
      }
      
      return currentFilters.sortOrder === 'asc' ? comparison : -comparison;
    });

    return filtered;
  };

  const handleFilterChange = (key: keyof FilterState, value: any) => {
    setFilters(prev => ({
      ...prev,
      [key]: value
    }));
  };

  const handleAllergenPreferencesChange = (preferences: { [allergenId: number]: boolean }) => {
    handleFilterChange('allergenPreferences', preferences);
  };

  const clearAllFilters = () => {
    setFilters({
      searchTerm: '',
      priceRange: [0, 50],
      showVeganOnly: false,
      allergenPreferences: {},
      sortBy: 'name',
      sortOrder: 'asc'
    });
  };

  const getActiveFiltersCount = () => {
    let count = 0;
    if (filters.searchTerm) count++;
    if (filters.showVeganOnly) count++;
    if (filters.priceRange[0] > 0 || filters.priceRange[1] < 50) count++;
    if (Object.values(filters.allergenPreferences).some(Boolean)) count++;
    return count;
  };

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const getPriceRange = () => {
    if (items.length === 0) return [0, 50];
    const prices = items.map(item => item.priceCents / 100);
    return [Math.floor(Math.min(...prices)), Math.ceil(Math.max(...prices))];
  };

  const maxPrice = Math.max(...getPriceRange());

  return (
    <div className={`menu-filter ${className}`}>
      {/* Barre de recherche principale */}
      <div className="filter-header">
        <div className="search-bar">
          <Search className="w-4 h-4" />
          <input
            type="text"
            placeholder="Rechercher un plat..."
            value={filters.searchTerm}
            onChange={(e) => handleFilterChange('searchTerm', e.target.value)}
            className="search-input"
          />
          {filters.searchTerm && (
            <button
              onClick={() => handleFilterChange('searchTerm', '')}
              className="clear-search-btn"
            >
              <X className="w-4 h-4" />
            </button>
          )}
        </div>

        <button
          className={`filter-toggle-btn ${getActiveFiltersCount() > 0 ? 'has-filters' : ''}`}
          onClick={() => setShowFilters(!showFilters)}
        >
          <SlidersHorizontal className="w-4 h-4" />
          <span>Filtres</span>
          {getActiveFiltersCount() > 0 && (
            <span className="filter-count">{getActiveFiltersCount()}</span>
          )}
        </button>

        <AllergenManager 
          onPreferencesChange={handleAllergenPreferencesChange}
          className="allergen-manager-inline"
        />
      </div>

      {/* Panel de filtres avancés */}
      <AnimatePresence>
        {showFilters && (
          <motion.div
            className="filters-panel"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            transition={{ duration: 0.3 }}
          >
            <div className="filters-content">
              {/* Filtres rapides */}
              <div className="quick-filters">
                <button
                  className={`quick-filter-btn ${filters.showVeganOnly ? 'active' : ''}`}
                  onClick={() => handleFilterChange('showVeganOnly', !filters.showVeganOnly)}
                >
                  <Leaf className="w-4 h-4" />
                  Végétalien uniquement
                </button>
              </div>

              {/* Filtre par prix */}
              <div className="price-filter">
                <label className="filter-label">
                  <Euro className="w-4 h-4" />
                  Prix : {formatPrice(filters.priceRange[0] * 100)} - {formatPrice(filters.priceRange[1] * 100)}
                </label>
                <div className="price-range-container">
                  <input
                    type="range"
                    min="0"
                    max={maxPrice}
                    step="0.5"
                    value={filters.priceRange[0]}
                    onChange={(e) => handleFilterChange('priceRange', [Number(e.target.value), filters.priceRange[1]])}
                    className="price-range-input"
                  />
                  <input
                    type="range"
                    min="0"
                    max={maxPrice}
                    step="0.5"
                    value={filters.priceRange[1]}
                    onChange={(e) => handleFilterChange('priceRange', [filters.priceRange[0], Number(e.target.value)])}
                    className="price-range-input"
                  />
                </div>
              </div>

              {/* Tri */}
              <div className="sort-filters">
                <label className="filter-label">
                  <Star className="w-4 h-4" />
                  Trier par :
                </label>
                <div className="sort-options">
                  <select
                    value={filters.sortBy}
                    onChange={(e) => handleFilterChange('sortBy', e.target.value)}
                    className="sort-select"
                  >
                    <option value="name">Nom</option>
                    <option value="price">Prix</option>
                    <option value="popularity">Popularité</option>
                  </select>
                  <select
                    value={filters.sortOrder}
                    onChange={(e) => handleFilterChange('sortOrder', e.target.value)}
                    className="sort-order-select"
                  >
                    <option value="asc">Croissant</option>
                    <option value="desc">Décroissant</option>
                  </select>
                </div>
              </div>

              {/* Actions */}
              <div className="filter-actions">
                <button
                  className="btn btn-secondary btn-sm"
                  onClick={clearAllFilters}
                >
                  <X className="w-4 h-4" />
                  Effacer tous les filtres
                </button>
                <button
                  className="btn btn-primary btn-sm"
                  onClick={() => setShowFilters(false)}
                >
                  <Filter className="w-4 h-4" />
                  Appliquer
                </button>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default MenuFilter;
