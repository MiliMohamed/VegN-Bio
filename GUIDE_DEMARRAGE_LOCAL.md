# 🚀 Guide de Démarrage Local - VegN-Bio Backend

Ce guide vous explique comment démarrer le backend VegN-Bio et PostgreSQL en local pour le développement.

## 📋 Prérequis

### Option 1: Développement avec Docker (Recommandé)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installé et démarré
- [Docker Compose](https://docs.docker.com/compose/install/) installé

### Option 2: Développement local
- [Java 17+](https://adoptium.net/) installé
- [Maven 3.6+](https://maven.apache.org/download.cgi) installé
- [PostgreSQL 15+](https://www.postgresql.org/download/) installé (ou Docker pour PostgreSQL)

## 🎯 Options de Démarrage

### Option A: Tout avec Docker (Plus Simple)
```bash
# Démarrer tous les services (PostgreSQL + Backend + Frontend)
start-all-docker.bat

# Arrêter tous les services
stop-docker.bat
```

### Option B: PostgreSQL avec Docker + Backend Local
```bash
# 1. Démarrer PostgreSQL avec Docker
start-postgres-local.bat

# 2. Dans un autre terminal, démarrer le backend
start-backend-local.bat
```

### Option C: Tout en local (PostgreSQL installé)
```bash
# 1. Démarrer PostgreSQL localement
# 2. Configurer la base de données vegnbiodb
# 3. Démarrer le backend
start-backend-local.bat
```

## 🔧 Configuration

### Variables d'Environnement
Les scripts configurent automatiquement ces variables :
- `SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/vegnbiodb`
- `SPRING_DATASOURCE_USERNAME=postgres`
- `SPRING_DATASOURCE_PASSWORD=postgres`
- `JWT_SECRET=a1f4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4`

### Ports Utilisés
- **PostgreSQL**: 5432
- **Backend API**: 8080
- **Frontend Web**: 3000 (si démarré avec Docker)

## 🧪 Tests

### Test Automatique
```bash
# Tester que l'API fonctionne
test-backend-api.bat
```

### Tests Manuels
- **API Health**: http://localhost:8080/actuator/health
- **Restaurants**: http://localhost:8080/api/restaurants
- **Documentation Swagger**: http://localhost:8080/swagger-ui.html
- **Base de données**: Connectez-vous avec pgAdmin ou un client PostgreSQL

## 🗄️ Base de Données

### Structure
La base de données `vegnbiodb` sera créée automatiquement avec :
- Tables créées par les migrations Flyway (V1 à V16)
- Données de démonstration insérées
- Utilisateurs de test créés

### Utilisateurs de Test
- **Admin**: admin@vegnbio.fr / admin123
- **Restaurateur**: restaurateur@vegnbio.fr / restaurateur123
- **Client**: client@vegnbio.fr / client123
- **Fournisseur**: fournisseur@vegnbio.fr / fournisseur123

## 🐛 Dépannage

### Problèmes Courants

#### 1. Port 5432 déjà utilisé
```bash
# Vérifier quel processus utilise le port
netstat -ano | findstr :5432

# Arrêter PostgreSQL local s'il est installé
# Ou changer le port dans docker-compose.yml
```

#### 2. Port 8080 déjà utilisé
```bash
# Vérifier quel processus utilise le port
netstat -ano | findstr :8080

# Arrêter l'application qui utilise le port
# Ou changer le port dans application.yml
```

#### 3. Erreur de connexion à la base
- Vérifiez que PostgreSQL est démarré
- Vérifiez les credentials dans les variables d'environnement
- Vérifiez que la base `vegnbiodb` existe

#### 4. Erreurs de migration Flyway
- Vérifiez que la base de données est vide ou compatible
- Supprimez les volumes Docker si nécessaire : `docker-compose down -v`

### Logs et Debug
```bash
# Voir les logs Docker
docker-compose logs

# Voir les logs d'un service spécifique
docker-compose logs db
docker-compose logs api

# Entrer dans le conteneur PostgreSQL
docker exec -it vegn_db psql -U postgres -d vegnbiodb
```

## 📁 Structure des Fichiers

```
VegN-Bio/
├── backend/                 # Code Spring Boot
├── devops/
│   └── docker-compose.yml   # Configuration Docker
├── start-postgres-local.bat # Script PostgreSQL seul
├── start-backend-local.bat # Script Backend seul
├── start-all-docker.bat    # Script tout avec Docker
├── stop-docker.bat         # Script arrêt Docker
└── test-backend-api.bat    # Script tests API
```

## 🚀 Prochaines Étapes

1. **Démarrer l'environnement** avec un des scripts
2. **Tester l'API** avec `test-backend-api.bat`
3. **Développer** en utilisant votre IDE préféré
4. **Tester les changements** en redémarrant le backend

## 💡 Conseils

- Utilisez **Docker** pour PostgreSQL même en développement local
- Gardez **Docker Desktop** démarré
- Utilisez **Postman** ou **Insomnia** pour tester l'API
- Consultez **Swagger UI** pour la documentation interactive
- Surveillez les **logs** pour diagnostiquer les problèmes

---

**Besoin d'aide ?** Consultez les logs ou contactez l'équipe de développement.
