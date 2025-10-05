package com.ecommerce.apigateway.controller;

import com.ecommerce.apigateway.entity.User;
import com.ecommerce.apigateway.service.AuthService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/auth")
public class AuthController {
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public Mono<ResponseEntity<String>> register(@RequestBody User user) {
        logger.info("Received register request: username={}, email={}", user.getUsername(), user.getEmail());
        return authService.register(user)
                .map(token -> {
                    logger.info("Registration successful, returning token");
                    return ResponseEntity.ok(token);
                })
                .onErrorReturn(ResponseEntity.badRequest().build());
    }

    @PostMapping("/login")
    public Mono<ResponseEntity<String>> login(@RequestBody User user) {
        logger.info("Received login request: username={}", user.getUsername());
        return authService.login(user.getUsername(), user.getPassword())
                .map(token -> {
                    logger.info("Login successful, returning token");
                    return ResponseEntity.ok(token);
                })
                .switchIfEmpty(Mono.fromSupplier(() -> {
                    logger.warn("Login failed for {}", user.getUsername());
                    return ResponseEntity.badRequest().build();
                }));
    }
}