package com.vegnbio.api.modules.restaurant.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Entité Restaurant représentant un restaurant VEG'N BIO
 * 
 * @author VegN-Bio Team
 */
@Entity @Table(name = "restaurants")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Restaurant {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  private String name;
  private String code;
  private String address;
  private String city;
  private String phone;
  private String email;
  
  // Nouvelles informations détaillées
  /** Indique si le Wi-Fi est disponible */
  private Boolean wifiAvailable;
  /** Nombre de salles de réunion disponibles */
  private Integer meetingRoomsCount;
  /** Capacité du restaurant en nombre de places */
  private Integer restaurantCapacity;
  /** Indique si une imprimante est disponible */
  private Boolean printerAvailable;
  /** Indique si les plateaux membres sont disponibles */
  private Boolean memberTrays;
  /** Indique si la livraison est disponible */
  private Boolean deliveryAvailable;
  /** Description des événements spéciaux */
  private String specialEvents;
  /** Horaires d'ouverture du lundi au jeudi */
  private String mondayThursdayHours;
  /** Horaires d'ouverture du vendredi */
  private String fridayHours;
  /** Horaires d'ouverture du samedi */
  private String saturdayHours;
  /** Horaires d'ouverture du dimanche */
  private String sundayHours;
}



