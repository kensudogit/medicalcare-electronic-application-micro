package com.medicalcare.fileservice.service;

import com.medicalcare.fileservice.domain.FileRecord;
import com.medicalcare.fileservice.repository.FileRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class FileService {
    @Autowired
    private FileRecordRepository fileRecordRepository;

    public List<FileRecord> findAll() {
        return fileRecordRepository.findAll();
    }
    // 他のCRUDメソッド省略
}