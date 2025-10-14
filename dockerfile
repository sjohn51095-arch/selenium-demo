
# Stage 1: Build the project using Maven
FROM maven:3.9.5-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build the project and skip tests
RUN mvn clean package -DskipTests

# Stage 2: Use lightweight JRE to run the app
FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose a port if needed (optional, e.g., 8080)
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java","-jar","app.jar"]
