Write-Host "========================================" -ForegroundColor Green
Write-Host "    VegnBio App - Lancement de l'app" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Installation des dependances..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "Verification du code..." -ForegroundColor Yellow
flutter analyze

Write-Host ""
Write-Host "Demarrage de l'application..." -ForegroundColor Yellow
Write-Host "(Appuyez sur 'q' pour quitter)" -ForegroundColor Cyan
flutter run -d windows

Read-Host "Appuyez sur Entree pour fermer"
