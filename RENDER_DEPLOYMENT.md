# 🚀 Guide de Déploiement sur Render.com - VegN-Bio

## 📋 Prérequis
- Compte GitHub connecté
- Compte Render.com (gratuit)
- Repository VegN-Bio sur GitHub

---

## 🗄️ Étape 1 : Base de Données PostgreSQL

### Sur Render :
1. Allez sur [render.com](https://render.com)
2. **New** → **PostgreSQL**
3. **Configuration** :
   - **Name** : `vegnbio-db`
   - **Database** : `vegnbiodb`
   - **User** : `vegnbio_user`
   - **Region** : Europe (Frankfurt) ou US East
4. **Create Database** → Attendre la création (2-3 min)

---

## 🔧 Étape 2 : Backend Spring Boot

### Sur Render :
1. **New** → **Web Service**
2. **Connect Repository** → Sélectionner VegN-Bio
3. **Configuration** :
   - **Name** : `vegnbio-backend`
   - **Environment** : `Java`
   - **Branch** : `main`
   - **Root Directory** : `backend`
   - **Build Command** : `mvn clean package -DskipTests`
   - **Start Command** : `java -jar target/api-0.0.1-SNAPSHOT.jar`

4. **Variables d'environnement** :
   ```
   SPRING_DATASOURCE_URL=${DB_CONNECTION_STRING}
   SPRING_DATASOURCE_USERNAME=${DB_USERNAME}
   SPRING_DATASOURCE_PASSWORD=${DB_PASSWORD}
   JWT_SECRET=your-super-secret-jwt-key-very-long-and-random-123456789
   SPRING_PROFILES_ACTIVE=production
   ```

5. **Advanced** → **Auto-Deploy** : Yes
6. **Create Web Service** → Attendre le déploiement (5-10 min)

---

## 🌐 Étape 3 : Frontend React (Optionnel)

### Sur Render :
1. **New** → **Static Site**
2. **Connect Repository** → Sélectionner VegN-Bio
3. **Configuration** :
   - **Name** : `vegnbio-frontend`
   - **Branch** : `main`
   - **Root Directory** : `web`
   - **Build Command** : `npm run build`
   - **Publish Directory** : `build`

4. **Variables d'environnement** :
   ```
   REACT_APP_API_URL=https://votre-backend-url.onrender.com/api/v1
   ```

5. **Create Static Site** → Attendre le déploiement (3-5 min)

---

## ✅ Étape 4 : Test et Validation

### URLs générées :
- **Backend** : `https://vegnbio-backend.onrender.com`
- **Frontend** : `https://vegnbio-frontend.onrender.com`
- **API Docs** : `https://vegnbio-backend.onrender.com/swagger-ui.html`

### Tests à effectuer :
- [ ] Backend accessible
- [ ] Base de données connectée
- [ ] APIs publiques fonctionnelles :
  - `GET /api/v1/restaurants`
  - `GET /api/v1/allergens`
  - `GET /api/v1/menus/restaurant/{id}`

---

## 📱 Configuration pour App Mobile Flutter

### URL de Production :
```dart
const String BASE_URL = "https://vegnbio-backend.onrender.com";
```

### APIs publiques (sans authentification) :
```dart
class VegNBioAPI {
  // Restaurants
  static const String restaurants = "$BASE_URL/api/v1/restaurants";
  static const String restaurantById = "$BASE_URL/api/v1/restaurants";
  
  // Allergènes
  static const String allergens = "$BASE_URL/api/v1/allergens";
  static const String allergenByCode = "$BASE_URL/api/v1/allergens";
  
  // Menus
  static const String menusByRestaurant = "$BASE_URL/api/v1/menus/restaurant";
  static const String menuItemsByMenu = "$BASE_URL/api/v1/menu-items/menu";
  static const String searchMenuItems = "$BASE_URL/api/v1/menu-items/search";
}
```

---

## 🔧 Configuration CORS

Le fichier `CorsConfig.java` autorise déjà :
- `https://*.onrender.com`
- `https://*.vercel.app`
- `https://*.netlify.app`

---

## 💰 Limites Gratuites Render

### Backend (Web Service) :
- **750 heures/mois** gratuites
- **512 MB RAM**
- **Sleep après 15 min d'inactivité**

### Base de données (PostgreSQL) :
- **1 GB storage**
- **100 connexions max**
- **Backup automatique**

### Frontend (Static Site) :
- **100 GB bandwidth/mois**
- **HTTPS automatique**
- **CDN global**

---

## 🆘 Dépannage

### Problème : Service en sleep
**Solution** : Le service se réveille automatiquement au premier appel (2-3 sec de délai)

### Problème : Database connection failed
**Solution** : Vérifier les variables d'environnement dans Render Dashboard

### Problème : Build failed
**Solution** : Vérifier les logs dans Render Dashboard → Logs

---

## 🎉 Félicitations !

Votre backend VegN-Bio est maintenant déployé sur Render.com !

**URLs de production** :
- Backend : `https://vegnbio-backend.onrender.com`
- API publique : `https://vegnbio-backend.onrender.com/api/v1/restaurants`
- Documentation : `https://vegnbio-backend.onrender.com/swagger-ui.html`



