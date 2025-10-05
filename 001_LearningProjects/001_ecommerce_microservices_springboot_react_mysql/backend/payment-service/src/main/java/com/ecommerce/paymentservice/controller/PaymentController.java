package com.ecommerce.paymentservice.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/payment")
public class PaymentController {

    @PostMapping("/process")
    public ResponseEntity<Map<String, String>> processPayment(@RequestBody Map<String, Object> paymentData) {
        // Fake payment processing - always success
        return ResponseEntity.ok(Map.of(
            "status", "success",
            "message", "Payment processed successfully!",
            "transactionId", "TXN" + System.currentTimeMillis()
        ));
    }
}