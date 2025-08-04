package com.medicalcare.fileservice.controller;

import com.medicalcare.fileservice.domain.FileRecord;
import com.medicalcare.fileservice.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/files")
public class FileController {
    @Autowired
    private FileService fileService;

    @GetMapping
    public ResponseEntity<List<FileRecord>> getAllFiles() {
        return ResponseEntity.ok(fileService.findAll());
    }
    // 他のエンドポイント省略
}