package com.vegnbio.api.modules.restaurant.entity;

import jakarta.persistence.*;
import lombok.*;

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
}



