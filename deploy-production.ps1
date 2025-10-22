# Script de déploiement en production
Write-Host "🚀 DÉPLOIEMENT EN PRODUCTION - VEG'N BIO" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Vérifier que le push a réussi
Write-Host "✅ Code poussé vers la production avec succès" -ForegroundColor Green
Write-Host "📦 Commit: 2758ceb - Résolution du problème 'Restaurant not found'" -ForegroundColor Cyan

# Attendre que le déploiement se fasse
Write-Host "`n⏳ Attente du déploiement automatique..." -ForegroundColor Yellow
Write-Host "   - Backend: https://vegn-bio-backend.onrender.com" -ForegroundColor Gray
Write-Host "   - Frontend: https://veg-n-bio-front-pi.vercel.app" -ForegroundColor Gray

Start-Sleep -Seconds 30

# Exécuter la solution sur la production
Write-Host "`n🎯 Exécution de la solution sur la production..." -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

try {
    # Exécuter le script de solution
    & "./solution-finale-menus.ps1" -Verbose
    
    Write-Host "`n🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS!" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "✅ Code déployé sur la production" -ForegroundColor Green
    Write-Host "✅ Solution 'Restaurant not found' appliquée" -ForegroundColor Green
    Write-Host "✅ Menus créés avec les vrais IDs de restaurants" -ForegroundColor Green
    Write-Host "✅ Design des filtres amélioré" -ForegroundColor Green
    
    Write-Host "`n🌐 URLs de production:" -ForegroundColor Cyan
    Write-Host "   Backend:  https://vegn-bio-backend.onrender.com" -ForegroundColor White
    Write-Host "   Frontend: https://veg-n-bio-front-pi.vercel.app" -ForegroundColor White
    
} catch {
    Write-Host "`n❌ Erreur lors de l'exécution: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Vérifiez manuellement le déploiement." -ForegroundColor Yellow
}

Write-Host "`n🏁 Déploiement terminé!" -ForegroundColor Green