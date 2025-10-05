package com.ecommerce.cartservice.controller;

import com.ecommerce.cartservice.entity.CartItem;
import com.ecommerce.cartservice.repository.CartItemRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cart")
public class CartController {
    private static final Logger logger = LoggerFactory.getLogger(CartController.class);

    @Autowired
    private CartItemRepository cartItemRepository;

    @GetMapping("/{username}")
    public List<CartItem> getCart(@PathVariable String username) {
        logger.info("Getting cart for user: {}", username);
        return cartItemRepository.findByUsername(username);
    }

    @PostMapping
    public ResponseEntity<String> addToCart(@RequestBody CartItem cartItem) {
        logger.info("Adding to cart: {}", cartItem.getProductName());
        try {
            cartItemRepository.save(cartItem);
            logger.info("Successfully added to cart");
            return ResponseEntity.ok("Added to cart");
        } catch (Exception e) {
            logger.error("Failed to add to cart: {}", e.getMessage());
            return ResponseEntity.badRequest().body("Failed to add to cart: " + e.getMessage());
        }
    }

    @DeleteMapping("/{username}")
    @Transactional
    public ResponseEntity<String> clearCart(@PathVariable String username) {
        logger.info("Clearing cart for user: {}", username);
        try {
            cartItemRepository.deleteByUsername(username);
            return ResponseEntity.ok("Cart cleared");
        } catch (Exception e) {
            logger.error("Failed to clear cart: {}", e.getMessage());
            return ResponseEntity.badRequest().body("Failed to clear cart: " + e.getMessage());
        }
    }
}