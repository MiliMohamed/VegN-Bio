import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ShoppingCart, Plus, Minus, Trash2, X, CreditCard, Clock } from 'lucide-react';
import api from '../services/api';

interface CartItem {
  id: number;
  menuItemId: number;
  menuItemName: string;
  menuItemDescription: string;
  quantity: number;
  unitPriceCents: number;
  totalPriceCents: number;
  specialInstructions?: string;
  addedAt: string;
}

interface Cart {
  id: number;
  userId: number;
  items: CartItem[];
  totalItems: number;
  totalPriceCents: number;
  createdAt: string;
  updatedAt: string;
  status: string;
}

interface ModernCartProps {
  isOpen: boolean;
  onClose: () => void;
  onItemAdded?: () => void;
}

const ModernCart: React.FC<ModernCartProps> = ({ isOpen, onClose, onItemAdded }) => {
  const [cart, setCart] = useState<Cart | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isOpen) {
      loadCart();
    }
  }, [isOpen]);

  const loadCart = async () => {
    try {
      setLoading(true);
      const response = await api.get('/api/v1/cart');
      setCart(response.data);
      setError(null);
    } catch (err: any) {
      setError('Erreur lors du chargement du panier');
      console.error('Error loading cart:', err);
    } finally {
      setLoading(false);
    }
  };

  const updateQuantity = async (cartItemId: number, newQuantity: number) => {
    if (newQuantity <= 0) {
      await removeItem(cartItemId);
      return;
    }

    try {
      setLoading(true);
      await api.put(`/api/v1/cart/items/${cartItemId}`, {
        quantity: newQuantity
      });
      await loadCart();
    } catch (err: any) {
      setError('Erreur lors de la mise à jour');
      console.error('Error updating quantity:', err);
    } finally {
      setLoading(false);
    }
  };

  const removeItem = async (cartItemId: number) => {
    try {
      setLoading(true);
      await api.delete(`/api/v1/cart/items/${cartItemId}`);
      await loadCart();
    } catch (err: any) {
      setError('Erreur lors de la suppression');
      console.error('Error removing item:', err);
    } finally {
      setLoading(false);
    }
  };

  const clearCart = async () => {
    try {
      setLoading(true);
      await api.delete('/api/v1/cart');
      await loadCart();
    } catch (err: any) {
      setError('Erreur lors du vidage du panier');
      console.error('Error clearing cart:', err);
    } finally {
      setLoading(false);
    }
  };

  const formatPrice = (cents: number) => {
    return (cents / 100).toFixed(2) + ' €';
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (!isOpen) return null;

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
        onClick={onClose}
      >
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.9, opacity: 0 }}
          className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden"
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          <div className="bg-gradient-to-r from-green-500 to-green-600 text-white p-6">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <ShoppingCart className="w-6 h-6" />
                <h2 className="text-2xl font-bold">Mon Panier</h2>
                {cart && (
                  <span className="bg-white bg-opacity-20 px-3 py-1 rounded-full text-sm">
                    {cart.totalItems} article{cart.totalItems > 1 ? 's' : ''}
                  </span>
                )}
              </div>
              <button
                onClick={onClose}
                className="p-2 hover:bg-white hover:bg-opacity-20 rounded-full transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
            </div>
          </div>

          {/* Content */}
          <div className="p-6 overflow-y-auto max-h-[calc(90vh-140px)]">
            {loading && (
              <div className="flex items-center justify-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-green-500"></div>
              </div>
            )}

            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4">
                {error}
              </div>
            )}

            {cart && cart.items.length === 0 && !loading && (
              <div className="text-center py-12">
                <ShoppingCart className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-600 mb-2">Votre panier est vide</h3>
                <p className="text-gray-500">Ajoutez des articles depuis nos menus pour commencer</p>
              </div>
            )}

            {cart && cart.items.length > 0 && (
              <div className="space-y-4">
                {cart.items.map((item) => (
                  <motion.div
                    key={item.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: -20 }}
                    className="bg-gray-50 rounded-xl p-4 border border-gray-200"
                  >
                    <div className="flex items-start justify-between mb-3">
                      <div className="flex-1">
                        <h4 className="font-semibold text-gray-900 mb-1">{item.menuItemName}</h4>
                        <p className="text-sm text-gray-600 mb-2">{item.menuItemDescription}</p>
                        {item.specialInstructions && (
                          <p className="text-sm text-blue-600 italic">
                            Instructions: {item.specialInstructions}
                          </p>
                        )}
                        <div className="flex items-center text-sm text-gray-500 mt-2">
                          <Clock className="w-4 h-4 mr-1" />
                          Ajouté le {formatDate(item.addedAt)}
                        </div>
                      </div>
                      <button
                        onClick={() => removeItem(item.id)}
                        className="p-2 text-red-500 hover:bg-red-50 rounded-full transition-colors"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>

                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-3">
                        <button
                          onClick={() => updateQuantity(item.id, item.quantity - 1)}
                          disabled={loading}
                          className="p-2 bg-gray-200 hover:bg-gray-300 rounded-full transition-colors disabled:opacity-50"
                        >
                          <Minus className="w-4 h-4" />
                        </button>
                        <span className="font-semibold text-lg w-8 text-center">{item.quantity}</span>
                        <button
                          onClick={() => updateQuantity(item.id, item.quantity + 1)}
                          disabled={loading}
                          className="p-2 bg-gray-200 hover:bg-gray-300 rounded-full transition-colors disabled:opacity-50"
                        >
                          <Plus className="w-4 h-4" />
                        </button>
                      </div>
                      <div className="text-right">
                        <div className="text-sm text-gray-500">
                          {formatPrice(item.unitPriceCents)} × {item.quantity}
                        </div>
                        <div className="font-bold text-lg text-green-600">
                          {formatPrice(item.totalPriceCents)}
                        </div>
                      </div>
                    </div>
                  </motion.div>
                ))}
              </div>
            )}
          </div>

          {/* Footer */}
          {cart && cart.items.length > 0 && (
            <div className="border-t border-gray-200 p-6 bg-gray-50">
              <div className="flex items-center justify-between mb-4">
                <span className="text-lg font-semibold">Total</span>
                <span className="text-2xl font-bold text-green-600">
                  {formatPrice(cart.totalPriceCents)}
                </span>
              </div>
              
              <div className="flex space-x-3">
                <button
                  onClick={clearCart}
                  disabled={loading}
                  className="flex-1 px-4 py-3 bg-gray-200 text-gray-700 rounded-xl font-semibold hover:bg-gray-300 transition-colors disabled:opacity-50"
                >
                  Vider le panier
                </button>
                <button
                  onClick={() => {
                    // TODO: Implémenter la logique de commande
                    console.log('Commander');
                  }}
                  className="flex-1 px-4 py-3 bg-green-500 text-white rounded-xl font-semibold hover:bg-green-600 transition-colors flex items-center justify-center space-x-2"
                >
                  <CreditCard className="w-5 h-5" />
                  <span>Commander</span>
                </button>
              </div>
            </div>
          )}
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );
};

export default ModernCart;
