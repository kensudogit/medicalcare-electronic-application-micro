package com.medicalcare.audit.repository;

import com.medicalcare.audit.entity.AuditLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {
    
    List<AuditLog> findByUserIdOrderByTimestampDesc(String userId);
    
    List<AuditLog> findByResourceAndResourceIdOrderByTimestampDesc(String resource, String resourceId);
    
    List<AuditLog> findByActionOrderByTimestampDesc(String action);
    
    List<AuditLog> findByTimestampBetweenOrderByTimestampDesc(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT a FROM AuditLog a WHERE a.userId = :userId AND a.timestamp BETWEEN :start AND :end ORDER BY a.timestamp DESC")
    List<AuditLog> findByUserIdAndTimestampBetween(@Param("userId") String userId, 
                                                   @Param("start") LocalDateTime start, 
                                                   @Param("end") LocalDateTime end);
    
    @Query("SELECT a FROM AuditLog a WHERE a.resource = :resource AND a.resourceId = :resourceId AND a.timestamp BETWEEN :start AND :end ORDER BY a.timestamp DESC")
    List<AuditLog> findByResourceAndResourceIdAndTimestampBetween(@Param("resource") String resource,
                                                                 @Param("resourceId") String resourceId,
                                                                 @Param("start") LocalDateTime start,
                                                                 @Param("end") LocalDateTime end);
}
