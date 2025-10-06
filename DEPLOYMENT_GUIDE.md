# Guide de Déploiement Gratuit - VegN-Bio

## 🚀 Déploiement Recommandé : Railway + Vercel

### 📋 Prérequis
- Compte GitHub
- Compte Railway (gratuit)
- Compte Vercel (gratuit)

---

## 🗄️ Étape 1 : Déployer la Base de Données PostgreSQL

### Sur Railway :
1. Allez sur [railway.app](https://railway.app)
2. Connectez votre compte GitHub
3. Créez un nouveau projet
4. Ajoutez un service **PostgreSQL**
5. Railway générera automatiquement les variables d'environnement

---

## 🔧 Étape 2 : Déployer le Backend (Spring Boot)

### Sur Railway :
1. Dans le même projet Railway, ajoutez un service **GitHub Repo**
2. Sélectionnez votre repository VegN-Bio
3. Railway détectera automatiquement que c'est un projet Java/Maven
4. Configurez les variables d'environnement :

```
SPRING_DATASOURCE_URL=${{Postgres.DATABASE_URL}}
SPRING_DATASOURCE_USERNAME=${{Postgres.USERNAME}}
SPRING_DATASOURCE_PASSWORD=${{Postgres.PASSWORD}}
JWT_SECRET=votre-cle-secrete-jwt-tres-longue-et-aleatoire
SPRING_PROFILES_ACTIVE=production
```

5. Railway construira et déploiera automatiquement votre backend
6. Notez l'URL générée (ex: `https://vegnbio-backend-production.up.railway.app`)

---

## 🌐 Étape 3 : Déployer le Frontend (React)

### Sur Vercel :
1. Allez sur [vercel.com](https://vercel.com)
2. Connectez votre compte GitHub
3. Importez votre repository VegN-Bio
4. Configurez le projet :
   - **Framework Preset** : Create React App
   - **Root Directory** : `web`
   - **Build Command** : `npm run build`
   - **Output Directory** : `build`

5. Ajoutez la variable d'environnement :
   ```
   REACT_APP_API_URL=https://votre-backend-url.up.railway.app/api/v1
   ```

6. Déployez !

---

## 🔄 Étape 4 : Configuration CORS

Modifiez votre fichier `backend/src/main/java/com/vegnbio/api/config/CorsConfig.java` pour autoriser votre domaine Vercel :

```java
@Configuration
public class CorsConfig {
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Arrays.asList(
            "http://localhost:3000",
            "https://votre-app.vercel.app"
        ));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

---

## 🎯 Alternatives Gratuites

### Option 2 : Render.com
- **Frontend** : Render Static Site
- **Backend** : Render Web Service
- **Base de données** : Render PostgreSQL

### Option 3 : Fly.io
- Déploiement complet avec Docker
- Base de données PostgreSQL incluse

### Option 4 : Netlify + Railway
- **Frontend** : Netlify
- **Backend + DB** : Railway

---

## 📝 Notes Importantes

1. **Limites gratuites** :
   - Railway : 500h/mois, 1GB RAM
   - Vercel : 100GB bandwidth/mois
   - Render : 750h/mois

2. **Sécurité** :
   - Changez le JWT_SECRET en production
   - Configurez les domaines autorisés en CORS

3. **Monitoring** :
   - Utilisez les logs Railway et Vercel
   - Surveillez l'utilisation des ressources

---

## 🆘 Dépannage

### Problèmes courants :
1. **CORS errors** : Vérifiez la configuration CORS
2. **Database connection** : Vérifiez les variables d'environnement
3. **Build failures** : Vérifiez les logs de build

### Support :
- Railway : [docs.railway.app](https://docs.railway.app)
- Vercel : [vercel.com/docs](https://vercel.com/docs)
