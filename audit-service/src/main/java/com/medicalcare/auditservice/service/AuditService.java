package com.medicalcare.auditservice.service;

import com.medicalcare.auditservice.domain.AuditLog;
import com.medicalcare.auditservice.repository.AuditLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AuditService {
    @Autowired
    private AuditLogRepository auditLogRepository;

    public List<AuditLog> findAll() {
        return auditLogRepository.findAll();
    }
    // 他のCRUDメソッド省略
}