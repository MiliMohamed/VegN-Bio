package com.vegnbio.api.modules.menu.repo;

import com.vegnbio.api.modules.menu.entity.MenuItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {
    
    List<MenuItem> findByMenuId(Long menuId);
    
    List<MenuItem> findByNameContainingIgnoreCase(String name);
}
