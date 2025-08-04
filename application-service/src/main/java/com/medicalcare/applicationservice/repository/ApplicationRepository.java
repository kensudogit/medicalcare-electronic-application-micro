package com.medicalcare.applicationservice.repository;

import com.medicalcare.applicationservice.domain.Application;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 申請リポジトリ
 * 申請データのデータベース操作を提供
 */
@Repository
public interface ApplicationRepository extends JpaRepository<Application, Long> {

    /**
     * 申請番号で申請を検索
     */
    Optional<Application> findByApplicationNumber(String applicationNumber);

    /**
     * ユーザーIDで申請一覧を取得
     */
    List<Application> findByUserId(Long userId);

    /**
     * 医療機関IDで申請一覧を取得
     */
    List<Application> findByInstitutionId(Long institutionId);

    /**
     * ステータスで申請一覧を取得
     */
    List<Application> findByStatus(Application.ApplicationStatus status);

    /**
     * 申請タイプで申請一覧を取得
     */
    List<Application> findByApplicationType(String applicationType);

    /**
     * ユーザーIDとステータスで申請一覧を取得
     */
    List<Application> findByUserIdAndStatus(Long userId, Application.ApplicationStatus status);

    /**
     * 医療機関IDとステータスで申請一覧を取得
     */
    List<Application> findByInstitutionIdAndStatus(Long institutionId, Application.ApplicationStatus status);

    /**
     * 申請番号の存在確認
     */
    boolean existsByApplicationNumber(String applicationNumber);

    /**
     * 複数のステータスで申請一覧を取得
     */
    @Query("SELECT a FROM Application a WHERE a.status IN :statuses")
    List<Application> findByStatusIn(@Param("statuses") List<Application.ApplicationStatus> statuses);

    /**
     * ユーザーIDと複数のステータスで申請一覧を取得
     */
    @Query("SELECT a FROM Application a WHERE a.userId = :userId AND a.status IN :statuses")
    List<Application> findByUserIdAndStatusIn(@Param("userId") Long userId,
            @Param("statuses") List<Application.ApplicationStatus> statuses);

    /**
     * 医療機関IDと複数のステータスで申請一覧を取得
     */
    @Query("SELECT a FROM Application a WHERE a.institutionId = :institutionId AND a.status IN :statuses")
    List<Application> findByInstitutionIdAndStatusIn(@Param("institutionId") Long institutionId,
            @Param("statuses") List<Application.ApplicationStatus> statuses);
}