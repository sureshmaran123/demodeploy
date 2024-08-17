# Use a base image with JDK
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file into the container
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose the new port
EXPOSE 8070

# Run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
