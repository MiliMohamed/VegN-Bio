import React from 'react';
import { 
  TrendingUp, 
  TrendingDown, 
  Minus,
  ArrowUpRight,
  ArrowDownRight
} from 'lucide-react';

interface StatCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon?: React.ReactNode;
  trend?: {
    value: number;
    label: string;
    type: 'up' | 'down' | 'neutral';
  };
  color?: 'primary' | 'success' | 'warning' | 'danger' | 'info';
  loading?: boolean;
}

export const StatCard: React.FC<StatCardProps> = ({
  title,
  value,
  subtitle,
  icon,
  trend,
  color = 'primary',
  loading = false
}) => {
  const getColorClass = () => {
    switch (color) {
      case 'primary':
        return 'text-green-600 bg-green-50 border-green-200';
      case 'success':
        return 'text-green-600 bg-green-50 border-green-200';
      case 'warning':
        return 'text-yellow-600 bg-yellow-50 border-yellow-200';
      case 'danger':
        return 'text-red-600 bg-red-50 border-red-200';
      case 'info':
        return 'text-blue-600 bg-blue-50 border-blue-200';
      default:
        return 'text-gray-600 bg-gray-50 border-gray-200';
    }
  };

  const getTrendIcon = () => {
    if (!trend) return null;
    
    switch (trend.type) {
      case 'up':
        return <ArrowUpRight className="w-4 h-4 text-green-500" />;
      case 'down':
        return <ArrowDownRight className="w-4 h-4 text-red-500" />;
      case 'neutral':
        return <Minus className="w-4 h-4 text-gray-500" />;
      default:
        return null;
    }
  };

  const getTrendColor = () => {
    if (!trend) return '';
    
    switch (trend.type) {
      case 'up':
        return 'text-green-600';
      case 'down':
        return 'text-red-600';
      case 'neutral':
        return 'text-gray-600';
      default:
        return 'text-gray-600';
    }
  };

  if (loading) {
    return (
      <div className="modern-card">
        <div className="modern-card-content">
          <div className="animate-pulse">
            <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
            <div className="h-8 bg-gray-200 rounded w-1/2 mb-2"></div>
            <div className="h-3 bg-gray-200 rounded w-1/3"></div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-card">
      <div className="modern-card-content">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            {icon && (
              <div className={`p-2 rounded-lg ${getColorClass()}`}>
                {icon}
              </div>
            )}
            <div>
              <h3 className="text-sm font-medium text-gray-600">{title}</h3>
              {subtitle && (
                <p className="text-xs text-gray-500">{subtitle}</p>
              )}
            </div>
          </div>
          {trend && (
            <div className={`flex items-center gap-1 text-sm ${getTrendColor()}`}>
              {getTrendIcon()}
              <span className="font-medium">{trend.value}%</span>
            </div>
          )}
        </div>
        
        <div className="mb-2">
          <div className="text-2xl font-bold text-gray-900">
            {typeof value === 'number' ? value.toLocaleString() : value}
          </div>
        </div>
        
        {trend && (
          <div className="text-xs text-gray-500">
            {trend.label}
          </div>
        )}
      </div>
    </div>
  );
};

interface MiniStatCardProps {
  icon: React.ReactNode;
  value: string | number;
  label: string;
  color?: 'primary' | 'success' | 'warning' | 'danger' | 'info';
  loading?: boolean;
}

export const MiniStatCard: React.FC<MiniStatCardProps> = ({
  icon,
  value,
  label,
  color = 'primary',
  loading = false
}) => {
  const getColorClass = () => {
    switch (color) {
      case 'primary':
        return 'text-green-600 bg-green-50';
      case 'success':
        return 'text-green-600 bg-green-50';
      case 'warning':
        return 'text-yellow-600 bg-yellow-50';
      case 'danger':
        return 'text-red-600 bg-red-50';
      case 'info':
        return 'text-blue-600 bg-blue-50';
      default:
        return 'text-gray-600 bg-gray-50';
    }
  };

  if (loading) {
    return (
      <div className="modern-card">
        <div className="modern-card-content">
          <div className="animate-pulse">
            <div className="h-8 bg-gray-200 rounded w-1/2 mb-2"></div>
            <div className="h-4 bg-gray-200 rounded w-3/4"></div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-card">
      <div className="modern-card-content">
        <div className="flex items-center gap-3">
          <div className={`p-2 rounded-lg ${getColorClass()}`}>
            {icon}
          </div>
          <div>
            <div className="text-lg font-bold text-gray-900">
              {typeof value === 'number' ? value.toLocaleString() : value}
            </div>
            <div className="text-sm text-gray-600">{label}</div>
          </div>
        </div>
      </div>
    </div>
  );
};

interface ContentCardProps {
  title: string;
  subtitle?: string;
  icon?: React.ReactNode;
  children: React.ReactNode;
  actions?: React.ReactNode;
  loading?: boolean;
  className?: string;
}

export const ContentCard: React.FC<ContentCardProps> = ({
  title,
  subtitle,
  icon,
  children,
  actions,
  loading = false,
  className = ''
}) => {
  if (loading) {
    return (
      <div className={`modern-card ${className}`}>
        <div className="modern-card-header">
          <div className="animate-pulse">
            <div className="h-6 bg-gray-200 rounded w-1/3"></div>
          </div>
        </div>
        <div className="modern-card-content">
          <div className="animate-pulse space-y-3">
            <div className="h-4 bg-gray-200 rounded w-full"></div>
            <div className="h-4 bg-gray-200 rounded w-5/6"></div>
            <div className="h-4 bg-gray-200 rounded w-4/6"></div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className={`modern-card ${className}`}>
      <div className="modern-card-header">
        <div className="flex items-center gap-3">
          {icon && (
            <div className="text-green-600">
              {icon}
            </div>
          )}
          <div>
            <h2 className="modern-card-title">{title}</h2>
            {subtitle && (
              <p className="text-sm text-gray-600 mt-1">{subtitle}</p>
            )}
          </div>
        </div>
        {actions && (
          <div className="flex items-center gap-2">
            {actions}
          </div>
        )}
      </div>
      <div className="modern-card-content">
        {children}
      </div>
    </div>
  );
};

interface EmptyStateProps {
  icon: React.ReactNode;
  title: string;
  description: string;
  action?: React.ReactNode;
}

export const EmptyState: React.FC<EmptyStateProps> = ({
  icon,
  title,
  description,
  action
}) => {
  return (
    <div className="text-center py-12">
      <div className="mx-auto w-16 h-16 text-gray-400 mb-4">
        {icon}
      </div>
      <h3 className="text-lg font-medium text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600 mb-6 max-w-md mx-auto">{description}</p>
      {action && (
        <div className="flex justify-center">
          {action}
        </div>
      )}
    </div>
  );
};

interface LoadingStateProps {
  message?: string;
}

export const LoadingState: React.FC<LoadingStateProps> = ({
  message = 'Chargement...'
}) => {
  return (
    <div className="flex items-center justify-center py-12">
      <div className="text-center">
        <div className="loading-spinner mx-auto mb-4"></div>
        <p className="text-gray-600">{message}</p>
      </div>
    </div>
  );
};

interface ErrorStateProps {
  title?: string;
  message?: string;
  onRetry?: () => void;
}

export const ErrorState: React.FC<ErrorStateProps> = ({
  title = 'Une erreur est survenue',
  message = 'Impossible de charger les données',
  onRetry
}) => {
  return (
    <div className="text-center py-12">
      <div className="mx-auto w-16 h-16 text-red-400 mb-4">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
        </svg>
      </div>
      <h3 className="text-lg font-medium text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600 mb-6 max-w-md mx-auto">{message}</p>
      {onRetry && (
        <button
          onClick={onRetry}
          className="btn btn-primary"
        >
          Réessayer
        </button>
      )}
    </div>
  );
};
