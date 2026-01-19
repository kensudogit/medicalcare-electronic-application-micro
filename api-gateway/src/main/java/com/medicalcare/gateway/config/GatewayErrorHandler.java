package com.medicalcare.gateway.config;

import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.cloud.gateway.support.NotFoundException;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * API Gatewayのエラーハンドラー
 * タイムアウトやその他のエラーを適切に処理する
 */
@Component
@Order(-2)
public class GatewayErrorHandler implements ErrorWebExceptionHandler {

    @Override
    public Mono<Void> handle(ServerWebExchange exchange, Throwable ex) {
        ServerHttpResponse response = exchange.getResponse();
        
        HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;
        String message = "Internal Server Error";
        
        if (ex instanceof NotFoundException) {
            status = HttpStatus.NOT_FOUND;
            message = "Service not found. The requested service may not be available or not registered with Eureka.";
        } else if (ex instanceof java.util.concurrent.TimeoutException || 
                   ex.getMessage() != null && ex.getMessage().contains("timeout")) {
            status = HttpStatus.GATEWAY_TIMEOUT;
            message = "Gateway Timeout. The service did not respond within the expected time.";
        } else if (ex instanceof org.springframework.cloud.gateway.support.NotFoundException) {
            status = HttpStatus.NOT_FOUND;
            message = "Service not found. Please check if the service is registered with Eureka.";
        } else if (ex instanceof java.net.ConnectException || 
                   ex.getMessage() != null && ex.getMessage().contains("Connection refused")) {
            status = HttpStatus.SERVICE_UNAVAILABLE;
            message = "Service Unavailable. Unable to connect to the service.";
        } else if (ex instanceof ResponseStatusException) {
            ResponseStatusException responseStatusException = (ResponseStatusException) ex;
            status = responseStatusException.getStatusCode();
            message = responseStatusException.getReason() != null ? 
                     responseStatusException.getReason() : status.getReasonPhrase();
        }
        
        response.setStatusCode(status);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("timestamp", LocalDateTime.now().toString());
        errorResponse.put("status", status.value());
        errorResponse.put("error", status.getReasonPhrase());
        errorResponse.put("message", message);
        errorResponse.put("path", exchange.getRequest().getPath().value());
        
        // デバッグ情報（開発環境のみ）
        if (ex.getMessage() != null) {
            errorResponse.put("details", ex.getMessage());
        }
        
        String jsonResponse = "{\n" +
                "  \"timestamp\": \"" + errorResponse.get("timestamp") + "\",\n" +
                "  \"status\": " + errorResponse.get("status") + ",\n" +
                "  \"error\": \"" + errorResponse.get("error") + "\",\n" +
                "  \"message\": \"" + errorResponse.get("message") + "\",\n" +
                "  \"path\": \"" + errorResponse.get("path") + "\"" +
                (errorResponse.containsKey("details") ? 
                 ",\n  \"details\": \"" + errorResponse.get("details") + "\"" : "") +
                "\n}";
        
        DataBuffer buffer = response.bufferFactory().wrap(jsonResponse.getBytes(StandardCharsets.UTF_8));
        return response.writeWith(Mono.just(buffer));
    }
}
