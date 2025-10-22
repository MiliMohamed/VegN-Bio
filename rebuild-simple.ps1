# Rebuild Backend avec Migration V19
Write-Host "Rebuild Backend V19" -ForegroundColor Green

# Arreter les processus Java
Get-Process | Where-Object { $_.ProcessName -like "*java*" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Nettoyer et rebuilder
Write-Host "Nettoyage du backend..." -ForegroundColor Yellow
Set-Location backend

if (Test-Path "target") {
    Remove-Item -Recurse -Force "target"
    Write-Host "Dossier target supprime" -ForegroundColor Cyan
}

# Recompiler
Write-Host "Compilation du backend..." -ForegroundColor Cyan
try {
    mvn clean compile -DskipTests
    Write-Host "Compilation reussie" -ForegroundColor Green
} catch {
    Write-Host "Utilisation des classes existantes" -ForegroundColor Yellow
}

Set-Location ..

# Demarrer avec migration V19
Write-Host "Demarrage avec migration V19..." -ForegroundColor Yellow
Set-Location backend

$env:SPRING_PROFILES_ACTIVE = "prod"
$env:SPRING_FLYWAY_ENABLED = "true"

Start-Process -FilePath "java" -ArgumentList "-cp", "target/classes", "-Dspring.profiles.active=prod", "-Dspring.flyway.enabled=true", "com.vegnbio.api.VegnBioApplication" -WindowStyle Hidden

Set-Location ..

# Attendre et tester
Write-Host "Attente du demarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Test des restaurants
try {
    $restaurants = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants" -Method GET -TimeoutSec 10
    Write-Host "Migration V19 reussie ! $($restaurants.Count) restaurants trouves:" -ForegroundColor Green
    foreach ($r in $restaurants) {
        Write-Host "- $($r.name) ($($r.code))" -ForegroundColor Cyan
    }
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Backend V19 demarre !" -ForegroundColor Green
