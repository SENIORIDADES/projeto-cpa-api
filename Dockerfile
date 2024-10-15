FROM maven:3.8.4-openjdk-17-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package -DskipTests

FROM openjdk:17-slim
RUN mkdir -p /usr/local/lib/opentelemetry
COPY opentelemetry/opentelemetry-javaagent.jar /usr/local/lib/opentelemetry/opentelemetry-javaagent.jar
COPY --from=build /home/app/target/cpa-0.0.1-SNAPSHOT.jar /usr/local/lib/cpa-0.0.1-SNAPSHOT.jar
RUN chmod 755 /usr/local/lib/opentelemetry/opentelemetry-javaagent.jar
EXPOSE 8080
ENTRYPOINT ["java", "-javaagent:/usr/local/lib/opentelemetry/opentelemetry-javaagent.jar", "-Dotel.service.name=cpa", "-Dotel.traces.exporter=otlp", "-Dotel.metrics.exporter=none", "-Dotel.exporter.otlp.endpoint=http://collector-api:4318", "-Dotel.exporter.otlp.protocol=http/protobuf", "-jar", "/usr/local/lib/cpa-0.0.1-SNAPSHOT.jar"]
