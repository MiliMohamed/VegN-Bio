import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, X, Edit, Trash2, Eye, Settings } from 'lucide-react';
import { useNotificationHelpers } from './NotificationProvider';
import { ConfirmModal } from './ModernModal';

interface FloatingActionButtonProps {
  onCreate?: () => void;
  onEdit?: () => void;
  onDelete?: () => void;
  onView?: () => void;
  onSettings?: () => void;
  className?: string;
}

const FloatingActionButton: React.FC<FloatingActionButtonProps> = ({
  onCreate,
  onEdit,
  onDelete,
  onView,
  onSettings,
  className = ''
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const { success, info, warning } = useNotificationHelpers();

  const actions = [
    {
      icon: <Plus className="w-5 h-5" />,
      label: 'Créer',
      onClick: onCreate || (() => {
        success('Action Créer', 'Fonctionnalité de création en cours de développement');
      }),
      color: 'bg-green-500 hover:bg-green-600',
      delay: 0.1
    },
    {
      icon: <Edit className="w-5 h-5" />,
      label: 'Modifier',
      onClick: onEdit || (() => {
        info('Action Modifier', 'Fonctionnalité de modification en cours de développement');
      }),
      color: 'bg-blue-500 hover:bg-blue-600',
      delay: 0.2
    },
    {
      icon: <Eye className="w-5 h-5" />,
      label: 'Voir',
      onClick: onView || (() => {
        info('Action Voir', 'Fonctionnalité de visualisation en cours de développement');
      }),
      color: 'bg-purple-500 hover:bg-purple-600',
      delay: 0.3
    },
    {
      icon: <Settings className="w-5 h-5" />,
      label: 'Paramètres',
      onClick: onSettings || (() => {
        info('Action Paramètres', 'Fonctionnalité de paramètres en cours de développement');
      }),
      color: 'bg-gray-500 hover:bg-gray-600',
      delay: 0.4
    },
    {
      icon: <Trash2 className="w-5 h-5" />,
      label: 'Supprimer',
      onClick: () => setShowConfirmModal(true),
      color: 'bg-red-500 hover:bg-red-600',
      delay: 0.5
    }
  ];

  const handleActionClick = (action: typeof actions[0]) => {
    setIsOpen(false);
    action.onClick();
  };

  const handleDeleteConfirm = () => {
    setShowConfirmModal(false);
    warning('Action Supprimer', 'Fonctionnalité de suppression en cours de développement');
  };

  return (
    <>
      <div className={`fixed bottom-6 right-6 z-50 ${className}`}>
        {/* Actions */}
        <AnimatePresence>
          {isOpen && (
            <div className="absolute bottom-16 right-0 flex flex-col gap-3">
              {actions.map((action, index) => (
                <motion.div
                  key={action.label}
                  initial={{ opacity: 0, scale: 0, x: 20 }}
                  animate={{ opacity: 1, scale: 1, x: 0 }}
                  exit={{ opacity: 0, scale: 0, x: 20 }}
                  transition={{ 
                    duration: 0.2, 
                    delay: action.delay,
                    type: "spring",
                    stiffness: 200
                  }}
                  className="flex items-center gap-3"
                >
                  <span className="bg-gray-800 text-white px-3 py-1 rounded-lg text-sm font-medium whitespace-nowrap">
                    {action.label}
                  </span>
                  <button
                    onClick={() => handleActionClick(action)}
                    className={`w-12 h-12 rounded-full text-white shadow-lg transition-all duration-200 flex items-center justify-center ${action.color}`}
                  >
                    {action.icon}
                  </button>
                </motion.div>
              ))}
            </div>
          )}
        </AnimatePresence>

        {/* Bouton principal */}
        <motion.button
          onClick={() => setIsOpen(!isOpen)}
          className="w-14 h-14 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-full shadow-lg hover:shadow-xl transition-all duration-200 flex items-center justify-center"
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.95 }}
          animate={{ rotate: isOpen ? 45 : 0 }}
          transition={{ duration: 0.2 }}
        >
          <motion.div
            animate={{ rotate: isOpen ? 0 : 0 }}
            transition={{ duration: 0.2 }}
          >
            {isOpen ? <X className="w-6 h-6" /> : <Plus className="w-6 h-6" />}
          </motion.div>
        </motion.button>
      </div>

      {/* Modal de confirmation pour la suppression */}
      <ConfirmModal
        isOpen={showConfirmModal}
        onClose={() => setShowConfirmModal(false)}
        onConfirm={handleDeleteConfirm}
        title="Confirmer la suppression"
        message="Êtes-vous sûr de vouloir supprimer cet élément ? Cette action est irréversible."
        confirmText="Supprimer"
        cancelText="Annuler"
        type="error"
      />
    </>
  );
};

export default FloatingActionButton;
