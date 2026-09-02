# Build stage
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy Maven project files
COPY pom.xml .

# Download dependencies first for better Docker caching
RUN mvn dependency:go-offline -B

# Copy application source
COPY src ./src

# Build the WAR
RUN mvn clean package -DskipTests -B


# Runtime stage
FROM tomcat:9.0-jdk17-temurin

# Remove Tomcat's default applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR as the root application
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Configure the application to use Render's PORT
RUN sed -i 's/port="8080"/port="${PORT:-10000}"/' /usr/local/tomcat/conf/server.xml

# Render web services use port 10000 by default
EXPOSE 10000

# Start Tomcat in the foreground
CMD ["catalina.sh", "run"]
