import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

export type Theme = 'light' | 'dark' | 'system';

interface ThemeContextType {
  theme: Theme;
  actualTheme: 'light' | 'dark';
  setTheme: (theme: Theme) => void;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};

interface ThemeProviderProps {
  children: ReactNode;
}

export const ThemeProvider: React.FC<ThemeProviderProps> = ({ children }) => {
  const [theme, setThemeState] = useState<Theme>(() => {
    // Forcer le mode clair uniquement
    return 'light';
  });

  const [actualTheme, setActualTheme] = useState<'light' | 'dark'>('light');

  useEffect(() => {
    // Toujours utiliser le mode clair
    setActualTheme('light');
  }, [theme]);

  useEffect(() => {
    // Appliquer le thème clair au document
    document.documentElement.setAttribute('data-theme', 'light');
    document.body.className = 'light-theme';
  }, [actualTheme]);

  const setTheme = (newTheme: Theme) => {
    // Forcer le mode clair même si on essaie de changer
    setThemeState('light');
    localStorage.setItem('theme', 'light');
  };

  const toggleTheme = () => {
    // Ne rien faire, garder le mode clair
    setTheme('light');
  };

  const value: ThemeContextType = {
    theme,
    actualTheme,
    setTheme,
    toggleTheme,
  };

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
};
