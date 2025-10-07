import React, { useState } from 'react';
import { 
  Plus, 
  Edit, 
  Trash2, 
  Eye, 
  MoreVertical,
  CheckCircle,
  XCircle,
  AlertCircle,
  Clock
} from 'lucide-react';
import { useNotificationHelpers } from './NotificationProvider';

interface ActionButtonProps {
  type: 'create' | 'edit' | 'delete' | 'view' | 'more';
  onClick?: () => void;
  disabled?: boolean;
  loading?: boolean;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'primary' | 'secondary' | 'danger' | 'warning' | 'success';
  children?: React.ReactNode;
  tooltip?: string;
}

const ActionButton: React.FC<ActionButtonProps> = ({
  type,
  onClick,
  disabled = false,
  loading = false,
  size = 'md',
  variant = 'primary',
  children,
  tooltip
}) => {
  const { success, error, warning, info } = useNotificationHelpers();

  const getIcon = () => {
    switch (type) {
      case 'create':
        return <Plus className="w-4 h-4" />;
      case 'edit':
        return <Edit className="w-4 h-4" />;
      case 'delete':
        return <Trash2 className="w-4 h-4" />;
      case 'view':
        return <Eye className="w-4 h-4" />;
      case 'more':
        return <MoreVertical className="w-4 h-4" />;
      default:
        return null;
    }
  };

  const getVariantClass = () => {
    switch (variant) {
      case 'primary':
        return 'btn-primary';
      case 'secondary':
        return 'btn-secondary';
      case 'danger':
        return 'btn-danger';
      case 'warning':
        return 'btn-warning';
      case 'success':
        return 'btn-primary'; // Utilise primary-green pour success
      default:
        return 'btn-primary';
    }
  };

  const getSizeClass = () => {
    switch (size) {
      case 'sm':
        return 'btn-sm';
      case 'lg':
        return 'btn-lg';
      default:
        return '';
    }
  };

  const handleClick = () => {
    if (disabled || loading) return;

    // Actions par défaut si aucune action n'est fournie
    if (!onClick) {
      switch (type) {
        case 'create':
          success('Action Créer', 'Fonctionnalité de création en cours de développement');
          break;
        case 'edit':
          info('Action Modifier', 'Fonctionnalité de modification en cours de développement');
          break;
        case 'delete':
          warning('Action Supprimer', 'Fonctionnalité de suppression en cours de développement');
          break;
        case 'view':
          info('Action Voir', 'Fonctionnalité de visualisation en cours de développement');
          break;
        case 'more':
          info('Menu Options', 'Menu d\'options en cours de développement');
          break;
      }
      return;
    }

    onClick();
  };

  return (
    <button
      className={`btn ${getVariantClass()} ${getSizeClass()} ${loading ? 'opacity-50' : ''}`}
      onClick={handleClick}
      disabled={disabled || loading}
      title={tooltip}
    >
      {loading ? (
        <div className="loading-spinner" />
      ) : (
        getIcon()
      )}
      {children}
    </button>
  );
};

// Composant pour les actions groupées
interface ActionGroupProps {
  actions: ActionButtonProps[];
  className?: string;
}

export const ActionGroup: React.FC<ActionGroupProps> = ({ actions, className = '' }) => {
  return (
    <div className={`flex gap-2 ${className}`}>
      {actions.map((action, index) => (
        <ActionButton key={index} {...action} />
      ))}
    </div>
  );
};

// Composant pour les actions de ligne de tableau
interface TableRowActionsProps {
  onEdit?: () => void;
  onDelete?: () => void;
  onView?: () => void;
  onMore?: () => void;
  canEdit?: boolean;
  canDelete?: boolean;
  canView?: boolean;
  loading?: boolean;
}

