# ========================================
#   Démarrage PostgreSQL en local (Docker)
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Démarrage PostgreSQL en local (Docker)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier si Docker est installé
try {
    $dockerVersion = docker --version
    Write-Host "Vérification de Docker... OK" -ForegroundColor Green
    Write-Host "Version: $dockerVersion" -ForegroundColor Gray
} catch {
    Write-Host "ERREUR: Docker n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    Write-Host "Veuillez installer Docker Desktop depuis: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour continuer"
    exit 1
}

Write-Host ""

# Aller dans le dossier devops
$devopsPath = Join-Path $PSScriptRoot "devops"
Set-Location $devopsPath

Write-Host "Démarrage de PostgreSQL avec Docker..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "- Base de données: vegnbiodb" -ForegroundColor White
Write-Host "- Utilisateur: postgres" -ForegroundColor White
Write-Host "- Mot de passe: postgres" -ForegroundColor White
Write-Host "- Port: 5432" -ForegroundColor White
Write-Host ""

# Démarrer seulement PostgreSQL
try {
    docker-compose up -d db
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ PostgreSQL démarré avec succès!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Informations de connexion:" -ForegroundColor Cyan
        Write-Host "   Host: localhost" -ForegroundColor White
        Write-Host "   Port: 5432" -ForegroundColor White
        Write-Host "   Database: vegnbiodb" -ForegroundColor White
        Write-Host "   Username: postgres" -ForegroundColor White
        Write-Host "   Password: postgres" -ForegroundColor White
        Write-Host ""
        Write-Host "🔗 URL de connexion JDBC:" -ForegroundColor Cyan
        Write-Host "   jdbc:postgresql://localhost:5432/vegnbiodb" -ForegroundColor White
        Write-Host ""
        Write-Host "Commandes utiles:" -ForegroundColor Cyan
        Write-Host "- Arrêter PostgreSQL: docker-compose down" -ForegroundColor White
        Write-Host "- Voir les logs: docker-compose logs db" -ForegroundColor White
        Write-Host "- Entrer dans le conteneur: docker exec -it vegn_db psql -U postgres -d vegnbiodb" -ForegroundColor White
    } else {
        Write-Host "❌ Erreur lors du démarrage de PostgreSQL" -ForegroundColor Red
        Write-Host "Vérifiez que Docker est en cours d'exécution" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Erreur lors de l'exécution de Docker Compose" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host "Appuyez sur Entrée pour continuer"
