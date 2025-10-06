# Variables d'environnement pour le déploiement

## Frontend (Vercel/Netlify)
REACT_APP_API_URL=https://votre-backend-url.up.railway.app/api/v1

## Backend (Railway/Render)
SPRING_DATASOURCE_URL=${{Postgres.DATABASE_URL}}
SPRING_DATASOURCE_USERNAME=${{Postgres.USERNAME}}
SPRING_DATASOURCE_PASSWORD=${{Postgres.PASSWORD}}
JWT_SECRET=votre-cle-secrete-jwt-tres-longue-et-aleatoire-changez-cela
SPRING_PROFILES_ACTIVE=production
