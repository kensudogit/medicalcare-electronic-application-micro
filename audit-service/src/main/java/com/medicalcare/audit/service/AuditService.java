package com.medicalcare.audit.service;

import com.medicalcare.audit.entity.AuditLog;
import com.medicalcare.audit.repository.AuditLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AuditService {
    
    @Autowired
    private AuditLogRepository auditLogRepository;
    
    public AuditLog createAuditLog(String userId, String action, String resource, String resourceId, 
                                  String details, String ipAddress, String userAgent) {
        AuditLog auditLog = new AuditLog(userId, action, resource, resourceId, ipAddress, userAgent);
        if (details != null) {
            auditLog.setDetails(details);
        }
        return auditLogRepository.save(auditLog);
    }
    
    public List<AuditLog> getAuditLogsByUserId(String userId) {
        return auditLogRepository.findByUserIdOrderByTimestampDesc(userId);
    }
    
    public List<AuditLog> getAuditLogsByResource(String resource, String resourceId) {
        return auditLogRepository.findByResourceAndResourceIdOrderByTimestampDesc(resource, resourceId);
    }
    
    public List<AuditLog> getAuditLogsByAction(String action) {
        return auditLogRepository.findByActionOrderByTimestampDesc(action);
    }
    
    public List<AuditLog> getAuditLogsByDateRange(LocalDateTime start, LocalDateTime end) {
        return auditLogRepository.findByTimestampBetweenOrderByTimestampDesc(start, end);
    }
    
    public List<AuditLog> getAuditLogsByUserIdAndDateRange(String userId, LocalDateTime start, LocalDateTime end) {
        return auditLogRepository.findByUserIdAndTimestampBetween(userId, start, end);
    }
    
    public List<AuditLog> getAuditLogsByResourceAndDateRange(String resource, String resourceId, 
                                                            LocalDateTime start, LocalDateTime end) {
        return auditLogRepository.findByResourceAndResourceIdAndTimestampBetween(resource, resourceId, start, end);
    }
    
    public List<AuditLog> getAllAuditLogs() {
        return auditLogRepository.findAll();
    }
}
