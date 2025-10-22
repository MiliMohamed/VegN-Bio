package com.vegnbio.api.modules.data.controller;

import com.vegnbio.api.modules.data.service.DataInitializationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/data")
@RequiredArgsConstructor
@Slf4j
public class DataInitializationController {

    private final DataInitializationService dataInitializationService;

    /**
     * Initialise toutes les données de l'application
     * Accessible uniquement aux administrateurs
     */
    @PostMapping("/initialize")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> initializeData() {
        try {
            log.info("🚀 Initialisation des données demandée par un administrateur");
            
            if (dataInitializationService.isDataInitialized()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Les données sont déjà initialisées");
                response.put("timestamp", java.time.LocalDateTime.now());
                
                return ResponseEntity.ok(response);
            }
            
            dataInitializationService.initializeAllData();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Données initialisées avec succès");
            response.put("timestamp", java.time.LocalDateTime.now());
            response.put("details", Map.of(
                "users", "Comptes utilisateurs créés",
                "restaurants", "Restaurants créés",
                "menus", "Menus créés",
                "menuItems", "Plats créés",
                "events", "Événements créés",
                "reservations", "Réservations créées",
                "allergens", "Allergènes créés"
            ));
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("❌ Erreur lors de l'initialisation des données", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Erreur lors de l'initialisation des données");
            errorResponse.put("error", e.getMessage());
            errorResponse.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }

    /**
     * Force la réinitialisation de toutes les données
     * Accessible uniquement aux administrateurs
     */
    @PostMapping("/reset")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> resetData() {
        try {
            log.info("🔄 Réinitialisation des données demandée par un administrateur");
            
            dataInitializationService.cleanAllData();
            dataInitializationService.initializeAllData();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Données réinitialisées avec succès");
            response.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("❌ Erreur lors de la réinitialisation des données", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Erreur lors de la réinitialisation des données");
            errorResponse.put("error", e.getMessage());
            errorResponse.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }

    /**
     * Nettoie toutes les données
     * Accessible uniquement aux administrateurs
     */
    @DeleteMapping("/clean")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Map<String, Object>> cleanData() {
        try {
            log.info("🧹 Nettoyage des données demandé par un administrateur");
            
            dataInitializationService.cleanAllData();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Toutes les données ont été supprimées");
            response.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("❌ Erreur lors du nettoyage des données", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Erreur lors du nettoyage des données");
            errorResponse.put("error", e.getMessage());
            errorResponse.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }

    /**
     * Vérifie le statut de l'initialisation des données
     * Accessible à tous les utilisateurs authentifiés
     */
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getDataStatus() {
        try {
            boolean isInitialized = dataInitializationService.isDataInitialized();
            
            Map<String, Object> response = new HashMap<>();
            response.put("initialized", isInitialized);
            response.put("message", isInitialized ? "Données initialisées" : "Données non initialisées");
            response.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("❌ Erreur lors de la vérification du statut", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Erreur lors de la vérification du statut");
            errorResponse.put("error", e.getMessage());
            errorResponse.put("timestamp", java.time.LocalDateTime.now());
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }

    /**
     * Endpoint de test pour vérifier que le service fonctionne
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "OK");
        response.put("service", "Data Initialization Service");
        response.put("timestamp", java.time.LocalDateTime.now());
        
        return ResponseEntity.ok(response);
    }
}
