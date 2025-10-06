# VegN-Bio - Application de Gestion de Restaurant Bio

Application web complète pour la gestion d'un restaurant bio végétarien, développée avec React (frontend) et Spring Boot (backend).

## 📁 Structure du Projet

```
VegN-Bio/
├── backend/          # API Spring Boot (Java)
├── web/             # Interface React (TypeScript)
├── devops/          # Configuration Docker et déploiement
└── README.md
```

### Backend (`backend/`)
- **Framework** : Spring Boot 3.3.3
- **Java** : Version 17
- **Base de données** : PostgreSQL
- **Authentification** : JWT
- **Architecture** : REST API avec modules modulaires

**Modules principaux :**
- `auth` - Authentification et gestion des utilisateurs
- `restaurant` - Gestion des restaurants
- `menu` - Gestion des menus et plats
- `events` - Gestion des événements
- `marketplace` - Marketplace pour produits bio
- `feedback` - Système d'avis et signalements
- `caisse` - Gestion de la caisse
- `allergen` - Gestion des allergènes

### Frontend (`web/`)
- **Framework** : React 18
- **Language** : TypeScript
- **Styling** : CSS personnalisé
- **Routing** : React Router DOM
- **HTTP Client** : Axios

**Composants principaux :**
- `Login` - Authentification
- `Dashboard` - Tableau de bord
- `Restaurants` - Gestion des restaurants
- `Menus` - Gestion des menus
- `Events` - Gestion des événements
- `Marketplace` - Marketplace
- `Reviews` - Avis et signalements

### DevOps (`devops/`)
- **Docker Compose** pour l'orchestration des services
- Configuration des services :
  - `db` - Base de données PostgreSQL
  - `api` - API Spring Boot
  - `web` - Interface React avec Nginx

## 🚀 Démarrage Rapide

### Prérequis
- Docker et Docker Compose
- Java 17 (pour le développement local)
- Node.js 18+ (pour le développement local)

### Lancement avec Docker
```bash
# Cloner le projet
git clone <repository-url>
cd VegN-Bio

# Lancer tous les services
docker-compose -f devops/docker-compose.yml up --build -d

# Vérifier que les services sont actifs
docker-compose -f devops/docker-compose.yml ps
```

### Accès aux Services
- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:8080
- **Base de données** : localhost:5432

### Comptes de Test
- **Administrateur** : `admin@vegnbio.com` / `admin123`
- **Restaurateur** : `chef@vegnbio.com` / `chef123`
- **Client** : `client@vegnbio.com` / `client123`

## 🛠️ Développement

### Backend (Spring Boot)
```bash
cd backend
./mvnw spring-boot:run
```

### Frontend (React)
```bash
cd web
npm install
npm start
```

### Base de données
```bash
# Connexion à PostgreSQL
psql -h localhost -p 5432 -U postgres -d vegnbiodb
```

## 📊 Fonctionnalités

### Gestion des Utilisateurs
- Authentification JWT
- Rôles : ADMIN, RESTAURATEUR, CLIENT
- Gestion des permissions

### Gestion des Restaurants
- CRUD des restaurants
- Gestion des informations (adresse, contact, etc.)

### Gestion des Menus
- Menus saisonniers
- Plats avec allergènes
- Prix et descriptions

### Événements
- Création d'événements (ateliers, conférences, dégustations)
- Réservations
- Gestion des capacités

### Marketplace
- Catalogue de produits bio
- Gestion des fournisseurs
- Suivi des stocks

### Système d'Avis
- Avis clients avec notes
- Modération des avis
- Signalements

## 🔧 Configuration

### Variables d'Environnement
Le fichier `devops/docker-compose.yml` contient toutes les configurations nécessaires :
- Base de données PostgreSQL
- JWT Secret
- URLs de connexion

### CORS
Configuration CORS pour permettre les requêtes depuis le frontend (port 3000).

## 📝 API Documentation

L'API est documentée avec OpenAPI/Swagger et accessible à :
http://localhost:8080/swagger-ui.html

## 🐳 Docker

### Services
- **vegn_db** : Base de données PostgreSQL
- **vegn_api** : API Spring Boot
- **vegn_web** : Interface React avec Nginx

### Commandes Utiles
```bash
# Voir les logs
docker-compose -f devops/docker-compose.yml logs -f

# Redémarrer un service
docker-compose -f devops/docker-compose.yml restart <service-name>

# Arrêter tous les services
docker-compose -f devops/docker-compose.yml down

# Nettoyer les volumes
docker-compose -f devops/docker-compose.yml down -v
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

- Développement Backend : Spring Boot
- Développement Frontend : React/TypeScript
- DevOps : Docker & Docker Compose
