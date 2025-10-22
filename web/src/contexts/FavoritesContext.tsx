import React, { createContext, useContext, useState, ReactNode } from 'react';

export interface FavoriteItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens: Array<{
    id: number;
    code: string;
    label: string;
  }>;
  restaurantId: number;
  restaurantName: string;
  addedAt: Date;
}

interface FavoritesContextType {
  favorites: FavoriteItem[];
  addToFavorites: (item: Omit<FavoriteItem, 'addedAt'>) => void;
  removeFromFavorites: (itemId: number) => void;
  isFavorite: (itemId: number) => boolean;
  clearFavorites: () => void;
  getFavoritesCount: () => number;
}

const FavoritesContext = createContext<FavoritesContextType | undefined>(undefined);

export const useFavorites = () => {
  const context = useContext(FavoritesContext);
  if (!context) {
    throw new Error('useFavorites must be used within a FavoritesProvider');
  }
  return context;
};

interface FavoritesProviderProps {
  children: ReactNode;
}

export const FavoritesProvider: React.FC<FavoritesProviderProps> = ({ children }) => {
  // Charger les favoris depuis localStorage au démarrage
  const [favorites, setFavorites] = useState<FavoriteItem[]>(() => {
    try {
      const savedFavorites = localStorage.getItem('vegn-bio-favorites');
      if (savedFavorites) {
        const parsed = JSON.parse(savedFavorites);
        // Convertir les dates string en objets Date
        return parsed.map((item: any) => ({
          ...item,
          addedAt: new Date(item.addedAt)
        }));
      }
    } catch (error) {
      console.error('Erreur lors du chargement des favoris:', error);
    }
    return [];
  });

  // Sauvegarder dans localStorage à chaque changement
  React.useEffect(() => {
    try {
      localStorage.setItem('vegn-bio-favorites', JSON.stringify(favorites));
    } catch (error) {
      console.error('Erreur lors de la sauvegarde des favoris:', error);
    }
  }, [favorites]);

  const addToFavorites = (item: Omit<FavoriteItem, 'addedAt'>) => {
    setFavorites(prevFavorites => {
      // Vérifier si l'item n'est pas déjà dans les favoris
      const existingItem = prevFavorites.find(fav => fav.id === item.id);
      if (existingItem) {
        return prevFavorites; // Ne pas ajouter en double
      }
      
      return [...prevFavorites, { ...item, addedAt: new Date() }];
    });
  };

  const removeFromFavorites = (itemId: number) => {
    setFavorites(prevFavorites => 
      prevFavorites.filter(item => item.id !== itemId)
    );
  };

  const isFavorite = (itemId: number) => {
    return favorites.some(item => item.id === itemId);
  };

  const clearFavorites = () => {
    setFavorites([]);
  };

  const getFavoritesCount = () => {
    return favorites.length;
  };

  const value: FavoritesContextType = {
    favorites,
    addToFavorites,
    removeFromFavorites,
    isFavorite,
    clearFavorites,
    getFavoritesCount,
  };

  return <FavoritesContext.Provider value={value}>{children}</FavoritesContext.Provider>;
};
