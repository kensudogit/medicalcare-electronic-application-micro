package com.medicalcare.gateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * API Gateway設定クラス
 * マイクロサービスへのルーティング設定を定義
 */
@Configuration
public class GatewayConfig {

    /**
     * ルート設定
     * 各マイクロサービスへのルーティングルールを定義
     */
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // User Service へのルーティング
                .route("user-service", r -> r
                        .path("/api/users", "/api/users/**")
                        .filters(f -> f
                                .addRequestHeader("X-Response-Time", String.valueOf(System.currentTimeMillis())))
                        .uri("lb://user-service"))

                // Application Service へのルーティング
                .route("application-service", r -> r
                        .path("/api/applications", "/api/applications/**")
                        .filters(f -> f
                                .addRequestHeader("X-Response-Time", String.valueOf(System.currentTimeMillis())))
                        .uri("lb://application-service"))

                // Notification Service へのルーティング
                .route("notification-service", r -> r
                        .path("/api/notifications", "/api/notifications/**")
                        .filters(f -> f
                                .addRequestHeader("X-Response-Time", String.valueOf(System.currentTimeMillis())))
                        .uri("lb://notification-service"))

                // File Service へのルーティング
                .route("file-service", r -> r
                        .path("/api/files", "/api/files/**")
                        .filters(f -> f
                                .addRequestHeader("X-Response-Time", String.valueOf(System.currentTimeMillis())))
                        .uri("lb://file-service"))

                // Medical Institution Service へのルーティング（予定）
                .route("medical-institution-service", r -> r
                        .path("/api/institutions/**")
                        .filters(f -> f
                                .rewritePath("/api/institutions/(?<segment>.*)", "/api/institutions/${segment}")
                                .addRequestHeader("X-Response-Time", System.currentTimeMillis() + ""))
                        .uri("lb://medical-institution-service"))

                .build();
    }
}