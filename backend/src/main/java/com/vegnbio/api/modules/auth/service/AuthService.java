package com.vegnbio.api.modules.auth.service;

import com.vegnbio.api.modules.auth.dto.AuthResponse;
import com.vegnbio.api.modules.auth.dto.LoginRequest;
import com.vegnbio.api.modules.auth.dto.RegisterRequest;
import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.auth.repo.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new RuntimeException("Email already exists");
        }
        
        User user = User.builder()
            .email(request.email())
            .passwordHash(passwordEncoder.encode(request.password()))
            .fullName(request.fullName())
            .role(request.role())
            .build();
        
        userRepository.save(user);
        
        String token = jwtService.generateToken(user);
        return new AuthResponse(
            token,
            jwtService.getExpirationTime(),
            user.getRole(),
            user.getFullName()
        );
    }
    
    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );
        
        User user = (User) authentication.getPrincipal();
        String token = jwtService.generateToken(user);
        
        return new AuthResponse(
            token,
            jwtService.getExpirationTime(),
            user.getRole(),
            user.getFullName()
        );
    }
}
