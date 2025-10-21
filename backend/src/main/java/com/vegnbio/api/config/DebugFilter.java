package com.vegnbio.api.config;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Slf4j
@Component
@Order(1)
public class DebugFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String method = httpRequest.getMethod();
        String uri = httpRequest.getRequestURI();
        String queryString = httpRequest.getQueryString();
        String fullUrl = uri + (queryString != null ? "?" + queryString : "");
        
        // Log de la requête entrante
        log.info("🔍 Request: {} {} from IP: {}", method, fullUrl, getClientIpAddress(httpRequest));
        
        // Log des headers importants
        log.debug("Headers - Origin: {}, Referer: {}, User-Agent: {}", 
                httpRequest.getHeader("Origin"),
                httpRequest.getHeader("Referer"),
                httpRequest.getHeader("User-Agent"));
        
        // Continuer avec la chaîne de filtres
        chain.doFilter(request, response);
        
        // Log de la réponse
        log.info("✅ Response: {} {} -> Status: {}", method, fullUrl, httpResponse.getStatus());
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
}
