# Test du nouveau frontend VegN Bio
Write-Host "🚀 Test du nouveau frontend VegN Bio" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

# Vérifier que nous sommes dans le bon répertoire
if (-not (Test-Path "package.json")) {
    Write-Host "❌ Erreur: package.json non trouvé. Assurez-vous d'être dans le répertoire web/" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Installation des dépendances..." -ForegroundColor Yellow
npm install

Write-Host "🔧 Vérification des fichiers..." -ForegroundColor Yellow
$files = @(
    "src/App.tsx",
    "src/components/ModernLandingPage.tsx",
    "src/components/ModernLogin.tsx",
    "src/components/ModernRegister.tsx",
    "src/components/ModernDashboard.tsx",
    "src/components/ModernRestaurants.tsx",
    "src/components/ModernMenus.tsx",
    "src/components/ModernEvents.tsx",
    "src/components/ModernRooms.tsx",
    "src/components/ModernMarketplace.tsx",
    "src/components/ModernReviews.tsx",
    "src/components/ModernChatbot.tsx",
    "src/components/ModernUsers.tsx",
    "src/components/ModernHeader.tsx",
    "src/components/ModernSidebar.tsx"
)

foreach ($file in $files) {
    $status = if (Test-Path $file) { "OK" } else { "MANQUANT" }
    $color = if ($status -eq "OK") { "Green" } else { "Red" }
    Write-Host "✅ $file - $status" -ForegroundColor $color
}

Write-Host ""
Write-Host "🎨 Vérification des styles..." -ForegroundColor Yellow
$styles = @(
    "src/styles/modern-app.css",
    "src/styles/modern-landing.css",
    "src/styles/modern-auth.css"
)

foreach ($style in $styles) {
    $status = if (Test-Path $style) { "OK" } else { "MANQUANT" }
    $color = if ($status -eq "OK") { "Green" } else { "Red" }
    Write-Host "✅ $style - $status" -ForegroundColor $color
}

Write-Host ""
Write-Host "🔍 Test de compilation..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Compilation réussie !" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌟 Le nouveau frontend VegN Bio est prêt !" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Fonctionnalités implémentées :" -ForegroundColor Cyan
    Write-Host "   • Page d'accueil moderne avec design stylé" -ForegroundColor White
    Write-Host "   • Système d'authentification complet" -ForegroundColor White
    Write-Host "   • Tableau de bord interactif" -ForegroundColor White
    Write-Host "   • Gestion des restaurants avec informations détaillées" -ForegroundColor White
    Write-Host "   • Menus végétariens et biologiques" -ForegroundColor White
    Write-Host "   • Réservation de salles de réunion" -ForegroundColor White
    Write-Host "   • Événements et animations" -ForegroundColor White
    Write-Host "   • Marketplace des fournisseurs bio" -ForegroundColor White
    Write-Host "   • Système d'avis clients" -ForegroundColor White
    Write-Host "   • Assistant IA chatbot" -ForegroundColor White
    Write-Host "   • Gestion des utilisateurs" -ForegroundColor White
    Write-Host ""
    Write-Host "🚀 Pour démarrer l'application :" -ForegroundColor Yellow
    Write-Host "   npm start" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 L'application sera accessible sur http://localhost:3000" -ForegroundColor Cyan
} else {
    Write-Host "❌ Erreur de compilation. Vérifiez les erreurs ci-dessus." -ForegroundColor Red
    exit 1
}
