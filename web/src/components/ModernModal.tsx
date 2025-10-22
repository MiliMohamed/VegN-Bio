import React, { useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, AlertCircle, CheckCircle, Info, AlertTriangle } from 'lucide-react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  type?: 'default' | 'success' | 'warning' | 'error' | 'info';
  showCloseButton?: boolean;
  closeOnOverlayClick?: boolean;
  className?: string;
}

const ModernModal: React.FC<ModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  size = 'md',
  type = 'default',
  showCloseButton = true,
  closeOnOverlayClick = true,
  className = ''
}) => {
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }

    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isOpen]);

  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && isOpen) {
        onClose();
      }
    };

    document.addEventListener('keydown', handleEscape);
    return () => document.removeEventListener('keydown', handleEscape);
  }, [isOpen, onClose]);

  const getSizeClass = () => {
    switch (size) {
      case 'sm':
        return 'max-w-md';
      case 'lg':
        return 'max-w-4xl';
      case 'xl':
        return 'max-w-6xl';
      default:
        return 'max-w-2xl';
    }
  };

  const getTypeIcon = () => {
    switch (type) {
      case 'success':
        return <CheckCircle className="w-6 h-6 text-green-500" />;
      case 'warning':
        return <AlertTriangle className="w-6 h-6 text-yellow-500" />;
      case 'error':
        return <AlertCircle className="w-6 h-6 text-red-500" />;
      case 'info':
        return <Info className="w-6 h-6 text-blue-500" />;
      default:
        return null;
    }
  };

  const getTypeClass = () => {
    switch (type) {
      case 'success':
        return 'border-l-green-500';
      case 'warning':
        return 'border-l-yellow-500';
      case 'error':
        return 'border-l-red-500';
      case 'info':
        return 'border-l-blue-500';
      default:
        return '';
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="modal-overlay"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.2 }}
          onClick={closeOnOverlayClick ? onClose : undefined}
        >
          <motion.div
            className={`modal ${getSizeClass()} ${className}`}
            initial={{ opacity: 0, scale: 0.95, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 20 }}
            transition={{ duration: 0.2 }}
            onClick={(e) => e.stopPropagation()}
          >
            {(title || showCloseButton) && (
              <div className={`modal-header ${getTypeClass()}`}>
                <div className="modal-title-container">
                  {getTypeIcon() && (
                    <div className="modal-icon">
                      {getTypeIcon()}
                    </div>
                  )}
                  {title && <h2 className="modal-title">{title}</h2>}
                </div>
                {showCloseButton && (
                  <button
                    className="modal-close"
                    onClick={onClose}
                    aria-label="Fermer"
                  >
                    <X className="w-5 h-5" />
                  </button>
                )}
              </div>
            )}
            
            <div className="modal-body">
              {children}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

// Composant pour les modales de confirmation
interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title?: string;
  message: string;
  confirmText?: string;
  cancelText?: string;
  type?: 'warning' | 'error' | 'info';
  loading?: boolean;
}

export const ConfirmModal: React.FC<ConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  title = 'Confirmation',
  message,
  confirmText = 'Confirmer',
  cancelText = 'Annuler',
  type = 'warning',
  loading = false
}) => {
  return (
    <ModernModal
      isOpen={isOpen}
      onClose={onClose}
      title={title}
      size="sm"
      type={type}
    >
      <div className="confirm-modal-content">
        <p className="confirm-message">{message}</p>
        <div className="modal-footer">
          <button
            className="btn btn-secondary"
            onClick={onClose}
            disabled={loading}
          >
            {cancelText}
          </button>
          <button
            className={`btn ${type === 'error' ? 'btn-danger' : 'btn-primary'}`}
            onClick={onConfirm}
            disabled={loading}
          >
            {loading ? (
              <div className="loading-spinner" />
            ) : (
              confirmText
            )}
          </button>
        </div>
      </div>
    </ModernModal>
  );
};

// Composant pour les modales de formulaire
interface FormModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (data: any) => void;
  title: string;
  children: React.ReactNode;
  submitText?: string;
  cancelText?: string;
  loading?: boolean;
  size?: 'sm' | 'md' | 'lg' | 'xl';
}

export const FormModal: React.FC<FormModalProps> = ({
  isOpen,
  onClose,
  onSubmit,
  title,
  children,
  submitText = 'Enregistrer',
  cancelText = 'Annuler',
  loading = false,
  size = 'md'
}) => {
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const formData = new FormData(e.target as HTMLFormElement);
    const data = Object.fromEntries(formData.entries());
    onSubmit(data);
  };

  return (
    <ModernModal
      isOpen={isOpen}
      onClose={onClose}
      title={title}
      size={size}
    >
      <form onSubmit={handleSubmit} className="form-modal-content">
        <div className="modal-body">
          {children}
        </div>
        <div className="modal-footer">
          <button
            type="button"
            className="btn btn-secondary"
            onClick={onClose}
            disabled={loading}
          >
            {cancelText}
          </button>
          <button
            type="submit"
            className="btn btn-primary"
            disabled={loading}
          >
            {loading ? (
              <div className="loading-spinner" />
            ) : (
              submitText
            )}
          </button>
        </div>
      </form>
    </ModernModal>
  );
};

// Composant pour les modales d'information
interface InfoModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
  type?: 'success' | 'warning' | 'error' | 'info';
  size?: 'sm' | 'md' | 'lg' | 'xl';
}

export const InfoModal: React.FC<InfoModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  type = 'info',
  size = 'md'
}) => {
  return (
    <ModernModal
      isOpen={isOpen}
      onClose={onClose}
      title={title}
      size={size}
      type={type}
    >
      <div className="info-modal-content">
        {children}
        <div className="modal-footer">
          <button
            className="btn btn-primary"
            onClick={onClose}
          >
            Fermer
          </button>
        </div>
      </div>
    </ModernModal>
  );
};

export default ModernModal;
