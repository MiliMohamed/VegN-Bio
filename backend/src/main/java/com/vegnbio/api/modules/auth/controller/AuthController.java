package com.vegnbio.api.modules.auth.controller;

import com.vegnbio.api.modules.auth.dto.AuthResponse;
import com.vegnbio.api.modules.auth.dto.LoginRequest;
import com.vegnbio.api.modules.auth.dto.RegisterRequest;
import com.vegnbio.api.modules.auth.dto.UserDto;
import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.auth.service.AuthService;
import com.vegnbio.api.modules.auth.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;
    private final UserService userService;
    
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/me")
    public ResponseEntity<UserDto> getCurrentUser(Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        UserDto userDto = new UserDto(
            user.getId(),
            user.getEmail(),
            user.getFullName(),
            user.getRole(),
            user.getCreatedAt().toString()
        );
        return ResponseEntity.ok(userDto);
    }
}
