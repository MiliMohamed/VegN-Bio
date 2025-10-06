package com.vegnbio.api.modules.restaurant;

import com.vegnbio.api.modules.restaurant.dto.RestaurantDto;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.vegnbio.api.modules.restaurant.RestaurantMapper.toDto;

@RestController
@RequestMapping("/api/v1/restaurants")
public class RestaurantController {
  private final RestaurantRepository repo;
  public RestaurantController(RestaurantRepository repo){ this.repo = repo; }

  @GetMapping
  public List<RestaurantDto> list(){
    return repo.findAll().stream().map(RestaurantMapper::toDto).toList();
  }

  @GetMapping("/{id}")
  public ResponseEntity<RestaurantDto> one(@PathVariable Long id){
    return repo.findById(id).map(r -> ResponseEntity.ok(toDto(r)))
        .orElse(ResponseEntity.notFound().build());
  }
  
  @PostMapping
  @PreAuthorize("hasRole('ADMIN')")
  public ResponseEntity<RestaurantDto> createRestaurant(@Valid @RequestBody RestaurantDto restaurantDto) {
    Restaurant restaurant = Restaurant.builder()
        .name(restaurantDto.name())
        .code(restaurantDto.code())
        .address(restaurantDto.address())
        .city(restaurantDto.city())
        .phone(restaurantDto.phone())
        .email(restaurantDto.email())
        .build();
    Restaurant savedRestaurant = repo.save(restaurant);
    return ResponseEntity.ok(toDto(savedRestaurant));
  }
  
  @PutMapping("/{id}")
  @PreAuthorize("hasRole('ADMIN')")
  public ResponseEntity<RestaurantDto> updateRestaurant(@PathVariable Long id, @Valid @RequestBody RestaurantDto restaurantDto) {
    return repo.findById(id)
        .map(restaurant -> {
          restaurant.setName(restaurantDto.name());
          restaurant.setCode(restaurantDto.code());
          restaurant.setAddress(restaurantDto.address());
          restaurant.setCity(restaurantDto.city());
          restaurant.setPhone(restaurantDto.phone());
          restaurant.setEmail(restaurantDto.email());
          Restaurant updatedRestaurant = repo.save(restaurant);
          return ResponseEntity.ok(toDto(updatedRestaurant));
        })
        .orElse(ResponseEntity.notFound().build());
  }
  
  @DeleteMapping("/{id}")
  @PreAuthorize("hasRole('ADMIN')")
  public ResponseEntity<Void> deleteRestaurant(@PathVariable Long id) {
    if (repo.existsById(id)) {
      repo.deleteById(id);
      return ResponseEntity.noContent().build();
    }
    return ResponseEntity.notFound().build();
  }
}



