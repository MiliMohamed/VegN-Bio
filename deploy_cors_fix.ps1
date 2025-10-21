# Script pour deployer les corrections CORS et tester
Write-Host "DEPLOYMENT DES CORRECTIONS CORS" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

Write-Host "ETAPE 1: COMPILATION DU BACKEND" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow

try {
    Set-Location "backend"
    Write-Host "Compilation en cours..." -ForegroundColor Yellow
    $compileResult = mvn clean compile -q
    if ($LASTEXITCODE -eq 0) {
        Write-Host "SUCCESS: Compilation reussie" -ForegroundColor Green
    } else {
        Write-Host "FAILED: Erreur de compilation" -ForegroundColor Red
        Write-Host $compileResult -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "FAILED: Erreur lors de la compilation" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
} finally {
    Set-Location ".."
}

Write-Host "`nETAPE 2: CREATION DU JAR" -ForegroundColor Yellow
Write-Host "========================" -ForegroundColor Yellow

try {
    Set-Location "backend"
    Write-Host "Creation du JAR en cours..." -ForegroundColor Yellow
    $jarResult = mvn package -DskipTests -q
    if ($LASTEXITCODE -eq 0) {
        Write-Host "SUCCESS: JAR cree avec succes" -ForegroundColor Green
    } else {
        Write-Host "FAILED: Erreur lors de la creation du JAR" -ForegroundColor Red
        Write-Host $jarResult -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "FAILED: Erreur lors de la creation du JAR" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
} finally {
    Set-Location ".."
}

Write-Host "`nETAPE 3: DEPLOYMENT VERS RENDER" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow

Write-Host "IMPORTANT: Vous devez maintenant deployer manuellement vers Render" -ForegroundColor White
Write-Host "1. Allez sur https://dashboard.render.com" -ForegroundColor Gray
Write-Host "2. Trouvez votre service 'vegn-bio-backend'" -ForegroundColor Gray
Write-Host "3. Cliquez sur 'Manual Deploy' ou 'Deploy Latest Commit'" -ForegroundColor Gray
Write-Host "4. Attendez que le deployment soit termine" -ForegroundColor Gray
Write-Host ""

Write-Host "ETAPE 4: TEST APRES DEPLOYMENT" -ForegroundColor Yellow
Write-Host "==============================" -ForegroundColor Yellow

Write-Host "Une fois le deployment termine, executez le script de test:" -ForegroundColor White
Write-Host "powershell -ExecutionPolicy Bypass -File test_cors_fix.ps1" -ForegroundColor Gray
Write-Host ""

Write-Host "CORRECTIONS APPORTEES:" -ForegroundColor Magenta
Write-Host "=====================" -ForegroundColor Magenta
Write-Host "1. Suppression de la configuration CORS dupliquee dans SecurityConfig" -ForegroundColor White
Write-Host "2. Amelioration de la configuration CORS dans CorsConfig" -ForegroundColor White
Write-Host "3. Ajout des headers exposes pour l'authentification" -ForegroundColor White
Write-Host "4. Configuration du cache preflight pour ameliorer les performances" -ForegroundColor White
Write-Host ""
Write-Host "Ces corrections devraient resoudre le probleme 403 du frontend." -ForegroundColor Green
