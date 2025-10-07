# Utiliser l'image officielle Flutter
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration
COPY pubspec.yaml pubspec.lock ./

# Installer les dépendances
RUN flutter pub get

# Copier le code source
COPY . .

# Construire l'application pour Android
RUN flutter build apk --release

# Image de production avec Android SDK
FROM openjdk:11-jre-slim

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Installer Android SDK
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm commandlinetools-linux-9477386_latest.zip

# Accepter les licences Android
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses

# Installer les plateformes Android nécessaires
RUN ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0"

# Copier l'APK construit
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /app/app-release.apk

# Exposer le port pour le serveur de développement
EXPOSE 8080

# Commande par défaut
CMD ["sh", "-c", "echo 'APK disponible dans /app/app-release.apk' && tail -f /dev/null"]
