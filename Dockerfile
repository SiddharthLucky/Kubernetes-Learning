# Use a base image with OpenJDK 17
FROM openjdk:17-jdk-slim

# Set environment variables for Gradle installation
ENV GRADLE_VERSION=7.6
ENV GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# Install dependencies and Gradle
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    mkdir -p /opt/gradle && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify Gradle installation
RUN gradle --version

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Build the application using Gradle
RUN gradle clean build --no-daemon

# Copy the generated JAR to a fixed name and location as kube-learning.jar
RUN cp /app/build/libs/kube-learning-0.0.1-SNAPSHOT.jar /app/kube-learning.jar

# Expose the application port (default for Spring Boot is 8080)
EXPOSE 8080

# Set the ENTRYPOINT to run the Spring Boot JAR
ENTRYPOINT ["java", "-jar", "/app/kube-learning.jar"]