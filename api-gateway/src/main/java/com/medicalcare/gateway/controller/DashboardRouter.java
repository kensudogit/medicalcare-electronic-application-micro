package com.medicalcare.gateway.controller;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.ServerResponse;

import static org.springframework.web.reactive.function.server.RequestPredicates.GET;
import static org.springframework.web.reactive.function.server.RouterFunctions.route;

/**
 * ダッシュボード用のルーター設定（WebFlux対応）
 */
@Configuration
public class DashboardRouter {

    /**
     * ダッシュボードページのルーティング
     */
    @Bean
    public RouterFunction<ServerResponse> dashboardRoutes() {
        return route(GET("/dashboard"), request -> {
            try {
                Resource resource = new ClassPathResource("static/dashboard.html");
                if (resource.exists()) {
                    return ServerResponse.ok()
                            .contentType(MediaType.TEXT_HTML)
                            .bodyValue(resource);
                } else {
                    return ServerResponse.ok()
                            .contentType(MediaType.TEXT_HTML)
                            .bodyValue(getDefaultDashboardHtml());
                }
            } catch (Exception e) {
                return ServerResponse.ok()
                        .contentType(MediaType.TEXT_HTML)
                        .bodyValue(getDefaultDashboardHtml());
            }
        })
        .andRoute(GET("/"), request -> {
            return ServerResponse.temporaryRedirect(
                    java.net.URI.create("/dashboard")
            ).build();
        });
    }

    private String getDefaultDashboardHtml() {
        return """
            <!DOCTYPE html>
            <html lang="ja">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>医療系電子申請システム - ダッシュボード</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
                    .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
                    .header { margin-bottom: 30px; padding-bottom: 20px; border-bottom: 2px solid #e0e0e0; }
                    .header h1 { color: #333; margin: 0; }
                    .services-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 20px; }
                    .service-card { background: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #007bff; }
                    .service-card h3 { margin-top: 0; color: #007bff; }
                    .service-links { display: flex; gap: 10px; margin-top: 15px; }
                    .service-links a { background: #007bff; color: white; padding: 8px 16px; text-decoration: none; border-radius: 4px; font-size: 14px; }
                    .service-links a:hover { background: #0056b3; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>医療系電子申請システム - ダッシュボード</h1>
                    </div>
                    <div class="services-grid">
                        <div class="service-card">
                            <h3>User Service</h3>
                            <div class="service-links">
                                <a href="http://localhost:8090/api/users" target="_blank">API</a>
                                <a href="http://localhost:8090/actuator/health" target="_blank">ヘルスチェック</a>
                            </div>
                        </div>
                        <div class="service-card">
                            <h3>Application Service</h3>
                            <div class="service-links">
                                <a href="http://localhost:8090/api/applications" target="_blank">API</a>
                                <a href="http://localhost:8090/actuator/health" target="_blank">ヘルスチェック</a>
                            </div>
                        </div>
                        <div class="service-card">
                            <h3>Notification Service</h3>
                            <div class="service-links">
                                <a href="http://localhost:8090/api/notifications" target="_blank">API</a>
                                <a href="http://localhost:8090/actuator/health" target="_blank">ヘルスチェック</a>
                            </div>
                        </div>
                        <div class="service-card">
                            <h3>File Service</h3>
                            <div class="service-links">
                                <a href="http://localhost:8090/api/files" target="_blank">API</a>
                                <a href="http://localhost:8090/actuator/health" target="_blank">ヘルスチェック</a>
                            </div>
                        </div>
                        <div class="service-card">
                            <h3>Service Discovery</h3>
                            <div class="service-links">
                                <a href="http://localhost:8761" target="_blank">Eureka Dashboard</a>
                            </div>
                        </div>
                        <div class="service-card">
                            <h3>API Gateway</h3>
                            <div class="service-links">
                                <a href="/actuator/health" target="_blank">ヘルスチェック</a>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
            </html>
            """;
    }
}

