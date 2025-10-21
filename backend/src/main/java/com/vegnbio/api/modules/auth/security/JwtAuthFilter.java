package com.vegnbio.api.modules.auth.security;

import com.vegnbio.api.modules.auth.service.JwtService;
import com.vegnbio.api.modules.auth.service.UserService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {
    
    private final JwtService jwtService;
    private final UserService userService;
    
    @Override
    protected void doFilterInternal(
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws ServletException, IOException {
        
        final String requestURI = request.getRequestURI();
        final String method = request.getMethod();
        
        log.debug("🔐 JWT Filter processing: {} {}", method, requestURI);
        
        // Skip JWT validation for authentication endpoints
        if (requestURI.startsWith("/api/v1/auth/")) {
            log.debug("🔓 Skipping JWT validation for auth endpoint: {}", requestURI);
            filterChain.doFilter(request, response);
            return;
        }
        
        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final String userEmail;
        
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            log.debug("🔓 No valid Authorization header found for: {}", requestURI);
            filterChain.doFilter(request, response);
            return;
        }
        
        jwt = authHeader.substring(7);
        log.debug("🔑 JWT token found, length: {}", jwt.length());
        
        try {
            userEmail = jwtService.extractUsername(jwt);
            log.debug("👤 Extracted username: {}", userEmail);
            
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userService.loadUserByUsername(userEmail);
                
                if (jwtService.validateToken(jwt, userDetails)) {
                    log.debug("✅ JWT token is valid for user: {}", userEmail);
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities()
                    );
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    log.warn("❌ JWT token is invalid for user: {}", userEmail);
                }
            }
        } catch (Exception e) {
            log.error("💥 Error processing JWT token: {}", e.getMessage());
        }
        
        filterChain.doFilter(request, response);
    }
}
