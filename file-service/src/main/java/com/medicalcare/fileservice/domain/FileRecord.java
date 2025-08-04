package com.medicalcare.fileservice.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "files")
public class FileRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private String filename;
    @Column(nullable = false)
    private String contentType;
    @Column(nullable = false)
    private Long size;
    @Column(nullable = false)
    private String storagePath;
    @Column(nullable = false)
    private LocalDateTime uploadedAt;

    public FileRecord() {
        this.uploadedAt = LocalDateTime.now();
    }
    // getter/setter省略
}