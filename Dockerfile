# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-alpine

# Set the working directory
WORKDIR /app

# Install Maven (if you are using Maven)
RUN apk add --no-cache curl tar bash && \
    curl -fsSL https://apache.mirror.digitalpacific.com.au/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz | tar -xz -C /opt && \
    ln -s /opt/apache-maven-3.8.6/bin/mvn /usr/bin/mvn

# Copy the project’s pom.xml file into the container (necessary for Maven)
COPY pom.xml .

# Download dependencies (to leverage Docker cache)
RUN mvn dependency:go-offline

# Copy the rest of the project files into the container
COPY . .

# Build the project to generate the .jar file
RUN mvn clean package -DskipTests

# Copy the built .jar file to a suitable location
COPY target/Server-0.0.1-SNAPSHOT.jar app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]
