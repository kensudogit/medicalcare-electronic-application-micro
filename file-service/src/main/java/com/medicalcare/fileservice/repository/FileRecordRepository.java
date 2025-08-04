package com.medicalcare.fileservice.repository;

import com.medicalcare.fileservice.domain.FileRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileRecordRepository extends JpaRepository<FileRecord, Long> {
}