import React from 'react';
import { Moon, Sun } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';

interface ThemeToggleProps {
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

const ThemeToggle: React.FC<ThemeToggleProps> = ({ 
  size = 'md', 
  className = '' 
}) => {
  const { actualTheme, toggleTheme } = useTheme();

  const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12'
  };

  const iconSizes = {
    sm: 'w-4 h-4',
    md: 'w-5 h-5',
    lg: 'w-6 h-6'
  };

  return (
    <button 
      className={`theme-toggle ${sizeClasses[size]} ${className}`}
      onClick={toggleTheme}
      title={`Basculer vers le mode ${actualTheme === 'light' ? 'sombre' : 'clair'}`}
      aria-label={`Basculer vers le mode ${actualTheme === 'light' ? 'sombre' : 'clair'}`}
    >
      {actualTheme === 'light' ? 
        <Moon className={iconSizes[size]} /> : 
        <Sun className={iconSizes[size]} />
      }
    </button>
  );
};

export default ThemeToggle;
