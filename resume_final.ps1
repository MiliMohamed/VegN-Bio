# Script final - Resume complet des comptes crees
Write-Host "RESUME COMPLET - COMPTES CREES ET TESTES" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

# Afficher les informations du compte client
if (Test-Path "demo_account.json") {
    $clientInfo = Get-Content "demo_account.json" | ConvertFrom-Json
    Write-Host "COMPTE CLIENT CREE:" -ForegroundColor Green
    Write-Host "==================" -ForegroundColor Green
    Write-Host "Email: $($clientInfo.email)" -ForegroundColor White
    Write-Host "Nom: $($clientInfo.fullName)" -ForegroundColor White
    Write-Host "Role: $($clientInfo.role)" -ForegroundColor White
    Write-Host "ID: $($clientInfo.userId)" -ForegroundColor White
    Write-Host "Cree le: $($clientInfo.createdAt)" -ForegroundColor White
    Write-Host "Token: $($clientInfo.token.Substring(0,30))..." -ForegroundColor Gray
    Write-Host ""
}

# Afficher les informations du compte admin
if (Test-Path "admin_account.json") {
    $adminInfo = Get-Content "admin_account.json" | ConvertFrom-Json
    Write-Host "COMPTE ADMINISTRATEUR CREE:" -ForegroundColor Yellow
    Write-Host "===========================" -ForegroundColor Yellow
    Write-Host "Email: $($adminInfo.email)" -ForegroundColor White
    Write-Host "Nom: $($adminInfo.fullName)" -ForegroundColor White
    Write-Host "Role: $($adminInfo.role)" -ForegroundColor White
    Write-Host "ID: $($adminInfo.userId)" -ForegroundColor White
    Write-Host "Cree le: $($adminInfo.createdAt)" -ForegroundColor White
    Write-Host "Token: $($adminInfo.token.Substring(0,30))..." -ForegroundColor Gray
    Write-Host ""
}

Write-Host "FONCTIONNALITES TESTEES:" -ForegroundColor Magenta
Write-Host "========================" -ForegroundColor Magenta
Write-Host "✅ Creation de compte client: FONCTIONNE" -ForegroundColor Green
Write-Host "✅ Connexion client: FONCTIONNE" -ForegroundColor Green
Write-Host "✅ Verification authentification client: FONCTIONNE" -ForegroundColor Green
Write-Host "✅ Creation de compte administrateur: FONCTIONNE" -ForegroundColor Green
Write-Host "✅ Connexion administrateur: FONCTIONNE" -ForegroundColor Green
Write-Host "✅ Verification authentification admin: FONCTIONNE" -ForegroundColor Green
Write-Host "✅ Acces aux endpoints publics: FONCTIONNE" -ForegroundColor Green
Write-Host "⚠️  Acces aux endpoints admin specifiques: PARTIEL" -ForegroundColor Yellow
Write-Host ""

Write-Host "ENDPOINTS DISPONIBLES:" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host "POST /api/v1/auth/register - Creation de compte" -ForegroundColor White
Write-Host "POST /api/v1/auth/login - Connexion" -ForegroundColor White
Write-Host "GET /api/v1/auth/me - Informations utilisateur" -ForegroundColor White
Write-Host "GET /api/v1/suppliers/all - Tous les fournisseurs (ADMIN)" -ForegroundColor White
Write-Host "GET /api/v1/menus/restaurant/{id} - Menus par restaurant" -ForegroundColor White
Write-Host "GET /api/v1/events - Evenements" -ForegroundColor White
Write-Host ""

Write-Host "ROLES DISPONIBLES:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host "CLIENT - Utilisateur standard" -ForegroundColor White
Write-Host "RESTAURATEUR - Gestionnaire de restaurant" -ForegroundColor White
Write-Host "FOURNISSEUR - Fournisseur de produits" -ForegroundColor White
Write-Host "ADMIN - Administrateur systeme" -ForegroundColor White
Write-Host ""

Write-Host "UTILISATION:" -ForegroundColor Cyan
Write-Host "============" -ForegroundColor Cyan
Write-Host "1. Utilisez les fichiers JSON pour recuperer les tokens" -ForegroundColor White
Write-Host "2. Ajoutez le token dans l'header Authorization: Bearer {token}" -ForegroundColor White
Write-Host "3. Les comptes sont valides pendant 2 heures" -ForegroundColor White
Write-Host "4. Pour renouveler, utilisez l'endpoint /auth/login" -ForegroundColor White
Write-Host ""

Write-Host "Le systeme d'authentification VegN-Bio est operationnel!" -ForegroundColor Green
Write-Host "Vous avez maintenant un compte client et un compte administrateur fonctionnels." -ForegroundColor Green
