

FROM eclipse-temurin:17-jdk-alpine as build

WORKDIR /workspace/app

COPY ./avenirs-api/mvnw .
COPY ./avenirs-api/.mvn .mvn
COPY ./avenirs-api/pom.xml .
COPY ./avenirs-api/src src

RUN ./mvnw clean install package -DskipTests
RUN mkdir -p ./target/dependency && (cd ./target/dependency; jar -xf ../*.jar)


FROM eclipse-temurin:17-jdk-alpine
WORKDIR /workspace/app
ARG AVENIRS_API_VERSION=0.0.0
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build /workspace/app/target/avenirs-api-${AVENIRS_API_VERSION}-SNAPSHOT.jar /app/avenirs-api.jar

ENTRYPOINT ["java", "-server", "-noverify", "-Xmx2048M", "-jar", "/app/avenirs-api.jar"]