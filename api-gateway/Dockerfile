# Multi-stage build for API Gateway
# Stage 1: Build the application
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Railwayのビルドコンテキストがプロジェクトルートの場合、サービスディレクトリ内のファイルをコピー
COPY api-gateway/gradlew* ./
COPY api-gateway/gradle ./gradle
COPY api-gateway/build.gradle.kts ./
COPY api-gateway/settings.gradle.kts* ./
COPY api-gateway/src ./src

# Make gradlew executable and build the application
RUN chmod +x gradlew && \
    ./gradlew clean build -x test

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine

RUN apk add --no-cache wget

WORKDIR /app

# Copy the built JAR file from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Set environment variables
ENV JAVA_OPTS="-Xms512m -Xmx1g -XX:+UseG1GC"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/health || exit 1

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"] 