package com.medicalcare.applicationservice.controller;

import com.medicalcare.applicationservice.domain.Application;
import com.medicalcare.applicationservice.service.ApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 申請コントローラー
 * 申請関連のREST APIエンドポイントを提供
 */
@RestController
@RequestMapping("/api/applications")
@CrossOrigin(origins = "*")
public class ApplicationController {

    private final ApplicationService applicationService;

    @Autowired
    public ApplicationController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    /**
     * 全申請を取得
     */
    @GetMapping
    public ResponseEntity<List<Application>> getAllApplications() {
        List<Application> applications = applicationService.findAll();
        return ResponseEntity.ok(applications);
    }

    /**
     * IDで申請を取得
     */
    @GetMapping("/{id}")
    public ResponseEntity<Application> getApplicationById(@PathVariable Long id) {
        return applicationService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 申請番号で申請を取得
     */
    @GetMapping("/number/{applicationNumber}")
    public ResponseEntity<Application> getApplicationByNumber(@PathVariable String applicationNumber) {
        return applicationService.findByApplicationNumber(applicationNumber)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * ユーザーIDで申請一覧を取得
     */
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Application>> getApplicationsByUserId(@PathVariable Long userId) {
        List<Application> applications = applicationService.findByUserId(userId);
        return ResponseEntity.ok(applications);
    }

    /**
     * 医療機関IDで申請一覧を取得
     */
    @GetMapping("/institution/{institutionId}")
    public ResponseEntity<List<Application>> getApplicationsByInstitutionId(@PathVariable Long institutionId) {
        List<Application> applications = applicationService.findByInstitutionId(institutionId);
        return ResponseEntity.ok(applications);
    }

    /**
     * ステータスで申請一覧を取得
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Application>> getApplicationsByStatus(@PathVariable String status) {
        try {
            Application.ApplicationStatus applicationStatus = Application.ApplicationStatus
                    .valueOf(status.toUpperCase());
            List<Application> applications = applicationService.findByStatus(applicationStatus);
            return ResponseEntity.ok(applications);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 申請タイプで申請一覧を取得
     */
    @GetMapping("/type/{applicationType}")
    public ResponseEntity<List<Application>> getApplicationsByType(@PathVariable String applicationType) {
        List<Application> applications = applicationService.findByApplicationType(applicationType);
        return ResponseEntity.ok(applications);
    }

    /**
     * 申請を作成
     */
    @PostMapping
    public ResponseEntity<Application> createApplication(@RequestBody Application application) {
        try {
            Application created = applicationService.create(application);
            return ResponseEntity.ok(created);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 申請を更新
     */
    @PutMapping("/{id}")
    public ResponseEntity<Application> updateApplication(@PathVariable Long id, @RequestBody Application application) {
        try {
            Application updated = applicationService.update(id, application);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * 申請を削除
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteApplication(@PathVariable Long id) {
        try {
            applicationService.delete(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * 申請を提出
     */
    @PostMapping("/{id}/submit")
    public ResponseEntity<Application> submitApplication(@PathVariable Long id) {
        try {
            Application submitted = applicationService.submit(id);
            return ResponseEntity.ok(submitted);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 申請を承認
     */
    @PostMapping("/{id}/approve")
    public ResponseEntity<Application> approveApplication(@PathVariable Long id) {
        try {
            Application approved = applicationService.approve(id);
            return ResponseEntity.ok(approved);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 申請を却下
     */
    @PostMapping("/{id}/reject")
    public ResponseEntity<Application> rejectApplication(@PathVariable Long id, @RequestBody RejectionRequest request) {
        try {
            Application rejected = applicationService.reject(id, request.getRejectionReason());
            return ResponseEntity.ok(rejected);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 申請を取り下げ
     */
    @PostMapping("/{id}/withdraw")
    public ResponseEntity<Application> withdrawApplication(@PathVariable Long id) {
        try {
            Application withdrawn = applicationService.withdraw(id);
            return ResponseEntity.ok(withdrawn);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 却下理由リクエストクラス
     */
    public static class RejectionRequest {
        private String rejectionReason;

        public String getRejectionReason() {
            return rejectionReason;
        }

        public void setRejectionReason(String rejectionReason) {
            this.rejectionReason = rejectionReason;
        }
    }
}