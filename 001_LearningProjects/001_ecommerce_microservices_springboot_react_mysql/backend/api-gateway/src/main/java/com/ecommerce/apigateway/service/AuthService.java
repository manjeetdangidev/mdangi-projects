package com.ecommerce.apigateway.service;

import com.ecommerce.apigateway.entity.User;
import com.ecommerce.apigateway.repository.UserRepository;
import com.ecommerce.apigateway.util.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JwtUtil jwtUtil;
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public Mono<String> register(User user) {
        logger.info("Registration attempt for username: {}", user.getUsername());
        
        return userRepository.findByUsername(user.getUsername())
                .hasElement()
                .flatMap(exists -> {
                    if (exists) {
                        logger.error("User already exists: {}", user.getUsername());
                        return Mono.error(new RuntimeException("User already exists"));
                    }
                    
                    String hashedPassword = encoder.encode(user.getPassword());
                    user.setPassword(hashedPassword);
                    
                    return userRepository.save(user)
                            .doOnNext(savedUser -> logger.info("User saved successfully: ID={}, Username={}", savedUser.getId(), savedUser.getUsername()))
                            .map(savedUser -> {
                                String token = jwtUtil.generateToken(user.getUsername());
                                logger.info("JWT token generated for {}", user.getUsername());
                                return token;
                            });
                })
                .onErrorMap(e -> {
                    logger.error("Error during registration for {}: {}", user.getUsername(), e.getMessage(), e);
                    return new RuntimeException("Registration failed: " + e.getMessage(), e);
                });
    }

    public Mono<String> login(String username, String password) {
        logger.info("Login attempt for username: {}", username);
        return userRepository.findByUsername(username)
                .filter(user -> encoder.matches(password, user.getPassword()))
                .map(user -> {
                    logger.info("Login successful for {}", username);
                    return jwtUtil.generateToken(username);
                })
                .switchIfEmpty(Mono.fromRunnable(() -> logger.warn("Login failed for {}", username)));
    }
}