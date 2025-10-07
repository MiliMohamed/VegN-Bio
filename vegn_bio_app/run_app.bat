@echo off
echo ========================================
echo    VegnBio App - Lancement de l'app
echo ========================================
echo.

echo Installation des dependances...
flutter pub get

echo.
echo Verification du code...
flutter analyze

echo.
echo Demarrage de l'application...
echo (Appuyez sur 'q' pour quitter)
flutter run

pause
