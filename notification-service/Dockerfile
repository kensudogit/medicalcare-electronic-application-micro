FROM eclipse-temurin:21-jdk-alpine as builder

WORKDIR /app

# Gradle関連ファイルを明示的にコピー（確実に含めるため）
COPY gradlew* ./
COPY gradle ./gradle
COPY build.gradle.kts ./
COPY settings.gradle.kts* ./

# ソースコードをコピー
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

EXPOSE 8083

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8083/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"] 