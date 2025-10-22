# Script de demarrage simple VEG'N BIO
Write-Host "Demarrage Application VEG'N BIO" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Arreter tous les processus Java existants
Write-Host "Arret des processus existants..." -ForegroundColor Yellow
Stop-Process -Name "java" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "node" -Force -ErrorAction SilentlyContinue

# Attendre
Start-Sleep -Seconds 3

# Demarrer le backend avec les classes existantes
Write-Host "Demarrage du backend..." -ForegroundColor Yellow
Set-Location backend

# Utiliser les classes compilees existantes
$classpath = "target/classes"
$mainClass = "com.vegnbio.api.VegnBioApplication"

# Demarrer en arriere-plan
Start-Process -FilePath "java" -ArgumentList "-cp", $classpath, "-Dspring.profiles.active=prod", $mainClass -WindowStyle Hidden

Set-Location ..

# Attendre le demarrage du backend
Write-Host "Attente du demarrage du backend..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Tester la connectivite
Write-Host "Test de connectivite..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants" -Method GET -TimeoutSec 10
    Write-Host "Backend accessible - $($response.Count) restaurants trouves" -ForegroundColor Green
} catch {
    Write-Host "Backend non accessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Demarrer le frontend
Write-Host "Demarrage du frontend..." -ForegroundColor Yellow
Set-Location web

# Installer les dependances si necessaire
if (-not (Test-Path "node_modules")) {
    Write-Host "Installation des dependances..." -ForegroundColor Cyan
    npm install --silent
}

# Demarrer le frontend
Start-Process -FilePath "npm" -ArgumentList "run", "start" -WindowStyle Hidden

Set-Location ..

# Attendre le demarrage du frontend
Write-Host "Attente du demarrage du frontend..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Tester le frontend
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 10
    Write-Host "Frontend accessible" -ForegroundColor Green
} catch {
    Write-Host "Frontend en cours de demarrage..." -ForegroundColor Yellow
}

# Affichage des informations
Write-Host "`nApplication VEG'N BIO demarree !" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green

Write-Host "`nAcces aux applications :" -ForegroundColor Cyan
Write-Host "• Frontend Web : http://localhost:3000" -ForegroundColor White
Write-Host "• Backend API : http://localhost:8080/api" -ForegroundColor White
Write-Host "• Documentation : http://localhost:8080/swagger-ui.html" -ForegroundColor White

Write-Host "`nComptes de test :" -ForegroundColor Cyan
Write-Host "• Admin : admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Restaurateur : restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Client : client@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`nRestaurants configures :" -ForegroundColor Cyan
Write-Host "• VEG'N BIO BASTILLE" -ForegroundColor White
Write-Host "• VEG'N BIO REPUBLIQUE" -ForegroundColor White
Write-Host "• VEG'N BIO NATION" -ForegroundColor White
Write-Host "• VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY" -ForegroundColor White
Write-Host "• VEG'N BIO BEAUBOURG" -ForegroundColor White

Write-Host "`nVOSTRE APPLICATION VEG'N BIO EST PRETE !" -ForegroundColor Green
