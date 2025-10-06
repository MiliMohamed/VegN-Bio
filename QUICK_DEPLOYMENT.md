# 🚀 Instructions de Déploiement Rapide - VegN-Bio

## ⚡ Déploiement en 15 minutes

### 🎯 Option Recommandée : Railway + Vercel

---

## 📋 Checklist Pré-déploiement

- [ ] Code committé sur GitHub
- [ ] Comptes Railway et Vercel créés
- [ ] Variables d'environnement préparées

---

## 🗄️ 1. Base de Données PostgreSQL (Railway)

### Étapes :
1. **Railway** → Nouveau projet
2. **Add Service** → PostgreSQL
3. **Attendre** la création (2-3 min)
4. **Noter** les variables générées automatiquement

---

## 🔧 2. Backend Spring Boot (Railway)

### Étapes :
1. **Même projet Railway** → Add Service → GitHub Repo
2. **Sélectionner** votre repository VegN-Bio
3. **Variables d'environnement** :
   ```
   SPRING_DATASOURCE_URL=${{Postgres.DATABASE_URL}}
   SPRING_DATASOURCE_USERNAME=${{Postgres.USERNAME}}
   SPRING_DATASOURCE_PASSWORD=${{Postgres.PASSWORD}}
   JWT_SECRET=ma-cle-secrete-super-longue-et-aleatoire-123456789
   SPRING_PROFILES_ACTIVE=production
   ```
4. **Déployer** → Attendre le build (5-10 min)
5. **Copier** l'URL du backend (ex: `https://vegnbio-backend-production.up.railway.app`)

---

## 🌐 3. Frontend React (Vercel)

### Étapes :
1. **Vercel** → Import Project
2. **Repository** → Sélectionner VegN-Bio
3. **Configuration** :
   - Framework: Create React App
   - Root Directory: `web`
   - Build Command: `npm run build`
   - Output Directory: `build`
4. **Variables d'environnement** :
   ```
   REACT_APP_API_URL=https://votre-backend-url.up.railway.app/api/v1
   ```
5. **Deploy** → Attendre (2-3 min)

---

## ✅ 4. Test et Validation

### Tests à effectuer :
- [ ] Frontend accessible
- [ ] Connexion à l'API fonctionne
- [ ] Base de données connectée
- [ ] Authentification opérationnelle
- [ ] CORS configuré correctement

---

## 🔧 Configuration CORS (Déjà fait)

Le fichier `CorsConfig.java` a été mis à jour pour autoriser :
- `https://*.vercel.app`
- `https://*.netlify.app`
- `https://*.railway.app`

---

## 🆘 Dépannage Rapide

### Problème : CORS Error
**Solution** : Vérifier que l'URL frontend est dans CorsConfig.java

### Problème : Database Connection Failed
**Solution** : Vérifier les variables d'environnement Railway

### Problème : Build Failed
**Solution** : Vérifier les logs Railway/Vercel

---

## 📊 Monitoring

### Railway :
- Logs en temps réel
- Métriques de performance
- Usage des ressources

### Vercel :
- Analytics de performance
- Logs de déploiement
- Métriques de bande passante

---

## 💰 Coûts

### Gratuit jusqu'à :
- **Railway** : 500h/mois, 1GB RAM
- **Vercel** : 100GB bandwidth/mois
- **PostgreSQL** : 1GB storage

### Estimation pour un projet moyen :
- **Utilisation** : ~200h/mois
- **Coût** : 0€/mois

---

## 🎉 Félicitations !

Votre application VegN-Bio est maintenant en ligne !

**URLs** :
- Frontend : `https://votre-app.vercel.app`
- Backend : `https://votre-backend.up.railway.app`
- API Docs : `https://votre-backend.up.railway.app/swagger-ui.html`
