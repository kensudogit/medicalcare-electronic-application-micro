FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# docker-composeのビルドコンテキストがサービスディレクトリの場合、直接ファイルをコピー
COPY gradlew* ./
COPY gradle ./gradle
COPY build.gradle.kts ./
COPY settings.gradle.kts* ./
COPY src ./src

RUN chmod +x ./gradlew
RUN ./gradlew build -x test

FROM eclipse-temurin:21-jre-alpine

RUN apk add --no-cache wget

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

USER appuser

EXPOSE 8082

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8082/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"] 