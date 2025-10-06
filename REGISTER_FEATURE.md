# Page d'inscription VegN-Bio

## Fonctionnalités implémentées

### ✅ Composants créés
- **SimpleRegister.tsx** : Page d'inscription avec design simple et moderne
- **ModernRegister.tsx** : Page d'inscription avec animations (framer-motion)

### ✅ Routes ajoutées
- Route `/register` ajoutée dans `App.tsx`
- Lien vers l'inscription ajouté sur toutes les pages de connexion
- Navigation bidirectionnelle entre login et register

### ✅ Fonctionnalités de la page d'inscription
- **Champs du formulaire** :
  - Nom complet (obligatoire)
  - Adresse email (obligatoire, validation email)
  - Type de compte (CLIENT, RESTAURATEUR, FOURNISSEUR, ADMIN)
  - Mot de passe (minimum 6 caractères)
  - Confirmation du mot de passe
- **Validation côté client** :
  - Vérification de la correspondance des mots de passe
  - Validation de la longueur du mot de passe
  - Gestion des erreurs d'API
- **Intégration avec l'API** :
  - Appel à `/api/v1/auth/register`
  - Connexion automatique après inscription
  - Redirection vers le dashboard

### ✅ Design et UX
- Interface cohérente avec le reste de l'application
- Design responsive (mobile et desktop)
- Animations fluides (version Modern)
- Messages d'erreur clairs
- Indicateurs de chargement
- Boutons de basculement pour afficher/masquer les mots de passe

## Comment tester

### 1. Interface web
1. Démarrer le frontend : `cd web && npm start`
2. Ouvrir http://localhost:3000/register
3. Remplir le formulaire d'inscription
4. Vérifier la redirection vers le dashboard

### 2. API backend
1. Démarrer le backend : `cd backend && mvn spring-boot:run`
2. Utiliser le script de test : `./test_register_api.sh`
3. Ou tester manuellement avec curl/Postman

### 3. Navigation
- Depuis la page d'accueil : bouton "S'inscrire gratuitement"
- Depuis la page de connexion : lien "Créer un compte"
- Depuis la page d'inscription : lien "Se connecter"

## Types de comptes disponibles
- **CLIENT** : Utilisateurs finaux pour commander et réserver
- **RESTAURATEUR** : Gestionnaires de restaurants
- **FOURNISSEUR** : Fournisseurs de produits biologiques
- **ADMIN** : Administrateurs système

## Sécurité
- Mots de passe hachés côté backend
- Validation des données côté client et serveur
- Gestion des erreurs d'inscription (email déjà utilisé, etc.)
- Tokens JWT pour l'authentification après inscription
