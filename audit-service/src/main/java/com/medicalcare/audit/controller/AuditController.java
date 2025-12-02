package com.medicalcare.audit.controller;

import com.medicalcare.audit.entity.AuditLog;
import com.medicalcare.audit.service.AuditService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/audit")
@CrossOrigin(origins = "*")
public class AuditController {
    
    @Autowired
    private AuditService auditService;
    
    @PostMapping("/log")
    public ResponseEntity<AuditLog> createAuditLog(
            @RequestParam String userId,
            @RequestParam String action,
            @RequestParam String resource,
            @RequestParam String resourceId,
            @RequestParam(required = false) String details,
            HttpServletRequest request) {
        
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");
        
        AuditLog auditLog = auditService.createAuditLog(userId, action, resource, resourceId, details, ipAddress, userAgent);
        return ResponseEntity.ok(auditLog);
    }
    
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<AuditLog>> getAuditLogsByUserId(@PathVariable String userId) {
        List<AuditLog> logs = auditService.getAuditLogsByUserId(userId);
        return ResponseEntity.ok(logs);
    }
    
    @GetMapping("/resource/{resource}/{resourceId}")
    public ResponseEntity<List<AuditLog>> getAuditLogsByResource(
            @PathVariable String resource,
            @PathVariable String resourceId) {
        List<AuditLog> logs = auditService.getAuditLogsByResource(resource, resourceId);
        return ResponseEntity.ok(logs);
    }
    
    @GetMapping("/action/{action}")
    public ResponseEntity<List<AuditLog>> getAuditLogsByAction(@PathVariable String action) {
        List<AuditLog> logs = auditService.getAuditLogsByAction(action);
        return ResponseEntity.ok(logs);
    }
    
    @GetMapping("/date-range")
    public ResponseEntity<List<AuditLog>> getAuditLogsByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        List<AuditLog> logs = auditService.getAuditLogsByDateRange(start, end);
        return ResponseEntity.ok(logs);
    }
    
    @GetMapping("/user/{userId}/date-range")
    public ResponseEntity<List<AuditLog>> getAuditLogsByUserIdAndDateRange(
            @PathVariable String userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end) {
        List<AuditLog> logs = auditService.getAuditLogsByUserIdAndDateRange(userId, start, end);
        return ResponseEntity.ok(logs);
    }
    
    @GetMapping("/all")
    public ResponseEntity<List<AuditLog>> getAllAuditLogs() {
        List<AuditLog> logs = auditService.getAllAuditLogs();
        return ResponseEntity.ok(logs);
    }
    
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Audit Service is running");
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty() && !"unknown".equalsIgnoreCase(xForwardedFor)) {
            return xForwardedFor.split(",")[0];
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty() && !"unknown".equalsIgnoreCase(xRealIp)) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
}
