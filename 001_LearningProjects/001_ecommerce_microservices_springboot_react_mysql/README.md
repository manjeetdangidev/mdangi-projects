# Ecommerce Microservices with Spring Boot, React, MySQL

A full-stack ecommerce app using Spring Boot microservices, Eureka for discovery, API Gateway, JWT auth (BCrypt), React frontend, and MySQL.

## Architecture
```
Frontend (React) → API Gateway → Microservices
                      ↓
                 Eureka Server
                      ↓
            [User, Product, Order, Cart, Payment]
```

## Microservices Overview

### 1. **Eureka Server** (Port: 8761)
- **Purpose**: Service discovery and registration
- **Endpoints**: 
  - `GET /` - Eureka dashboard
- **Database**: None

### 2. **API Gateway** (Port: 8080)
- **Purpose**: Single entry point, routing, authentication
- **Endpoints**:
  - `POST /auth/login` - User login
  - `POST /auth/register` - User registration
  - `GET /products/**` - Route to product-service
  - `GET /orders/**` - Route to order-service
  - `GET /cart/**` - Route to cart-service
  - `POST /payment/**` - Route to payment-service
- **Database**: userdb (for authentication)

### 3. **User Service** (Port: 8081)
- **Purpose**: User data management (no auth - moved to Gateway)
- **Endpoints**: Currently unused (auth moved to Gateway)
- **Database**: userdb

### 4. **Product Service** (Port: 8082)
- **Purpose**: Product catalog management
- **Endpoints**:
  - `GET /products` - List all products
  - `GET /products/{id}` - Get product by ID
  - `POST /products` - Create product
  - `PUT /products/{id}` - Update product
  - `DELETE /products/{id}` - Delete product
- **Database**: productdb

### 5. **Order Service** (Port: 8083)
- **Purpose**: Order management
- **Endpoints**:
  - `GET /orders` - List all orders
  - `GET /orders/{id}` - Get order by ID
  - `POST /orders` - Create order
  - `PUT /orders/{id}` - Update order
  - `DELETE /orders/{id}` - Delete order
- **Database**: orderdb

### 6. **Cart Service** (Port: 8084)
- **Purpose**: Shopping cart management
- **Endpoints**:
  - `GET /cart/{username}` - Get user's cart
  - `POST /cart` - Add item to cart
  - `DELETE /cart/{username}` - Clear user's cart
- **Database**: cartdb

### 7. **Payment Service** (Port: 8085)
- **Purpose**: Payment processing (fake implementation)
- **Endpoints**:
  - `POST /payment/process` - Process payment (always returns success)
- **Database**: None (stateless)

## Prerequisites
- Java 17+
- Maven 3.8+
- Node.js 18+
- MySQL 8+ (Docker: `docker run --name mysql -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 -d mysql:8`)

## Quick Start

### Backend (All Services)
```bash
cd backend
start-all-services.cmd
```

### Manual Setup
1. **Create MySQL DBs**: userdb, productdb, orderdb, cartdb (user: root, pass: password)
2. **Build all services**: `mvn clean install` (from backend/)
3. **Run services in order**:
   ```bash
   # Terminal 1 - Eureka Server
   cd backend/eureka-server && mvn spring-boot:run
   
   # Terminal 2 - API Gateway (wait for Eureka)
   cd backend/api-gateway && mvn spring-boot:run
   
   # Terminal 3 - Product Service
   cd backend/product-service && mvn spring-boot:run
   
   # Terminal 4 - Order Service
   cd backend/order-service && mvn spring-boot:run
   
   # Terminal 5 - Cart Service
   cd backend/cart-service && mvn spring-boot:run
   
   # Terminal 6 - Payment Service
   cd backend/payment-service && mvn spring-boot:run
   ```

### Frontend
```bash
cd frontend
npm install
npm start
```

## Access Points
- **Frontend**: http://localhost:3000
- **API Gateway**: http://localhost:8080
- **Eureka Dashboard**: http://localhost:8761

## Features
- **Authentication**: JWT with BCrypt (handled by API Gateway)
- **Service Discovery**: Eureka Server
- **API Routing**: Spring Cloud Gateway
- **Shopping Cart**: Add/remove items, view cart
- **Payment**: Fake payment processing
- **Responsive UI**: Mobile-friendly product grid
- **Order Management**: View order history

## API Flow
1. **Login**: `POST /auth/login` → JWT token
2. **Browse Products**: `GET /products` → Product list
3. **Add to Cart**: `POST /cart` → Cart item added
4. **View Cart**: `GET /cart/{username}` → Cart items
5. **Payment**: `POST /payment/process` → Payment success
6. **View Orders**: `GET /orders` → Order history

## Database Schema
- **users**: id, username, password, email, role
- **products**: id, name, price, stock
- **orders**: id, productId, quantity, totalPrice, status
- **cart_items**: id, username, productId, productName, price, quantity, imageUrl

## Notes
- All requests go through API Gateway (port 8080)
- Authentication handled centrally at Gateway level
- Services auto-register with Eureka
- CORS configured at Gateway level
- Payment service always returns success (demo purposes)
