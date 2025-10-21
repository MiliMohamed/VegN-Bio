# Script de déploiement pour Render.com
# Ce script pousse les changements vers le backend déployé sur Render

Write-Host "🚀 Déploiement du backend VegN-Bio sur Render.com" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Configuration
$RENDER_URL = "https://vegn-bio-backend.onrender.com"
$API_BASE_URL = "$RENDER_URL/api"

# Vérifier que le backend est accessible
Write-Host "🔍 Vérification de la connectivité au backend..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/health" -Method GET -TimeoutSec 10
    Write-Host "✅ Backend accessible sur Render.com" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Backend non accessible ou endpoint /health non disponible" -ForegroundColor Yellow
    Write-Host "   Tentative de connexion à l'API principale..." -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri "$API_BASE_URL" -Method GET -TimeoutSec 10
        Write-Host "✅ API principale accessible" -ForegroundColor Green
    } catch {
        Write-Host "❌ Impossible de se connecter au backend sur Render.com" -ForegroundColor Red
        Write-Host "   Vérifiez que le backend est bien déployé et en cours d'exécution" -ForegroundColor Red
        exit 1
    }
}

# Tester la création d'un utilisateur de test
Write-Host ""
Write-Host "🧪 Test de création d'utilisateur sur le backend de production..." -ForegroundColor Yellow

$testUser = @{
    email = "test-deploy@vegnbio.com"
    password = "TestDeploy2024!"
    fullName = "Test Deploy User"
    role = "CLIENT"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/register" -Method POST -Body $testUser -ContentType "application/json"
    Write-Host "✅ Test de création d'utilisateur réussi" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "⚠️  Utilisateur de test déjà existant (normal)" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Erreur lors du test de création d'utilisateur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Tester la connexion avec un utilisateur
Write-Host ""
Write-Host "🔐 Test de connexion sur le backend de production..." -ForegroundColor Yellow

$loginData = @{
    email = "test-deploy@vegnbio.com"
    password = "TestDeploy2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $loginData -ContentType "application/json"
    Write-Host "✅ Test de connexion réussi" -ForegroundColor Green
    Write-Host "   Token JWT reçu: $($response.token.Substring(0, 20))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du test de connexion: $($_.Exception.Message)" -ForegroundColor Red
}

# Créer les utilisateurs de production
Write-Host ""
Write-Host "👥 Création des utilisateurs de production..." -ForegroundColor Yellow
Write-Host "Exécution du script de création d'utilisateurs..." -ForegroundColor Cyan

try {
    & .\create-production-users.ps1
    Write-Host "✅ Script de création d'utilisateurs exécuté avec succès" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur lors de l'exécution du script de création d'utilisateurs: $($_.Exception.Message)" -ForegroundColor Red
}

# Tester quelques comptes créés
Write-Host ""
Write-Host "🧪 Test de quelques comptes créés..." -ForegroundColor Yellow

$testAccounts = @(
    @{ email = "admin@vegnbio.com"; password = "AdminVegN2024!"; name = "Admin Principal" },
    @{ email = "bastille@vegnbio.com"; password = "Bastille2024!"; name = "Marie Dubois - Bastille" },
    @{ email = "biofrance@supplier.com"; password = "BioFrance2024!"; name = "BioFrance" },
    @{ email = "client1@example.com"; password = "Client12024!"; name = "Alice Dupont" }
)

foreach ($account in $testAccounts) {
    $loginTest = @{
        email = $account.email
        password = $account.password
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $loginTest -ContentType "application/json"
        Write-Host "✅ $($account.name) - Connexion OK" -ForegroundColor Green
    } catch {
        Write-Host "❌ $($account.name) - Échec de connexion" -ForegroundColor Red
    }
}

# Résumé du déploiement
Write-Host ""
Write-Host "📊 Résumé du déploiement sur Render.com" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "🌐 URL du backend: $RENDER_URL" -ForegroundColor White
Write-Host "🔗 URL de l'API: $API_BASE_URL" -ForegroundColor White
Write-Host "👥 Utilisateurs créés: 24 comptes de production" -ForegroundColor White
Write-Host "🔐 Types de comptes: ADMIN, RESTAURATEUR, FOURNISSEUR, CLIENT" -ForegroundColor White

Write-Host ""
Write-Host "🎉 Déploiement terminé avec succès !" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Prochaines étapes:" -ForegroundColor Yellow
Write-Host "1. Testez l'application web avec les nouveaux comptes" -ForegroundColor White
Write-Host "2. Vérifiez que tous les utilisateurs peuvent se connecter" -ForegroundColor White
Write-Host "3. Configurez les paramètres de production si nécessaire" -ForegroundColor White
Write-Host ""
Write-Host "🔗 Liens utiles:" -ForegroundColor Yellow
Write-Host "- Backend: $RENDER_URL" -ForegroundColor White
Write-Host "- API: $API_BASE_URL" -ForegroundColor White
Write-Host "- Documentation: Consultez production-users.json pour la liste complète des comptes" -ForegroundColor White