export const TableRowActions: React.FC<TableRowActionsProps> = ({
  onEdit,
  onDelete,
  onView,
  onMore,
  canEdit = true,
  canDelete = true,
  canView = true,
  loading = false
}) => {
  const actions = [];

  if (canView) {
    actions.push({
      type: 'view' as const,
      onClick: onView,
      variant: 'secondary' as const,
      size: 'sm' as const,
      tooltip: 'Voir les détails'
    });
  }

  if (canEdit) {
    actions.push({
      type: 'edit' as const,
      onClick: onEdit,
      variant: 'warning' as const,
      size: 'sm' as const,
      tooltip: 'Modifier'
    });
  }

  if (canDelete) {
    actions.push({
      type: 'delete' as const,
      onClick: onDelete,
      variant: 'danger' as const,
      size: 'sm' as const,
      tooltip: 'Supprimer'
    });
  }

  if (onMore) {
    actions.push({
      type: 'more' as const,
      onClick: onMore,
      variant: 'secondary' as const,
      size: 'sm' as const,
      tooltip: 'Plus d\'options'
    });
  }

  return <ActionGroup actions={actions} />;
};

// Composant pour les actions de création
interface CreateActionProps {
  onCreate?: () => void;
  label?: string;
  disabled?: boolean;
  loading?: boolean;
}

export const CreateAction: React.FC<CreateActionProps> = ({
  onCreate,
  label = 'Nouveau',
  disabled = false,
  loading = false
}) => {
  return (
    <ActionButton
      type="create"
      onClick={onCreate}
      disabled={disabled}
      loading={loading}
      size="lg"
      variant="primary"
    >
      {label}
    </ActionButton>
  );
};

// Composant pour les actions de confirmation
interface ConfirmActionProps {
  onConfirm: () => void;
  onCancel: () => void;
  confirmLabel?: string;
  cancelLabel?: string;
  confirmVariant?: 'primary' | 'danger' | 'warning';
  loading?: boolean;
}

export const ConfirmAction: React.FC<ConfirmActionProps> = ({
  onConfirm,
  onCancel,
  confirmLabel = 'Confirmer',
  cancelLabel = 'Annuler',
  confirmVariant = 'primary',
  loading = false
}) => {
  return (
    <div className="flex gap-2 justify-end">
      <ActionButton
        type="edit"
        onClick={onCancel}
        variant="secondary"
        disabled={loading}
      >
        {cancelLabel}
      </ActionButton>
      <ActionButton
        type="create"
        onClick={onConfirm}
        variant={confirmVariant}
        loading={loading}
      >
        {confirmLabel}
      </ActionButton>
    </div>
  );
};

// Composant pour les actions de statut
interface StatusActionProps {
  status: 'active' | 'inactive' | 'pending' | 'completed' | 'cancelled';
  onStatusChange?: (newStatus: string) => void;
  loading?: boolean;
}

export const StatusAction: React.FC<StatusActionProps> = ({
  status,
  onStatusChange,
  loading = false
}) => {
  const getStatusIcon = () => {
    switch (status) {
      case 'active':
      case 'completed':
        return <CheckCircle className="w-4 h-4 text-green-500" />;
      case 'inactive':
      case 'cancelled':
        return <XCircle className="w-4 h-4 text-red-500" />;
      case 'pending':
        return <Clock className="w-4 h-4 text-yellow-500" />;
      default:
        return <AlertCircle className="w-4 h-4 text-gray-500" />;
    }
  };

  const getStatusLabel = () => {
    switch (status) {
      case 'active':
        return 'Actif';
      case 'inactive':
        return 'Inactif';
      case 'pending':
        return 'En attente';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return 'Inconnu';
    }
  };

  const getStatusVariant = () => {
    switch (status) {
      case 'active':
      case 'completed':
        return 'success';
      case 'inactive':
      case 'cancelled':
        return 'danger';
      case 'pending':
        return 'warning';
      default:
        return 'secondary';
    }
  };

  return (
    <div className="flex items-center gap-2">
      {getStatusIcon()}
      <span className={`badge badge-${getStatusVariant()}`}>
        {getStatusLabel()}
      </span>
    </div>
  );
};

export default ActionButton;
