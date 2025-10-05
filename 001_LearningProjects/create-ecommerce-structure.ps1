# PowerShell Script to Create Ecommerce Microservices Project Structure
# Run this in Windows PowerShell as Administrator if needed for directory creation
# After running, open the folder in IntelliJ IDEA for full structure and code visibility

$rootDir = "001_ecommerce_microservices_springboot_react_mysql"
New-Item -ItemType Directory -Path $rootDir -Force | Out-Null
Set-Location $rootDir

# Create .gitignore (root)
$gitIgnoreContent = @"
# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties
.mvn/wrapper/maven-wrapper.jar

# IDE
.idea/
*.iws
*.iml
*.ipr
.vscode/
.project
.classpath

# OS
.DS_Store
Thumbs.db

# Logs
logs/

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Env
.env
"@
New-Item -ItemType File -Path ".gitignore" -Force | Out-Null
Set-Content -Path ".gitignore" -Value $gitIgnoreContent

# Create README.md (root)
$readmeContent = @"
# Ecommerce Microservices with Spring Boot, React, MySQL

A full-stack ecommerce app using Spring Boot microservices, Eureka for discovery, API Gateway, JWT auth (BCrypt), React frontend, and MySQL.

## Structure
- **backend/**: Spring Boot services
  - eureka-server: Service discovery
  - api-gateway: Routing
  - user-service: Auth & users
  - product-service: Products
  - order-service: Orders
- **frontend/**: React app

## Prerequisites
- Java 17+
- Maven 3.8+
- Node.js 18+
- MySQL 8+ (Docker: `docker run --name mysql -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 -d mysql:8`)

## Setup
1. Create MySQL DBs: userdb, productdb, orderdb (user: root, pass: password)
2. Build backend: `mvn clean install` (from root)
3. Run services:
   - Eureka: `cd backend/eureka-server && mvn spring-boot:run`
   - Gateway: `cd backend/api-gateway && mvn spring-boot:run`
   - User: `cd backend/user-service && mvn spring-boot:run`
   - Product: `cd backend/product-service && mvn spring-boot:run`
   - Order: `cd backend/order-service && mvn spring-boot:run`
4. Frontend: `cd frontend && npm install && npm start`
5. Access: http://localhost:3000/login

## Features
- JWT Auth with BCrypt
- Service discovery via Eureka
- API routing via Gateway
- CRUD for products/orders

## Notes
- Update application.properties for prod DB.
- Add CORS in Gateway if needed.
"@
New-Item -ItemType File -Path "README.md" -Force | Out-Null
Set-Content -Path "README.md" -Value $readmeContent

# Create pom.xml (root - parent)
$pomRootContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.6</version>
        <relativePath/>
    </parent>
    <groupId>com.ecommerce</groupId>
    <artifactId>ecommerce-parent</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>

    <properties>
        <java.version>17</java.version>
        <spring-cloud.version>2025.0.0</spring-cloud.version>
    </properties>

    <modules>
        <module>backend/eureka-server</module>
        <module>backend/api-gateway</module>
        <module>backend/user-service</module>
        <module>backend/product-service</module>
        <module>backend/order-service</module>
    </modules>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
'@
New-Item -ItemType File -Path "pom.xml" -Force | Out-Null
Set-Content -Path "pom.xml" -Value $pomRootContent

# Create backend directory
New-Item -ItemType Directory -Path "backend" -Force | Out-Null

# backend/eureka-server
New-Item -ItemType Directory -Path "backend\eureka-server\src\main\java\com\ecommerce\eurekaserver" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\eureka-server\src\main\resources" -Force | Out-Null

$eurekaPomContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.ecommerce</groupId>
        <artifactId>ecommerce-parent</artifactId>
        <version>1.0.0</version>
    </parent>
    <artifactId>eureka-server</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
'@
New-Item -ItemType File -Path "backend\eureka-server\pom.xml" -Force | Out-Null
Set-Content -Path "backend\eureka-server\pom.xml" -Value $eurekaPomContent

$eurekaAppContent = @"
package com.ecommerce.eurekaserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
"@
New-Item -ItemType File -Path "backend\eureka-server\src\main\java\com\ecommerce\eurekaserver\EurekaServerApplication.java" -Force | Out-Null
Set-Content -Path "backend\eureka-server\src\main\java\com\ecommerce\eurekaserver\EurekaServerApplication.java" -Value $eurekaAppContent

$eurekaPropsContent = @"
server.port=8761
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
logging.level.com.netflix.eureka=OFF
logging.level.com.netflix.discovery=OFF
"@
New-Item -ItemType File -Path "backend\eureka-server\src\main\resources\application.properties" -Force | Out-Null
Set-Content -Path "backend\eureka-server\src\main\resources\application.properties" -Value $eurekaPropsContent

# backend/api-gateway
New-Item -ItemType Directory -Path "backend\api-gateway\src\main\java\com\ecommerce\apigateway" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\api-gateway\src\main\resources" -Force | Out-Null

$gatewayPomContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.ecommerce</groupId>
        <artifactId>ecommerce-parent</artifactId>
        <version>1.0.0</version>
    </parent>
    <artifactId>api-gateway</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-gateway</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
'@
New-Item -ItemType File -Path "backend\api-gateway\pom.xml" -Force | Out-Null
Set-Content -Path "backend\api-gateway\pom.xml" -Value $gatewayPomContent

$gatewayAppContent = @"
package com.ecommerce.apigateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient
public class ApiGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }
}
"@
New-Item -ItemType File -Path "backend\api-gateway\src\main\java\com\ecommerce\apigateway\ApiGatewayApplication.java" -Force | Out-Null
Set-Content -Path "backend\api-gateway\src\main\java\com\ecommerce\apigateway\ApiGatewayApplication.java" -Value $gatewayAppContent

$gatewayPropsContent = @"
server.port=8080
spring.application.name=api-gateway
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
spring.cloud.gateway.discovery.locator.enabled=true
spring.cloud.gateway.discovery.locator.lower-case-service-id=true
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-origins=*
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-methods=*
spring.cloud.gateway.globalcors.cors-configurations.[/**].allowed-headers=*
"@
New-Item -ItemType File -Path "backend\api-gateway\src\main\resources\application.properties" -Force | Out-Null
Set-Content -Path "backend\api-gateway\src\main\resources\application.properties" -Value $gatewayPropsContent

# backend/user-service
New-Item -ItemType Directory -Path "backend\user-service\src\main\java\com\ecommerce\userservice\config" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\user-service\src\main\java\com\ecommerce\userservice\controller" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\user-service\src\main\java\com\ecommerce\userservice\entity" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\user-service\src\main\java\com\ecommerce\userservice\repository" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\user-service\src\main\java\com\ecommerce\userservice\service" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\user-service\src\main\java\com\ecommerce\userservice\util" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\user-service\src\main\resources" -Force | Out-Null

$userPomContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.ecommerce</groupId>
        <artifactId>ecommerce-parent</artifactId>
        <version>1.0.0</version>
    </parent>
    <artifactId>user-service</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>0.12.3</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>0.12.3</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>0.12.3</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
'@
New-Item -ItemType File -Path "backend\user-service\pom.xml" -Force | Out-Null
Set-Content -Path "backend\user-service\pom.xml" -Value $userPomContent

$userAppContent = @"
package com.ecommerce.userservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient
public class UserServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\UserServiceApplication.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\UserServiceApplication.java" -Value $userAppContent

$securityConfigContent = @"
package com.ecommerce.userservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/**").permitAll()
                .anyRequest().authenticated()
            );
        return http.build();
    }
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\config\SecurityConfig.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\config\SecurityConfig.java" -Value $securityConfigContent

$authControllerContent = @"
package com.ecommerce.userservice.controller;

import com.ecommerce.userservice.entity.User;
import com.ecommerce.userservice.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody User user) {
        try {
            String token = authService.register(user);
            return ResponseEntity.ok(token);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody User user) {
        String token = authService.login(user.getUsername(), user.getPassword());
        if (token != null) {
            return ResponseEntity.ok(token);
        }
        return ResponseEntity.badRequest().build();
    }
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\controller\AuthController.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\controller\AuthController.java" -Value $authControllerContent

$userEntityContent = @"
package com.ecommerce.userservice.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private String password;
    private String email;
    private String role = "USER";
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\entity\User.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\entity\User.java" -Value $userEntityContent

$userRepoContent = @"
package com.ecommerce.userservice.repository;

import com.ecommerce.userservice.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\repository\UserRepository.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\repository\UserRepository.java" -Value $userRepoContent

$authServiceContent = @"
package com.ecommerce.userservice.service;

import com.ecommerce.userservice.entity.User;
import com.ecommerce.userservice.repository.UserRepository;
import com.ecommerce.userservice.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JwtUtil jwtUtil;
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public String register(User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new RuntimeException("User already exists");
        }
        user.setPassword(encoder.encode(user.getPassword()));
        userRepository.save(user);
        return jwtUtil.generateToken(user.getUsername());
    }

    public String login(String username, String password) {
        User user = userRepository.findByUsername(username).orElse(null);
        if (user != null && encoder.matches(password, user.getPassword())) {
            return jwtUtil.generateToken(username);
        }
        return null;
    }
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\service\AuthService.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\service\AuthService.java" -Value $authServiceContent

$jwtUtilContent = @"
package com.ecommerce.userservice.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {
    private SecretKey secretKey = Keys.secretKeyFor(SignatureAlgorithm.HS512);
    private long jwtExpiration = 86400000L; // 24 hours

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parser().verifyWith(secretKey).build().parseSignedClaims(token).getPayload();
    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public String generateToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, username);
    }

    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder().claims(claims).subject(subject).issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(secretKey).compact();
    }

    public Boolean validateToken(String token, String username) {
        final String extractedUsername = extractUsername(token);
        return (extractedUsername.equals(username) && !isTokenExpired(token));
    }
}
"@
New-Item -ItemType File -Path "backend\user-service\src\main\java\com\ecommerce\userservice\util\JwtUtil.java" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\java\com\ecommerce\userservice\util\JwtUtil.java" -Value $jwtUtilContent

$userPropsContent = @"
server.port=8081
spring.application.name=user-service
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
spring.datasource.url=jdbc:mysql://localhost:3306/userdb?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
jwt.secret=your-secret-key-here
"@
New-Item -ItemType File -Path "backend\user-service\src\main\resources\application.properties" -Force | Out-Null
Set-Content -Path "backend\user-service\src\main\resources\application.properties" -Value $userPropsContent

# backend/product-service
New-Item -ItemType Directory -Path "backend\product-service\src\main\java\com\ecommerce\productservice\controller" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\product-service\src\main\java\com\ecommerce\productservice\entity" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\product-service\src\main\java\com\ecommerce\productservice\repository" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\product-service\src\main\resources" -Force | Out-Null

$productPomContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.ecommerce</groupId>
        <artifactId>ecommerce-parent</artifactId>
        <version>1.0.0</version>
    </parent>
    <artifactId>product-service</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
'@
New-Item -ItemType File -Path "backend\product-service\pom.xml" -Force | Out-Null
Set-Content -Path "backend\product-service\pom.xml" -Value $productPomContent

$productAppContent = @"
package com.ecommerce.productservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient
public class ProductServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProductServiceApplication.class, args);
    }
}
"@
New-Item -ItemType File -Path "backend\product-service\src\main\java\com\ecommerce\productservice\ProductServiceApplication.java" -Force | Out-Null
Set-Content -Path "backend\product-service\src\main\java\com\ecommerce\productservice\ProductServiceApplication.java" -Value $productAppContent

$productControllerContent = @"
package com.ecommerce.productservice.controller;

import com.ecommerce.productservice.entity.Product;
import com.ecommerce.productservice.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/products")
public class ProductController {
    @Autowired
    private ProductRepository repository;

    @GetMapping
    public List<Product> getAll() {
        return repository.findAll();
    }

    @PostMapping
    public Product create(@RequestBody Product product) {
        return repository.save(product);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getById(@PathVariable Long id) {
        return repository.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> update(@PathVariable Long id, @RequestBody Product product) {
        if (repository.existsById(id)) {
            product.setId(id);
            return ResponseEntity.ok(repository.save(product));
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
"@
New-Item -ItemType File -Path "backend\product-service\src\main\java\com\ecommerce\productservice\controller\ProductController.java" -Force | Out-Null
Set-Content -Path "backend\product-service\src\main\java\com\ecommerce\productservice\controller\ProductController.java" -Value $productControllerContent

$productEntityContent = @"
package com.ecommerce.productservice.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "products")
@Data
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private double price;
    private int stock;
}
"@
New-Item -ItemType File -Path "backend\product-service\src\main\java\com\ecommerce\productservice\entity\Product.java" -Force | Out-Null
Set-Content -Path "backend\product-service\src\main\java\com\ecommerce\productservice\entity\Product.java" -Value $productEntityContent

$productRepoContent = @"
package com.ecommerce.productservice.repository;

import com.ecommerce.productservice.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
}
"@
New-Item -ItemType File -Path "backend\product-service\src\main\java\com\ecommerce\productservice\repository\ProductRepository.java" -Force | Out-Null
Set-Content -Path "backend\product-service\src\main\java\com\ecommerce\productservice\repository\ProductRepository.java" -Value $productRepoContent

$productPropsContent = @"
server.port=8082
spring.application.name=product-service
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
spring.datasource.url=jdbc:mysql://localhost:3306/productdb?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
"@
New-Item -ItemType File -Path "backend\product-service\src\main\resources\application.properties" -Force | Out-Null
Set-Content -Path "backend\product-service\src\main\resources\application.properties" -Value $productPropsContent

# backend/order-service
New-Item -ItemType Directory -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\controller" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\entity" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\repository" -Force | Out-Null
New-Item -ItemType Directory -Path "backend\order-service\src\main\resources" -Force | Out-Null

$orderPomContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.ecommerce</groupId>
        <artifactId>ecommerce-parent</artifactId>
        <version>1.0.0</version>
    </parent>
    <artifactId>order-service</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
'@
New-Item -ItemType File -Path "backend\order-service\pom.xml" -Force | Out-Null
Set-Content -Path "backend\order-service\pom.xml" -Value $orderPomContent

$orderAppContent = @"
package com.ecommerce.orderservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;

@SpringBootApplication
@EnableEurekaClient
public class OrderServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(OrderServiceApplication.class, args);
    }
}
"@
New-Item -ItemType File -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\OrderServiceApplication.java" -Force | Out-Null
Set-Content -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\OrderServiceApplication.java" -Value $orderAppContent

$orderControllerContent = @"
package com.ecommerce.orderservice.controller;

import com.ecommerce.orderservice.entity.Order;
import com.ecommerce.orderservice.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/orders")
public class OrderController {
    @Autowired
    private OrderRepository repository;

    @GetMapping
    public List<Order> getAll() {
        return repository.findAll();
    }

    @PostMapping
    public Order create(@RequestBody Order order) {
        return repository.save(order);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Order> getById(@PathVariable Long id) {
        return repository.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
}
"@
New-Item -ItemType File -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\controller\OrderController.java" -Force | Out-Null
Set-Content -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\controller\OrderController.java" -Value $orderControllerContent

$orderEntityContent = @"
package com.ecommerce.orderservice.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
@Data
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long userId;
    private Long productId;
    private int quantity;
    private double totalPrice;
    private LocalDateTime orderDate = LocalDateTime.now();
    private String status = "PENDING";
}
"@
New-Item -ItemType File -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\entity\Order.java" -Force | Out-Null
Set-Content -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\entity\Order.java" -Value $orderEntityContent

$orderRepoContent = @"
package com.ecommerce.orderservice.repository;

import com.ecommerce.orderservice.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {
}
"@
New-Item -ItemType File -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\repository\OrderRepository.java" -Force | Out-Null
Set-Content -Path "backend\order-service\src\main\java\com\ecommerce\orderservice\repository\OrderRepository.java" -Value $orderRepoContent

$orderPropsContent = @"
server.port=8083
spring.application.name=order-service
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
spring.datasource.url=jdbc:mysql://localhost:3306/orderdb?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
"@
New-Item -ItemType File -Path "backend\order-service\src\main\resources\application.properties" -Force | Out-Null
Set-Content -Path "backend\order-service\src\main\resources\application.properties" -Value $orderPropsContent

# Create frontend directory
New-Item -ItemType Directory -Path "frontend\public" -Force | Out-Null
New-Item -ItemType Directory -Path "frontend\src\components" -Force | Out-Null

# frontend/.gitignore
$frontendGitIgnoreContent = @"
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# production
/build

# misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*
"@
New-Item -ItemType File -Path "frontend\.gitignore" -Force | Out-Null
Set-Content -Path "frontend\.gitignore" -Value $frontendGitIgnoreContent

# frontend/package.json
$packageJsonContent = @'
{
  "name": "ecommerce-frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.16.4",
    "@testing-library/react": "^13.3.0",
    "@testing-library/user-event": "^13.5.0",
    "axios": "^1.7.2",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.1",
    "react-scripts": "5.0.1",
    "web-vitals": "^2.1.4"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "proxy": "http://localhost:8080"
}
'@
New-Item -ItemType File -Path "frontend\package.json" -Force | Out-Null
Set-Content -Path "frontend\package.json" -Value $packageJsonContent

# frontend/public/index.html
$indexHtmlContent = @'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta name="description" content="Ecommerce App" />
    <title>Ecommerce App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
'@
New-Item -ItemType File -Path "frontend\public\index.html" -Force | Out-Null
Set-Content -Path "frontend\public\index.html" -Value $indexHtmlContent

# Create empty favicon.ico (binary file placeholder; replace with actual if needed)
New-Item -ItemType File -Path "frontend\public\favicon.ico" -Force | Out-Null

# frontend/src/index.js
$indexJsContent = @"
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
"@
New-Item -ItemType File -Path "frontend\src\index.js" -Force | Out-Null
Set-Content -Path "frontend\src\index.js" -Value $indexJsContent

# frontend/src/App.js
$appJsContent = @"
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Login from './components/Login';
import Products from './components/Products';
import Orders from './components/Orders';
import './index.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/login" element={<Login />} />
          <Route path="/products" element={<Products />} />
          <Route path="/orders" element={<Orders />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
"@
New-Item -ItemType File -Path "frontend\src\App.js" -Force | Out-Null
Set-Content -Path "frontend\src\App.js" -Value $appJsContent

# frontend/src/components/Login.js
$loginJsContent = @"
import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

const Login = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post('/auth/login', { username, password });
      localStorage.setItem('token', res.data);
      navigate('/products');
    } catch (err) {
      alert('Login failed');
      console.error(err);
    }
  };

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post('/auth/register', { username, password, email: `${username}@example.com` });
      localStorage.setItem('token', res.data);
      navigate('/products');
    } catch (err) {
      alert('Registration failed');
      console.error(err);
    }
  };

  return (
    <div style={{ padding: '20px' }}>
      <h2>Ecommerce Login/Register</h2>
      <form onSubmit={handleLogin}>
        <input
          type="text"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          required
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
        <button type="submit">Login</button>
        <button type="button" onClick={handleRegister}>Register</button>
      </form>
    </div>
  );
};

export default Login;
"@
New-Item -ItemType File -Path "frontend\src\components\Login.js" -Force | Out-Null
Set-Content -Path "frontend\src\components\Login.js" -Value $loginJsContent

# frontend/src/components/Products.js
$productsJsContent = @"
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

const Products = () => {
  const [products, setProducts] = useState([]);
  const token = localStorage.getItem('token');

  useEffect(() => {
    if (token) {
      axios.get('/products', { 
        headers: { Authorization: `Bearer ${token}` } 
      })
        .then(res => setProducts(res.data))
        .catch(err => {
          console.error(err);
          localStorage.removeItem('token');
          window.location.href = '/login';
        });
    }
  }, [token]);

  return (
    <div style={{ padding: '20px' }}>
      <h2>Products</h2>
      <Link to="/orders">View Orders</Link>
      <ul>
        {products.map(p => (
          <li key={p.id}>
            {p.name} - ${p.price} (Stock: {p.stock})
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Products;
"@
New-Item -ItemType File -Path "frontend\src\components\Products.js" -Force | Out-Null
Set-Content -Path "frontend\src\components\Products.js" -Value $productsJsContent

# frontend/src/components/Orders.js
$ordersJsContent = @"
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const token = localStorage.getItem('token');

  useEffect(() => {
    if (token) {
      axios.get('/orders', { 
        headers: { Authorization: `Bearer ${token}` } 
      })
        .then(res => setOrders(res.data))
        .catch(err => {
          console.error(err);
          localStorage.removeItem('token');
          window.location.href = '/login';
        });
    }
  }, [token]);

  return (
    <div style={{ padding: '20px' }}>
      <h2>Orders</h2>
      <Link to="/products">Back to Products</Link>
      <ul>
        {orders.map(o => (
          <li key={o.id}>
            Order #{o.id} - Product ID: {o.productId}, Qty: {o.quantity}, Total: ${o.totalPrice}, Status: {o.status}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Orders;
"@
New-Item -ItemType File -Path "frontend\src\components\Orders.js" -Force | Out-Null
Set-Content -Path "frontend\src\components\Orders.js" -Value $ordersJsContent

# frontend/src/index.css
$indexCssContent = @"
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}

.App {
  text-align: center;
}

form {
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 300px;
  margin: 0 auto;
}

input, button {
  padding: 8px;
  font-size: 16px;
}

ul {
  list-style: none;
  padding: 0;
}

li {
  margin: 10px 0;
  padding: 10px;
  border: 1px solid #ccc;
}
"@
New-Item -ItemType File -Path "frontend\src\index.css" -Force | Out-Null
Set-Content -Path "frontend\src\index.css" -Value $indexCssContent

Write-Output "Project structure created successfully in $rootDir! Open in IntelliJ IDEA to view all files and code."
Write-Output "Note: 'target/' folders will be generated on Maven build. Run 'git init' for Git setup."