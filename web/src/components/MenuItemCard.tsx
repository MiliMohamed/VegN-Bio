import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Plus, Minus, ShoppingCart, Heart, Star } from 'lucide-react';
import api from '../services/api';

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  category: string;
}

interface MenuItemCardProps {
  item: MenuItem;
  onAddToCart?: (item: MenuItem, quantity: number, specialInstructions?: string) => void;
  showAddToCart?: boolean;
}

const MenuItemCard: React.FC<MenuItemCardProps> = ({ 
  item, 
  onAddToCart, 
  showAddToCart = true 
}) => {
  const [quantity, setQuantity] = useState(1);
  const [specialInstructions, setSpecialInstructions] = useState('');
  const [isAdding, setIsAdding] = useState(false);
  const [showInstructions, setShowInstructions] = useState(false);

  const formatPrice = (cents: number) => {
    return (cents / 100).toFixed(2) + ' €';
  };

  const handleAddToCart = async () => {
    if (!onAddToCart) return;
    
    setIsAdding(true);
    try {
      await onAddToCart(item, quantity, specialInstructions);
      setQuantity(1);
      setSpecialInstructions('');
      setShowInstructions(false);
    } catch (error) {
      console.error('Error adding to cart:', error);
    } finally {
      setIsAdding(false);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ y: -5 }}
      className="bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100"
    >
      {/* Image placeholder */}
      <div className="h-48 bg-gradient-to-br from-green-100 to-green-200 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-2">
            <span className="text-white text-2xl font-bold">
              {item.name.charAt(0).toUpperCase()}
            </span>
          </div>
          <p className="text-green-600 font-semibold">Photo du plat</p>
        </div>
      </div>

      <div className="p-6">
        {/* Header */}
        <div className="flex items-start justify-between mb-3">
          <div className="flex-1">
            <h3 className="text-xl font-bold text-gray-900 mb-1">{item.name}</h3>
            <p className="text-gray-600 text-sm mb-2">{item.description}</p>
          </div>
          <div className="flex items-center space-x-2">
            {item.isVegan && (
              <span className="bg-green-100 text-green-700 px-2 py-1 rounded-full text-xs font-semibold">
                🌱 Vegan
              </span>
            )}
            <button className="p-2 text-gray-400 hover:text-red-500 transition-colors">
              <Heart className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Category */}
        <div className="mb-4">
          <span className="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm font-medium">
            {item.category}
          </span>
        </div>

        {/* Price */}
        <div className="flex items-center justify-between mb-4">
          <div className="text-2xl font-bold text-green-600">
            {formatPrice(item.priceCents)}
          </div>
          <div className="flex items-center space-x-1">
            <Star className="w-4 h-4 text-yellow-400 fill-current" />
            <span className="text-sm text-gray-600">4.5</span>
          </div>
        </div>

        {/* Quantity selector */}
        {showAddToCart && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700">Quantité</span>
              <div className="flex items-center space-x-3">
                <button
                  onClick={() => setQuantity(Math.max(1, quantity - 1))}
                  className="p-2 bg-gray-200 hover:bg-gray-300 rounded-full transition-colors"
                >
                  <Minus className="w-4 h-4" />
                </button>
                <span className="font-semibold text-lg w-8 text-center">{quantity}</span>
                <button
                  onClick={() => setQuantity(quantity + 1)}
                  className="p-2 bg-gray-200 hover:bg-gray-300 rounded-full transition-colors"
                >
                  <Plus className="w-4 h-4" />
                </button>
              </div>
            </div>

            {/* Special instructions */}
            <div>
              <button
                onClick={() => setShowInstructions(!showInstructions)}
                className="text-sm text-blue-600 hover:text-blue-700 font-medium"
              >
                {showInstructions ? 'Masquer' : 'Ajouter'} des instructions spéciales
              </button>
              {showInstructions && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  className="mt-2"
                >
                  <textarea
                    value={specialInstructions}
                    onChange={(e) => setSpecialInstructions(e.target.value)}
                    placeholder="Ex: Sans oignons, bien cuit, etc."
                    className="w-full p-3 border border-gray-300 rounded-lg resize-none focus:ring-2 focus:ring-green-500 focus:border-transparent"
                    rows={2}
                  />
                </motion.div>
              )}
            </div>

            {/* Add to cart button */}
            <button
              onClick={handleAddToCart}
              disabled={isAdding}
              className="w-full bg-green-500 text-white py-3 rounded-xl font-semibold hover:bg-green-600 transition-colors disabled:opacity-50 flex items-center justify-center space-x-2"
            >
              {isAdding ? (
                <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
              ) : (
                <>
                  <ShoppingCart className="w-5 h-5" />
                  <span>Ajouter au panier</span>
                </>
              )}
            </button>
          </div>
        )}
      </div>
    </motion.div>
  );
};

export default MenuItemCard;
