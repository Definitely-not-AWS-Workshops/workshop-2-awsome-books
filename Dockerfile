# syntax=docker/dockerfile:1

ARG JAVA_VERSION=17

FROM eclipse-temurin:${JAVA_VERSION}-jdk-alpine as base
WORKDIR /build
COPY --chmod=0755 gradlew gradlew
COPY build.gradle .
COPY gradle/ gradle/
COPY settings.gradle .
COPY gradle.properties .

# FROM base as deps
# WORKDIR /build
# RUN --mount=type=cache,target=/root/.gradle \
#     ./gradlew build -x test --stacktrace

FROM base as package
WORKDIR /build
COPY ./src src/
RUN --mount=type=cache,target=/root/.gradle \
    ./gradlew bootJar -x test && \
    mv build/libs/*.jar build/libs/app.jar

FROM package as extract
WORKDIR /build
RUN java -Djarmode=layertools -jar build/libs/app.jar extract --destination extracted

FROM extract as development
WORKDIR /build
RUN cp -r /build/extracted/dependencies/. ./
RUN cp -r /build/extracted/spring-boot-loader/. ./
RUN cp -r /build/extracted/snapshot-dependencies/. ./
RUN cp -r /build/extracted/application/. ./
EXPOSE 8080
CMD [ "java", "-Dspring.profiles.active=dev", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'", "org.springframework.boot.loader.JarLauncher" ]

FROM eclipse-temurin:${JAVA_VERSION}-jdk-alpine AS production
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser
# USER appuser
COPY --from=extract build/extracted/dependencies/. ./
COPY --from=extract build/extracted/spring-boot-loader/. ./
COPY --from=extract build/extracted/snapshot-dependencies/. ./
COPY --from=extract build/extracted/application/. ./
EXPOSE 8080
ENTRYPOINT [ "java", "-Dspring.profiles.active=prod", "org.springframework.boot.loader.JarLauncher" ]
