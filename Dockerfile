# Build stage
FROM maven:3.8.6-openjdk-17-slim AS builder

WORKDIR /app

# Copy pom.xml and dependencies first (to leverage Docker cache)
COPY pom.xml /app/pom.xml
RUN mvn dependency:go-offline

# Copy source and build the application
COPY src /app/src
RUN mvn clean package

# Run stage
FROM openjdk:17-jdk-alpine

WORKDIR /app

# Copy the jar from the build stage
COPY --from=builder /app/target/my-java-app.jar /app/my-java-app.jar

# Run the Java application
CMD ["java", "-jar", "my-java-app.jar"]
