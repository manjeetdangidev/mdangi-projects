package com.ecommerce.cartservice.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "cart_items")
@Data
public class CartItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private Long productId;
    private String productName;
    private Double price;
    private Integer quantity;
    private String imageUrl;
}