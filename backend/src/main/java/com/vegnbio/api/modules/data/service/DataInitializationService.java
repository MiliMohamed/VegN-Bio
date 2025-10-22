package com.vegnbio.api.modules.data.service;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.auth.repo.UserRepository;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import com.vegnbio.api.modules.menu.entity.Menu;
import com.vegnbio.api.modules.menu.repo.MenuRepository;
import com.vegnbio.api.modules.menu.entity.MenuItem;
import com.vegnbio.api.modules.menu.repo.MenuItemRepository;
import com.vegnbio.api.modules.events.entity.Event;
import com.vegnbio.api.modules.events.repo.EventRepository;
import com.vegnbio.api.modules.reservation.entity.Reservation;
import com.vegnbio.api.modules.reservation.repo.ReservationRepository;
import com.vegnbio.api.modules.allergen.entity.Allergen;
import com.vegnbio.api.modules.allergen.repo.AllergenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class DataInitializationService {

    private final UserRepository userRepository;
    private final RestaurantRepository restaurantRepository;
    private final MenuRepository menuRepository;
    private final MenuItemRepository menuItemRepository;
    private final EventRepository eventRepository;
    private final ReservationRepository reservationRepository;
    private final AllergenRepository allergenRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * Initialise toutes les données de base pour l'application
     */
    public void initializeAllData() {
        log.info("🚀 Début de l'initialisation des données...");
        
        try {
            // 1. Créer les allergènes
            createAllergens();
            
            // 2. Créer les utilisateurs
            createUsers();
            
            // 3. Créer les restaurants
            createRestaurants();
            
            // 4. Créer les menus
            createMenus();
            
            // 5. Créer les plats
            createMenuItems();
            
            // 6. Créer les événements
            createEvents();
            
            // 7. Créer les réservations
            createReservations();
            
            log.info("✅ Initialisation des données terminée avec succès !");
            
        } catch (Exception e) {
            log.error("❌ Erreur lors de l'initialisation des données", e);
            throw new RuntimeException("Erreur lors de l'initialisation des données", e);
        }
    }

    /**
     * Crée les allergènes de base
     */
    private void createAllergens() {
        log.info("📋 Création des allergènes...");
        
        List<Allergen> allergens = Arrays.asList(
            Allergen.builder().code("GLUTEN").label("Gluten").build(),
            Allergen.builder().code("LACTOSE").label("Lactose").build(),
            Allergen.builder().code("NUTS").label("Fruits à coque").build(),
            Allergen.builder().code("SOY").label("Soja").build(),
            Allergen.builder().code("SESAME").label("Sésame").build(),
            Allergen.builder().code("EGGS").label("Œufs").build(),
            Allergen.builder().code("FISH").label("Poisson").build(),
            Allergen.builder().code("SHELLFISH").label("Crustacés").build()
        );
        
        allergenRepository.saveAll(allergens);
        log.info("✅ {} allergènes créés", allergens.size());
    }

    /**
     * Crée les utilisateurs de différents rôles
     */
    private void createUsers() {
        log.info("👥 Création des utilisateurs...");
        
        List<User> users = Arrays.asList(
            // Administrateurs
            User.builder()
                .email("admin@vegnbio.fr")
                .passwordHash(passwordEncoder.encode("admin123"))
                .fullName("Administrateur Principal")
                .role(User.Role.ADMIN)
                .build(),
            
            User.builder()
                .email("admin2@vegnbio.fr")
                .passwordHash(passwordEncoder.encode("admin123"))
                .fullName("Marie Dubois")
                .role(User.Role.ADMIN)
                .build(),
            
            // Restaurateurs
            User.builder()
                .email("chef@bastille.vegnbio.fr")
                .passwordHash(passwordEncoder.encode("chef123"))
                .fullName("Jean-Pierre Martin")
                .role(User.Role.RESTAURATEUR)
                .build(),
            
            User.builder()
                .email("chef@republique.vegnbio.fr")
                .passwordHash(passwordEncoder.encode("chef123"))
                .fullName("Sophie Laurent")
                .role(User.Role.RESTAURATEUR)
                .build(),
            
            User.builder()
                .email("chef@nation.vegnbio.fr")
                .passwordHash(passwordEncoder.encode("chef123"))
                .fullName("Pierre Moreau")
                .role(User.Role.RESTAURATEUR)
                .build(),
            
            // Clients
            User.builder()
                .email("marie.dubois@email.com")
                .passwordHash(passwordEncoder.encode("client123"))
                .fullName("Marie Dubois")
                .role(User.Role.CLIENT)
                .build(),
            
            User.builder()
                .email("jean.martin@email.com")
                .passwordHash(passwordEncoder.encode("client123"))
                .fullName("Jean Martin")
                .role(User.Role.CLIENT)
                .build(),
            
            User.builder()
                .email("sophie.laurent@email.com")
                .passwordHash(passwordEncoder.encode("client123"))
                .fullName("Sophie Laurent")
                .role(User.Role.CLIENT)
                .build(),
            
            // Fournisseurs
            User.builder()
                .email("contact@biofrance.fr")
                .passwordHash(passwordEncoder.encode("fournisseur123"))
                .fullName("Bio France")
                .role(User.Role.FOURNISSEUR)
                .build(),
            
            User.builder()
                .email("contact@legumesbio.fr")
                .passwordHash(passwordEncoder.encode("fournisseur123"))
                .fullName("Légumes Bio Paris")
                .role(User.Role.FOURNISSEUR)
                .build()
        );
        
        userRepository.saveAll(users);
        log.info("✅ {} utilisateurs créés", users.size());
    }

    /**
     * Crée les restaurants
     */
    private void createRestaurants() {
        log.info("🏪 Création des restaurants...");
        
        List<Restaurant> restaurants = Arrays.asList(
            Restaurant.builder()
                .name("VEG'N BIO BASTILLE")
                .code("BAS")
                .address("Place de la Bastille")
                .city("Paris")
                .phone("01 43 25 67 89")
                .email("bastille@vegnbio.fr")
                .restaurantCapacity(80)
                .specialEvents("Notre restaurant phare situé sur la célèbre Place de la Bastille")
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO RÉPUBLIQUE")
                .code("REP")
                .address("Place de la République")
                .city("Paris")
                .phone("01 43 25 67 90")
                .email("republique@vegnbio.fr")
                .restaurantCapacity(60)
                .specialEvents("Restaurant moderne au cœur de la Place de la République")
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO NATION")
                .code("NAT")
                .address("Place de la Nation")
                .city("Paris")
                .phone("01 43 25 67 91")
                .email("nation@vegnbio.fr")
                .restaurantCapacity(70)
                .specialEvents("Espace convivial sur la Place de la Nation")
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO ITALIE")
                .code("ITA")
                .address("Place d'Italie")
                .city("Paris")
                .phone("01 43 25 67 92")
                .email("italie@vegnbio.fr")
                .restaurantCapacity(65)
                .specialEvents("Restaurant italien végétarien sur la Place d'Italie")
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO BOURSE")
                .code("BOU")
                .address("Place de la Bourse")
                .city("Paris")
                .phone("01 43 25 67 93")
                .email("bourse@vegnbio.fr")
                .restaurantCapacity(55)
                .specialEvents("Restaurant d'affaires près de la Place de la Bourse")
                .build()
        );
        
        restaurantRepository.saveAll(restaurants);
        log.info("✅ {} restaurants créés", restaurants.size());
    }

    /**
     * Crée les menus pour chaque restaurant
     */
    private void createMenus() {
        log.info("🍽️ Création des menus...");
        
        List<Restaurant> restaurants = restaurantRepository.findAll();
        List<Menu> menus = new ArrayList<>();
        
        for (Restaurant restaurant : restaurants) {
            // Menu principal
            Menu menuPrincipal = Menu.builder()
                .restaurant(restaurant)
                .title("Menu Principal")
                .activeFrom(LocalDate.now())
                .activeTo(LocalDate.now().plusMonths(3))
                .build();
            
            // Menu du jour
            Menu menuDuJour = Menu.builder()
                .restaurant(restaurant)
                .title("Menu du Jour")
                .activeFrom(LocalDate.now())
                .activeTo(LocalDate.now().plusDays(7))
                .build();
            
            // Menu événementiel
            Menu menuEvenementiel = Menu.builder()
                .restaurant(restaurant)
                .title("Menu Événementiel")
                .activeFrom(LocalDate.now())
                .activeTo(LocalDate.now().plusMonths(6))
                .build();
            
            menus.addAll(Arrays.asList(menuPrincipal, menuDuJour, menuEvenementiel));
        }
        
        menuRepository.saveAll(menus);
        log.info("✅ {} menus créés", menus.size());
    }

    /**
     * Crée les plats pour chaque menu
     */
    private void createMenuItems() {
        log.info("🥗 Création des plats...");
        
        List<Menu> menus = menuRepository.findAll();
        List<Allergen> allergens = allergenRepository.findAll();
        
        // Plats végétariens variés
        String[][] platsData = {
            {"Burger Végétarien", "Burger aux légumes grillés avec pain bio", "1290", "true"},
            {"Salade César Végétarienne", "Salade avec fromage végétal et croûtons", "890", "true"},
            {"Pizza Margherita", "Pizza tomate, mozzarella végétale et basilic", "1190", "true"},
            {"Risotto aux Champignons", "Risotto crémeux aux champignons de Paris", "1390", "true"},
            {"Wrap Avocat", "Wrap aux légumes frais et avocat", "990", "true"},
            {"Pasta Carbonara Végétarienne", "Pâtes à la crème végétale et champignons", "1290", "true"},
            {"Bowl Buddha", "Bowl de légumes, quinoa et sauce tahini", "1190", "true"},
            {"Tartine Avocat", "Pain complet, avocat, tomates et graines", "790", "true"},
            {"Curry de Légumes", "Curry de légumes avec riz basmati", "1390", "true"},
            {"Quiche Lorraine Végétarienne", "Quiche aux légumes et fromage végétal", "1090", "true"}
        };
        
        List<MenuItem> menuItems = new ArrayList<>();
        
        for (Menu menu : menus) {
            for (String[] plat : platsData) {
                MenuItem menuItem = MenuItem.builder()
                    .menu(menu)
                    .name(plat[0])
                    .description(plat[1])
                    .priceCents(Integer.parseInt(plat[2]))
                    .isVegan(Boolean.parseBoolean(plat[3]))
                    .allergens(Arrays.asList()) // Pas d'allergènes par défaut
                    .build();
                
                menuItems.add(menuItem);
            }
        }
        
        menuItemRepository.saveAll(menuItems);
        log.info("✅ {} plats créés", menuItems.size());
    }

    /**
     * Crée les événements
     */
    private void createEvents() {
        log.info("📅 Création des événements...");
        
        List<Restaurant> restaurants = restaurantRepository.findAll();
        List<Event> events = new ArrayList<>();
        
        String[][] eventsData = {
            {"Atelier Cuisine Végétarienne", "Apprenez à cuisiner des plats végétariens délicieux", "2024-02-15T14:00", "2024-02-15T16:00", "25"},
            {"Conférence Nutrition", "Les bienfaits de l'alimentation végétarienne", "2024-02-20T18:00", "2024-02-20T20:00", "50"},
            {"Dégustation Produits Bio", "Découvrez nos nouveaux produits biologiques", "2024-02-25T15:00", "2024-02-25T17:00", "30"},
            {"Soirée Producteurs", "Rencontrez nos producteurs locaux", "2024-03-01T19:00", "2024-03-01T21:00", "40"},
            {"Atelier Pâtisserie Végétale", "Apprenez à faire des desserts sans œufs", "2024-03-05T10:00", "2024-03-05T12:00", "20"}
        };
        
        for (Restaurant restaurant : restaurants) {
            for (String[] eventData : eventsData) {
                Event event = Event.builder()
                    .restaurant(restaurant)
                    .title(eventData[0])
                    .description(eventData[1])
                    .dateStart(LocalDateTime.parse(eventData[2]))
                    .dateEnd(LocalDateTime.parse(eventData[3]))
                    .capacity(Integer.parseInt(eventData[4]))
                    .build();
                
                events.add(event);
            }
        }
        
        eventRepository.saveAll(events);
        log.info("✅ {} événements créés", events.size());
    }

    /**
     * Crée les réservations
     */
    private void createReservations() {
        log.info("📋 Création des réservations...");
        
        List<User> clients = userRepository.findByRole(User.Role.CLIENT);
        List<Restaurant> restaurants = restaurantRepository.findAll();
        List<Event> events = eventRepository.findAll();
        
        List<Reservation> reservations = new ArrayList<>();
        
        // Réservations de tables
        for (int i = 0; i < 10; i++) {
            User client = clients.get(i % clients.size());
            Restaurant restaurant = restaurants.get(i % restaurants.size());
            
            Reservation reservation = Reservation.builder()
                .user(client)
                .restaurant(restaurant)
                .reservationDate(LocalDate.now().plusDays(i + 1))
                .reservationTime(LocalTime.of(12 + (i % 6), 0))
                .numberOfPeople(2 + (i % 4))
                .status(Reservation.ReservationStatus.CONFIRMED)
                .notes("Réservation automatique")
                .build();
            
            reservations.add(reservation);
        }
        
        // Réservations d'événements
        for (int i = 0; i < 15; i++) {
            User client = clients.get(i % clients.size());
            Event event = events.get(i % events.size());
            
            Reservation reservation = Reservation.builder()
                .user(client)
                .restaurant(event.getRestaurant())
                .event(event)
                .reservationDate(event.getDateStart().toLocalDate())
                .reservationTime(event.getDateStart().toLocalTime())
                .numberOfPeople(1 + (i % 3))
                .status(Reservation.ReservationStatus.CONFIRMED)
                .notes("Réservation événement")
                .build();
            
            reservations.add(reservation);
        }
        
        reservationRepository.saveAll(reservations);
        log.info("✅ {} réservations créées", reservations.size());
    }

    /**
     * Nettoie toutes les données (pour les tests)
     */
    public void cleanAllData() {
        log.info("🧹 Nettoyage de toutes les données...");
        
        reservationRepository.deleteAll();
        eventRepository.deleteAll();
        menuItemRepository.deleteAll();
        menuRepository.deleteAll();
        restaurantRepository.deleteAll();
        userRepository.deleteAll();
        allergenRepository.deleteAll();
        
        log.info("✅ Toutes les données ont été supprimées");
    }

    /**
     * Vérifie si les données sont déjà initialisées
     */
    public boolean isDataInitialized() {
        return userRepository.count() > 0 && restaurantRepository.count() > 0;
    }
}
