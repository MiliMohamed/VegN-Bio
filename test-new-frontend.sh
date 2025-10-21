#!/bin/bash

echo "🚀 Test du nouveau frontend VegN Bio"
echo "======================================"

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: package.json non trouvé. Assurez-vous d'être dans le répertoire web/"
    exit 1
fi

echo "📦 Installation des dépendances..."
npm install

echo "🔧 Vérification des fichiers..."
echo "✅ App.tsx - $(if [ -f "src/App.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernLandingPage.tsx - $(if [ -f "src/components/ModernLandingPage.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernLogin.tsx - $(if [ -f "src/components/ModernLogin.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernRegister.tsx - $(if [ -f "src/components/ModernRegister.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernDashboard.tsx - $(if [ -f "src/components/ModernDashboard.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernRestaurants.tsx - $(if [ -f "src/components/ModernRestaurants.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernMenus.tsx - $(if [ -f "src/components/ModernMenus.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernEvents.tsx - $(if [ -f "src/components/ModernEvents.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernRooms.tsx - $(if [ -f "src/components/ModernRooms.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernMarketplace.tsx - $(if [ -f "src/components/ModernMarketplace.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernReviews.tsx - $(if [ -f "src/components/ModernReviews.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernChatbot.tsx - $(if [ -f "src/components/ModernChatbot.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernUsers.tsx - $(if [ -f "src/components/ModernUsers.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernHeader.tsx - $(if [ -f "src/components/ModernHeader.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ ModernSidebar.tsx - $(if [ -f "src/components/ModernSidebar.tsx" ]; then echo "OK"; else echo "MANQUANT"; fi)"

echo ""
echo "🎨 Vérification des styles..."
echo "✅ modern-app.css - $(if [ -f "src/styles/modern-app.css" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ modern-landing.css - $(if [ -f "src/styles/modern-landing.css" ]; then echo "OK"; else echo "MANQUANT"; fi)"
echo "✅ modern-auth.css - $(if [ -f "src/styles/modern-auth.css" ]; then echo "OK"; else echo "MANQUANT"; fi)"

echo ""
echo "🔍 Test de compilation..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Compilation réussie !"
    echo ""
    echo "🌟 Le nouveau frontend VegN Bio est prêt !"
    echo ""
    echo "📋 Fonctionnalités implémentées :"
    echo "   • Page d'accueil moderne avec design stylé"
    echo "   • Système d'authentification complet"
    echo "   • Tableau de bord interactif"
    echo "   • Gestion des restaurants avec informations détaillées"
    echo "   • Menus végétariens et biologiques"
    echo "   • Réservation de salles de réunion"
    echo "   • Événements et animations"
    echo "   • Marketplace des fournisseurs bio"
    echo "   • Système d'avis clients"
    echo "   • Assistant IA chatbot"
    echo "   • Gestion des utilisateurs"
    echo ""
    echo "🚀 Pour démarrer l'application :"
    echo "   npm start"
    echo ""
    echo "🌐 L'application sera accessible sur http://localhost:3000"
else
    echo "❌ Erreur de compilation. Vérifiez les erreurs ci-dessus."
    exit 1
fi
