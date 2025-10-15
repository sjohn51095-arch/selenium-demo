# -------------------------
# Stage 1: Build the project using Maven
# -------------------------
FROM maven:3.9.5-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy Maven files first for caching dependencies
COPY pom.xml .

# Copy source code
COPY src ./src
COPY testng.xml .  

# Build the project (skip tests, tests will run later in container)
RUN mvn clean package -DskipTests

# -------------------------
# Stage 2: Runtime environment
# -------------------------
FROM eclipse-temurin:17

# Set working directory
WORKDIR /app

# Copy built JAR and TestNG files from builder
COPY --from=builder /app/pom.xml .
COPY --from=builder /app/src ./src
COPY --from=builder /app/testng.xml .

# Install Maven in runtime container to run tests
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Set environment variable for Selenium Hub (default if not provided)
ENV SELENIUM_URL=http://74.225.21.195:4444/wd/hub

# Run the TestNG tests using Maven Surefire
CMD ["mvn", "test", "-Dsurefire.suiteXmlFiles=testng.xml"]
