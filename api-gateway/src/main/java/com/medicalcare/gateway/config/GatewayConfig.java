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
                        .path("/api/users/**")
                        .filters(f -> f
                                .rewritePath("/api/users/(?<segment>.*)", "/api/users/${segment}")
                                .addRequestHeader("X-Response-Time", System.currentTimeMillis() + ""))
                        .uri("lb://user-service"))

                // Application Service へのルーティング
                .route("application-service", r -> r
                        .path("/api/applications/**")
                        .filters(f -> f
                                .rewritePath("/api/applications/(?<segment>.*)", "/api/applications/${segment}")
                                .addRequestHeader("X-Response-Time", System.currentTimeMillis() + ""))
                        .uri("lb://application-service"))

                // Notification Service へのルーティング
                .route("notification-service", r -> r
                        .path("/api/notifications/**")
                        .filters(f -> f
                                .rewritePath("/api/notifications/(?<segment>.*)", "/api/notifications/${segment}")
                                .addRequestHeader("X-Response-Time", System.currentTimeMillis() + ""))
                        .uri("lb://notification-service"))

                // File Service へのルーティング
                .route("file-service", r -> r
                        .path("/api/files/**")
                        .filters(f -> f
                                .rewritePath("/api/files/(?<segment>.*)", "/api/files/${segment}")
                                .addRequestHeader("X-Response-Time", System.currentTimeMillis() + ""))
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