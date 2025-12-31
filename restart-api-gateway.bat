@echo off
echo ========================================
echo API Gateway 再起動スクリプト
echo ========================================
echo.

echo API Gateway を停止中...
docker-compose stop api-gateway

echo.
echo API Gateway を再ビルド中...
docker-compose build api-gateway

echo.
echo API Gateway を起動中...
docker-compose up -d api-gateway

echo.
echo ログを確認中（10秒間）...
timeout /t 10 /nobreak >nul
docker-compose logs --tail=30 api-gateway

echo.
echo ========================================
echo 再起動完了
echo ========================================
echo.
echo ダッシュボードにアクセス: http://localhost:8080/dashboard
echo.
pause

