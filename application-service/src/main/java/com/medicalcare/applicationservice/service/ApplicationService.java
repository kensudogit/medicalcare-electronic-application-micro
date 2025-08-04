package com.medicalcare.applicationservice.service;

import com.medicalcare.applicationservice.domain.Application;
import com.medicalcare.applicationservice.repository.ApplicationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * 申請サービス
 * 申請のビジネスロジックを提供
 */
@Service
@Transactional
public class ApplicationService {

    private final ApplicationRepository applicationRepository;

    @Autowired
    public ApplicationService(ApplicationRepository applicationRepository) {
        this.applicationRepository = applicationRepository;
    }

    /**
     * 全申請を取得
     */
    @Transactional(readOnly = true)
    public List<Application> findAll() {
        return applicationRepository.findAll();
    }

    /**
     * IDで申請を取得
     */
    @Transactional(readOnly = true)
    public Optional<Application> findById(Long id) {
        return applicationRepository.findById(id);
    }

    /**
     * 申請番号で申請を取得
     */
    @Transactional(readOnly = true)
    public Optional<Application> findByApplicationNumber(String applicationNumber) {
        return applicationRepository.findByApplicationNumber(applicationNumber);
    }

    /**
     * ユーザーIDで申請一覧を取得
     */
    @Transactional(readOnly = true)
    public List<Application> findByUserId(Long userId) {
        return applicationRepository.findByUserId(userId);
    }

    /**
     * 医療機関IDで申請一覧を取得
     */
    @Transactional(readOnly = true)
    public List<Application> findByInstitutionId(Long institutionId) {
        return applicationRepository.findByInstitutionId(institutionId);
    }

    /**
     * ステータスで申請一覧を取得
     */
    @Transactional(readOnly = true)
    public List<Application> findByStatus(Application.ApplicationStatus status) {
        return applicationRepository.findByStatus(status);
    }

    /**
     * 申請タイプで申請一覧を取得
     */
    @Transactional(readOnly = true)
    public List<Application> findByApplicationType(String applicationType) {
        return applicationRepository.findByApplicationType(applicationType);
    }

    /**
     * 申請を作成
     */
    public Application create(Application application) {
        // 申請番号を生成
        String applicationNumber = generateApplicationNumber();
        application.setApplicationNumber(applicationNumber);

        // 初期ステータスを設定
        application.setStatus(Application.ApplicationStatus.DRAFT);

        // 作成日時を設定
        LocalDateTime now = LocalDateTime.now();
        application.setCreatedAt(now);
        application.setUpdatedAt(now);

        return applicationRepository.save(application);
    }

    /**
     * 申請を更新
     */
    public Application update(Long id, Application applicationDetails) {
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found with id: " + id));

        // 更新可能なフィールドのみ更新
        application.setTitle(applicationDetails.getTitle());
        application.setDescription(applicationDetails.getDescription());
        application.setApplicationType(applicationDetails.getApplicationType());
        application.setUpdatedAt(LocalDateTime.now());

        return applicationRepository.save(application);
    }

    /**
     * 申請を削除
     */
    public void delete(Long id) {
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found with id: " + id));
        applicationRepository.delete(application);
    }

    /**
     * 申請を提出
     */
    public Application submit(Long id) {
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found with id: " + id));

        if (application.getStatus() != Application.ApplicationStatus.DRAFT) {
            throw new RuntimeException("Application must be in DRAFT status to submit");
        }

        application.setStatus(Application.ApplicationStatus.SUBMITTED);
        application.setSubmittedAt(LocalDateTime.now());
        application.setUpdatedAt(LocalDateTime.now());

        return applicationRepository.save(application);
    }

    /**
     * 申請を承認
     */
    public Application approve(Long id) {
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found with id: " + id));

        if (application.getStatus() != Application.ApplicationStatus.SUBMITTED &&
                application.getStatus() != Application.ApplicationStatus.REVIEWING) {
            throw new RuntimeException("Application must be in SUBMITTED or REVIEWING status to approve");
        }

        application.setStatus(Application.ApplicationStatus.APPROVED);
        application.setApprovedAt(LocalDateTime.now());
        application.setUpdatedAt(LocalDateTime.now());

        return applicationRepository.save(application);
    }

    /**
     * 申請を却下
     */
    public Application reject(Long id, String rejectionReason) {
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found with id: " + id));

        if (application.getStatus() != Application.ApplicationStatus.SUBMITTED &&
                application.getStatus() != Application.ApplicationStatus.REVIEWING) {
            throw new RuntimeException("Application must be in SUBMITTED or REVIEWING status to reject");
        }

        application.setStatus(Application.ApplicationStatus.REJECTED);
        application.setRejectedAt(LocalDateTime.now());
        application.setRejectionReason(rejectionReason);
        application.setUpdatedAt(LocalDateTime.now());

        return applicationRepository.save(application);
    }

    /**
     * 申請を取り下げ
     */
    public Application withdraw(Long id) {
        Application application = applicationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Application not found with id: " + id));

        if (application.getStatus() != Application.ApplicationStatus.DRAFT &&
                application.getStatus() != Application.ApplicationStatus.SUBMITTED) {
            throw new RuntimeException("Application must be in DRAFT or SUBMITTED status to withdraw");
        }

        application.setStatus(Application.ApplicationStatus.WITHDRAWN);
        application.setUpdatedAt(LocalDateTime.now());

        return applicationRepository.save(application);
    }

    /**
     * 申請番号を生成
     */
    private String generateApplicationNumber() {
        return "APP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}