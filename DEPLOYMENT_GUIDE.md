# 🚀 Guide de Déploiement VegN-Bio

## 📋 Vue d'ensemble

Ce guide explique comment déployer l'application VegN-Bio avec des comptes utilisateurs de production sur votre backend Render.com.

## 🌐 Configuration de Production

### Backend sur Render.com
- **URL**: https://vegn-bio-backend.onrender.com
- **API**: https://vegn-bio-backend.onrender.com/api

## 🔧 Scripts de Déploiement

### 1. Script Principal de Déploiement
```powershell
# Déploiement complet (recommandé)
.\deploy-production.ps1
```

### 2. Scripts Individuels

#### Créer les Utilisateurs de Production
```powershell
# Windows
cd backend
.\create-production-users.ps1

# Linux/Mac
cd backend
./create-production-users.sh
```

#### Configurer le Frontend
```powershell
cd web
.\update-api-config.ps1
```

#### Tester les Comptes
```powershell
cd backend
.\test-production-users.sh
```

## 👥 Comptes Utilisateurs Créés

### 🔐 Administrateurs (3 comptes)
| Email | Mot de passe | Rôle | Description |
|-------|-------------|------|-------------|
| admin@vegnbio.com | AdminVegN2024! | ADMIN | Super administrateur |
| manager@vegnbio.com | ManagerVegN2024! | ADMIN | Manager opérationnel |
| support@vegnbio.com | SupportVegN2024! | ADMIN | Support technique |

### 🏪 Restaurateurs (7 comptes)
| Email | Mot de passe | Restaurant |
|-------|-------------|------------|
| bastille@vegnbio.com | Bastille2024! | Veg'N Bio Bastille |
| republique@vegnbio.com | Republique2024! | Veg'N Bio République |
| nation@vegnbio.com | Nation2024! | Veg'N Bio Nation |
| italie@vegnbio.com | Italie2024! | Veg'N Bio Place d'Italie |
| montparnasse@vegnbio.com | Montparnasse2024! | Veg'N Bio Montparnasse |
| ivry@vegnbio.com | Ivry2024! | Veg'N Bio Ivry |
| beaubourg@vegnbio.com | Beaubourg2024! | Veg'N Bio Beaubourg |

### 🚚 Fournisseurs (6 comptes)
| Email | Mot de passe | Spécialité |
|-------|-------------|------------|
| biofrance@supplier.com | BioFrance2024! | Produits bio certifiés |
| terroir@supplier.com | Terroir2024! | Légumes locaux |
| grains@supplier.com | Grains2024! | Céréales bio |
| epices@supplier.com | Epices2024! | Épices bio |
| proteines@supplier.com | Proteines2024! | Protéines végétales |
| boissons@supplier.com | Boissons2024! | Jus et thés naturels |

### 👥 Clients VIP (8 comptes)
| Email | Mot de passe | Nom |
|-------|-------------|-----|
| client1@example.com | Client12024! | Alice Dupont |
| client2@example.com | Client22024! | Bob Martin |
| client3@example.com | Client32024! | Claire Dubois |
| client4@example.com | Client42024! | David Bernard |
| client5@example.com | Client52024! | Emma Leroy |
| client6@example.com | Client62024! | François Moreau |
| client7@example.com | Client72024! | Gabrielle Petit |
| client8@example.com | Client82024! | Henri Rousseau |

## 🚀 Étapes de Déploiement

### 1. Prérequis
- Backend déployé sur Render.com
- Node.js installé localement
- PowerShell (Windows) ou Bash (Linux/Mac)

### 2. Déploiement Automatique
```powershell
# Cloner le repository
git clone https://github.com/MiliMohamed/VegN-Bio.git
cd VegN-Bio

# Exécuter le script de déploiement
.\deploy-production.ps1
```

### 3. Déploiement Manuel

#### Étape 1: Créer les utilisateurs
```powershell
cd backend
.\create-production-users.ps1
```

#### Étape 2: Configurer le frontend
```powershell
cd ../web
.\update-api-config.ps1
```

#### Étape 3: Tester la connexion
```powershell
cd ../backend
.\test-production-users.sh
```

## 🧪 Tests de Validation

### Test de Connexion API
```bash
curl -X POST https://vegn-bio-backend.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@vegnbio.com","password":"AdminVegN2024!"}'
```

### Test Frontend
1. Démarrer le frontend: `cd web && npm start`
2. Ouvrir http://localhost:3000
3. Se connecter avec un des comptes ci-dessus
4. Tester les fonctionnalités

## 📁 Fichiers de Configuration

### Backend
- `backend/production-users.json` - Liste complète des comptes
- `backend/create-production-users.ps1` - Script de création Windows
- `backend/create-production-users.sh` - Script de création Linux/Mac
- `backend/test-production-users.sh` - Script de test

### Frontend
- `web/update-api-config.ps1` - Configuration API production
- `web/.env.production` - Variables d'environnement

### Déploiement
- `deploy-production.ps1` - Script de déploiement complet
- `DEPLOYMENT_GUIDE.md` - Ce guide

## 🔧 Configuration Avancée

### Variables d'Environnement Frontend
```env
REACT_APP_API_URL=https://vegn-bio-backend.onrender.com/api
REACT_APP_APP_NAME=VegN-Bio
REACT_APP_ENVIRONMENT=production
REACT_APP_BACKEND_URL=https://vegn-bio-backend.onrender.com
```

### Configuration API Backend
- URL: https://vegn-bio-backend.onrender.com/api
- Authentification: JWT Token
- CORS: Configuré pour le frontend

## 🛠️ Dépannage

### Problèmes Courants

#### Backend non accessible
- Vérifier que Render.com est en cours d'exécution
- Vérifier l'URL du backend
- Vérifier les logs sur Render.com

#### Erreur de connexion
- Vérifier les identifiants
- Vérifier que l'utilisateur existe
- Vérifier la connectivité réseau

#### Frontend ne se connecte pas
- Vérifier la configuration API
- Vérifier le fichier .env.production
- Redémarrer l'application frontend

### Logs et Debug
```powershell
# Vérifier les logs du backend
curl -X GET https://vegn-bio-backend.onrender.com/api/health

# Tester la connectivité
ping vegn-bio-backend.onrender.com
```

## 📞 Support

En cas de problème:
1. Vérifier les logs d'erreur
2. Consulter la documentation API
3. Tester avec les comptes de démonstration
4. Vérifier la configuration réseau

## 🎉 Félicitations !

Votre application VegN-Bio est maintenant déployée en production avec tous les comptes utilisateurs nécessaires !

### Accès Rapide
- **Frontend**: http://localhost:3000 (après `npm start`)
- **Backend**: https://vegn-bio-backend.onrender.com
- **API**: https://vegn-bio-backend.onrender.com/api

### Première Connexion
Utilisez le compte admin pour explorer toutes les fonctionnalités:
- **Email**: admin@vegnbio.com
- **Mot de passe**: AdminVegN2024!