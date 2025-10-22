package com.vegnbio.api.modules.data.service;

import com.vegnbio.api.modules.user.entity.User;
import com.vegnbio.api.modules.user.repo.UserRepository;
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
                .username("admin")
                .email("admin@vegnbio.fr")
                .password(passwordEncoder.encode("admin123"))
                .fullName("Administrateur Principal")
                .role("ADMIN")
                .phone("01 23 45 67 89")
                .address("123 Rue de la Paix, 75001 Paris")
                .city("Paris")
                .postalCode("75001")
                .isActive(true)
                .build(),
            
            User.builder()
                .username("admin2")
                .email("admin2@vegnbio.fr")
                .password(passwordEncoder.encode("admin123"))
                .fullName("Marie Dubois")
                .role("ADMIN")
                .phone("01 23 45 67 90")
                .address("456 Avenue des Champs, 75008 Paris")
                .city("Paris")
                .postalCode("75008")
                .isActive(true)
                .build(),
            
            // Restaurateurs
            User.builder()
                .username("chef_bastille")
                .email("chef@bastille.vegnbio.fr")
                .password(passwordEncoder.encode("chef123"))
                .fullName("Jean-Pierre Martin")
                .role("RESTAURATEUR")
                .phone("01 23 45 67 91")
                .address("789 Place de la Bastille, 75011 Paris")
                .city("Paris")
                .postalCode("75011")
                .isActive(true)
                .build(),
            
            User.builder()
                .username("chef_republique")
                .email("chef@republique.vegnbio.fr")
                .password(passwordEncoder.encode("chef123"))
                .fullName("Sophie Laurent")
                .role("RESTAURATEUR")
                .phone("01 23 45 67 92")
                .address("321 Place de la République, 75003 Paris")
                .city("Paris")
                .postalCode("75003")
                .isActive(true)
                .build(),
            
            User.builder()
                .username("chef_nation")
                .email("chef@nation.vegnbio.fr")
                .password(passwordEncoder.encode("chef123"))
                .fullName("Pierre Moreau")
                .role("RESTAURATEUR")
                .phone("01 23 45 67 93")
                .address("654 Place de la Nation, 75012 Paris")
                .city("Paris")
                .postalCode("75012")
                .isActive(true)
                .build(),
            
            // Clients
            User.builder()
                .username("client1")
                .email("marie.dubois@email.com")
                .password(passwordEncoder.encode("client123"))
                .fullName("Marie Dubois")
                .role("CLIENT")
                .phone("01 23 45 67 94")
                .address("987 Rue de Rivoli, 75001 Paris")
                .city("Paris")
                .postalCode("75001")
                .isActive(true)
                .build(),
            
            User.builder()
                .username("client2")
                .email("jean.martin@email.com")
                .password(passwordEncoder.encode("client123"))
                .fullName("Jean Martin")
                .role("CLIENT")
                .phone("01 23 45 67 95")
                .address("147 Rue de la Paix, 75002 Paris")
                .city("Paris")
                .postalCode("75002")
                .isActive(true)
                .build(),
            
            User.builder()
                .username("client3")
                .email("sophie.laurent@email.com")
                .password(passwordEncoder.encode("client123"))
                .fullName("Sophie Laurent")
                .role("CLIENT")
                .phone("01 23 45 67 96")
                .address("258 Avenue des Champs, 75008 Paris")
                .city("Paris")
                .postalCode("75008")
                .isActive(true)
                .build(),
            
            // Fournisseurs
            User.builder()
                .username("fournisseur1")
                .email("contact@biofrance.fr")
                .password(passwordEncoder.encode("fournisseur123"))
                .fullName("Bio France")
                .role("FOURNISSEUR")
                .phone("01 23 45 67 97")
                .address("369 Rue de la Ferme, 75015 Paris")
                .city("Paris")
                .postalCode("75015")
                .isActive(true)
                .build(),
            
            User.builder()
                .username("fournisseur2")
                .email("contact@legumesbio.fr")
                .password(passwordEncoder.encode("fournisseur123"))
                .fullName("Légumes Bio Paris")
                .role("FOURNISSEUR")
                .phone("01 23 45 67 98")
                .address("741 Avenue des Producteurs, 75016 Paris")
                .city("Paris")
                .postalCode("75016")
                .isActive(true)
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
                .postalCode("75011")
                .phone("01 43 25 67 89")
                .email("bastille@vegnbio.fr")
                .capacity(80)
                .description("Notre restaurant phare situé sur la célèbre Place de la Bastille")
                .isActive(true)
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO RÉPUBLIQUE")
                .code("REP")
                .address("Place de la République")
                .city("Paris")
                .postalCode("75003")
                .phone("01 43 25 67 90")
                .email("republique@vegnbio.fr")
                .capacity(60)
                .description("Restaurant moderne au cœur de la Place de la République")
                .isActive(true)
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO NATION")
                .code("NAT")
                .address("Place de la Nation")
                .city("Paris")
                .postalCode("75012")
                .phone("01 43 25 67 91")
                .email("nation@vegnbio.fr")
                .capacity(70)
                .description("Espace convivial sur la Place de la Nation")
                .isActive(true)
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO ITALIE")
                .code("ITA")
                .address("Place d'Italie")
                .city("Paris")
                .postalCode("75013")
                .phone("01 43 25 67 92")
                .email("italie@vegnbio.fr")
                .capacity(65)
                .description("Restaurant italien végétarien sur la Place d'Italie")
                .isActive(true)
                .build(),
            
            Restaurant.builder()
                .name("VEG'N BIO BOURSE")
                .code("BOU")
                .address("Place de la Bourse")
                .city("Paris")
                .postalCode("75002")
                .phone("01 43 25 67 93")
                .email("bourse@vegnbio.fr")
                .capacity(55)
                .description("Restaurant d'affaires près de la Place de la Bourse")
                .isActive(true)
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
        List<Menu> menus = Arrays.asList();
        
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
        
        List<MenuItem> menuItems = Arrays.asList();
        
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
        List<Event> events = Arrays.asList();
        
        String[][] eventsData = {
            {"Atelier Cuisine Végétarienne", "Apprenez à cuisiner des plats végétariens délicieux", "2024-02-15", "14:00", "16:00", "25"},
            {"Conférence Nutrition", "Les bienfaits de l'alimentation végétarienne", "2024-02-20", "18:00", "20:00", "50"},
            {"Dégustation Produits Bio", "Découvrez nos nouveaux produits biologiques", "2024-02-25", "15:00", "17:00", "30"},
            {"Soirée Producteurs", "Rencontrez nos producteurs locaux", "2024-03-01", "19:00", "21:00", "40"},
            {"Atelier Pâtisserie Végétale", "Apprenez à faire des desserts sans œufs", "2024-03-05", "10:00", "12:00", "20"}
        };
        
        for (Restaurant restaurant : restaurants) {
            for (String[] eventData : eventsData) {
                Event event = Event.builder()
                    .restaurant(restaurant)
                    .title(eventData[0])
                    .description(eventData[1])
                    .eventDate(LocalDate.parse(eventData[2]))
                    .startTime(LocalTime.parse(eventData[3]))
                    .endTime(LocalTime.parse(eventData[4]))
                    .maxParticipants(Integer.parseInt(eventData[5]))
                    .isActive(true)
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
        
        List<User> clients = userRepository.findByRole("CLIENT");
        List<Restaurant> restaurants = restaurantRepository.findAll();
        List<Event> events = eventRepository.findAll();
        
        List<Reservation> reservations = Arrays.asList();
        
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
                .status("CONFIRMED")
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
                .reservationDate(event.getEventDate())
                .reservationTime(event.getStartTime())
                .numberOfPeople(1 + (i % 3))
                .status("CONFIRMED")
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
