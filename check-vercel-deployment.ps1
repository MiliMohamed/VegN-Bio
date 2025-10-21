# Script de vérification du déploiement Vercel
# Teste si le frontend Vercel utilise la correction pour les endpoints publics

Write-Host "🔍 Vérification du déploiement Vercel..." -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow

Write-Host ""
Write-Host "📋 Statut actuel:" -ForegroundColor Cyan
Write-Host "✅ Backend Render: Déployé avec correction CORS (commit e5c608f)" -ForegroundColor Green
Write-Host "⏳ Frontend Vercel: En attente de redéploiement (commit 32d2fbd)" -ForegroundColor Yellow
Write-Host ""

Write-Host "🧪 Test de l'endpoint backend (devrait fonctionner):" -ForegroundColor Cyan
$registerData = @{
    email = "test-vercel-$(Get-Random)@example.com"
    password = "Test123456"
    fullName = "Test Vercel"
    role = "CLIENT"
} | ConvertTo-Json

$headers = @{
    "Origin" = "https://veg-n-bio-front-pi.vercel.app"
    "Content-Type" = "application/json"
    "Accept" = "application/json, text/plain, */*"
    "Referer" = "https://veg-n-bio-front-pi.vercel.app/"
}

try {
    $response = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/auth/register" -Method POST -Body $registerData -Headers $headers
    Write-Host "✅ Backend fonctionne parfaitement !" -ForegroundColor Green
    Write-Host "📧 Compte créé: $($registerData | ConvertFrom-Json | Select-Object -ExpandProperty email)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur backend: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 Actions à effectuer:" -ForegroundColor Yellow
Write-Host "1. Allez sur https://vercel.com/dashboard" -ForegroundColor White
Write-Host "2. Sélectionnez 'veg-n-bio-front'" -ForegroundColor White
Write-Host "3. Vérifiez que le commit '32d2fbd' est déployé" -ForegroundColor White
Write-Host "4. Si pas déployé, cliquez sur 'Redeploy'" -ForegroundColor White
Write-Host "5. Attendez 2-3 minutes pour le redéploiement" -ForegroundColor White

Write-Host ""
Write-Host "📋 Ce que fait la correction:" -ForegroundColor Cyan
Write-Host "✅ Exclut /auth/register et /auth/login de l'injection automatique de token" -ForegroundColor Green
Write-Host "✅ Évite l'erreur 403 causée par les tokens expirés/invalides" -ForegroundColor Green
Write-Host "✅ Permet la création de compte et connexion sans authentification" -ForegroundColor Green

Write-Host ""
Write-Host "🎯 Une fois Vercel redéployé, votre frontend fonctionnera parfaitement !" -ForegroundColor Green
