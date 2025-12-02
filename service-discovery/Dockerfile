FROM eclipse-temurin:21-jdk-alpine as builder

WORKDIR /app

# すべてのファイルをコピー
COPY . .

# デバッグ: コピーされたファイルを確認
RUN ls -la

# gradlewが存在するか確認してから実行権限を付与
RUN if [ -f ./gradlew ]; then chmod +x ./gradlew; else echo "ERROR: gradlew not found!" && ls -la && exit 1; fi
RUN ./gradlew build -x test

FROM eclipse-temurin:21-jre-alpine

RUN apk add --no-cache wget

RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar

USER appuser

EXPOSE 8761

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8761/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"] 