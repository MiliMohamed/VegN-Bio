package com.vegnbio.api.modules.restaurant;

import com.vegnbio.api.modules.restaurant.dto.RestaurantDto;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import org.springframework.http.ResponseEntity;
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
}



