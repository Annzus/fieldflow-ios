# FieldFlow Backend

Spring Boot API for the FieldFlow portfolio app.

## Stack

- Java 21
- Spring Boot 3
- Spring Security
- Spring Data JPA
- PostgreSQL
- Flyway
- OpenAPI / Swagger UI
- JUnit 5 / MockMvc

## Demo Account

```text
email: demo@fieldflow.app
password: password
```

## Run PostgreSQL

```bash
docker compose up -d
```

## Run API

Requires Java 21 and Maven:

```bash
mvn spring-boot:run
```

Swagger UI:

```text
http://localhost:8080/swagger-ui.html
```

## Test

Requires Java 21 and Maven:

```bash
mvn test
```

Without local Java/Maven, tests can be run through Docker:

```bash
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  maven:3.9-eclipse-temurin-21 \
  mvn test
```

## Endpoints

```http
POST /api/auth/login
POST /api/auth/refresh
POST /api/auth/logout

GET  /api/members

GET  /api/work-items
GET  /api/work-items/{id}
POST /api/work-items
PUT  /api/work-items/{id}
GET  /api/work-items/{id}/history
```

All endpoints except login and Swagger require:

```http
Authorization: Bearer demo-access-token
```
