@echo off
echo ========================================
echo サービス状態確認スクリプト
echo ========================================
echo.

echo Dockerコンテナの状態を確認中...
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | findstr "medicalcare"

echo.
echo ========================================
echo API Gateway のログを確認中...
echo ========================================
echo.
docker-compose logs --tail=50 api-gateway

echo.
echo ========================================
echo Service Discovery のログを確認中...
echo ========================================
echo.
docker-compose logs --tail=30 service-discovery

echo.
echo ========================================
echo ポート8080の使用状況を確認中...
echo ========================================
echo.
netstat -an | findstr ":8080"

echo.
pause

