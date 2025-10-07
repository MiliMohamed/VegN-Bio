# VegnBio App

Une application mobile Flutter pour un restaurant bio et végétarien avec un assistant vétérinaire intégré.

## 🚀 Fonctionnalités

### 📱 Menu et Allergènes
- **Consultation des menus** avec filtres avancés
- **Gestion des allergènes** avec alertes visuelles
- **Filtres par régime** (végan, végétarien, sans gluten)
- **Recherche** par nom, description ou ingrédients
- **Détails complets** des plats (ingrédients, calories, temps de préparation)

### 🐾 Assistant Vétérinaire
- **Chatbot intelligent** pour le diagnostic vétérinaire
- **Base de données** de consultations vétérinaires
- **Analyse des symptômes** basée sur la race et les symptômes
- **Recommandations de traitement** avec niveau de confiance
- **Interface de chat** intuitive avec historique

### 🐛 Système de Reporting
- **Signaler les erreurs** de l'application
- **Suivi des rapports** avec niveaux de sévérité
- **Interface d'administration** pour les rapports
- **Retry automatique** des rapports échoués

## 🛠️ Technologies Utilisées

- **Flutter** - Framework de développement mobile
- **Provider** - Gestion d'état
- **HTTP/Dio** - Communication réseau
- **SQLite** - Base de données locale
- **Material Design 3** - Interface utilisateur moderne

## 📁 Structure du Projet

```
lib/
├── models/           # Modèles de données
├── providers/        # Gestion d'état avec Provider
├── screens/          # Écrans de l'application
├── widgets/          # Composants réutilisables
├── services/         # Services métier
└── utils/           # Utilitaires

assets/
├── images/          # Images des plats
├── icons/           # Icônes
└── data/            # Données JSON
```

## 🚀 Installation et Lancement

1. **Cloner le projet**
   ```bash
   git clone [url-du-repo]
   cd vegn_bio_app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📱 Écrans Principaux

### 1. Écran Menu
- Liste des plats avec filtres
- Cartes détaillées pour chaque plat
- Système de recherche avancé
- Gestion des allergènes

### 2. Assistant Vétérinaire
- Interface de chat
- Formulaire d'informations animal
- Sélecteur de symptômes
- Diagnostic avec confiance

### 3. Rapports d'Erreurs
- Liste des rapports
- Formulaire de signalement
- Statistiques des erreurs
- Système de retry

## 🔧 Configuration

### Variables d'Environnement
L'application utilise des données de démonstration. Pour la production :

1. Configurer l'API backend dans `lib/services/`
2. Ajouter les vraies images dans `assets/images/`
3. Configurer Firebase pour le reporting (optionnel)

### Base de Données
L'application utilise SQLite pour le stockage local des :
- Consultations vétérinaires
- Rapports d'erreurs
- Cache des menus

## 🎨 Design

L'application utilise Material Design 3 avec :
- **Couleur principale** : Vert (bio/écologique)
- **Navigation** : Bottom Navigation Bar
- **Cartes** : Design moderne avec ombres
- **Animations** : Transitions fluides

## 📊 Données de Démonstration

L'application inclut des données de test pour :
- **Menu** : 6 plats avec différentes catégories
- **Consultations vétérinaires** : 4 cas réels
- **Symptômes** : Base de données de symptômes courants

## 🔮 Améliorations Futures

- [ ] Authentification utilisateur
- [ ] Système de commandes
- [ ] Notifications push
- [ ] Mode hors ligne
- [ ] Intégration Firebase
- [ ] Tests automatisés
- [ ] Internationalisation

## 👥 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Créer une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

Pour toute question ou problème :
- Ouvrir une issue sur GitHub
- Contacter l'équipe de développement

---

**VegnBio App** - Une application moderne pour restaurant bio avec assistant vétérinaire 🥗🐾
