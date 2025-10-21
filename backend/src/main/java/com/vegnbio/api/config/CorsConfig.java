package com.vegnbio.api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.List;

@Configuration
public class CorsConfig {
  @Bean
  public CorsFilter corsFilter() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowCredentials(true);
    config.setAllowedOriginPatterns(List.of(
        "http://localhost:*", 
        "http://127.0.0.1:*", 
        "http://web:*",
        "https://*.vercel.app",
        "https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app",
        "https://veg-n-bio-front-pi.vercel.app",
        "https://*.netlify.app",
        "https://*.railway.app",
        "https://*.onrender.com",
        "https://vegn-bio-backend.onrender.com",
        "https://vegn-bio-frontend.onrender.com"
    ));
    config.setAllowedMethods(List.of("GET","POST","PUT","PATCH","DELETE","OPTIONS","HEAD"));
    config.setAllowedHeaders(List.of("*"));
    config.setExposedHeaders(List.of("Authorization", "Content-Type", "X-Requested-With", "Accept", "Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"));
    config.setMaxAge(3600L); // Cache preflight response for 1 hour
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", config);
    return new CorsFilter(source);
  }
}



