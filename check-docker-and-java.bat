@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Docker と Java SE 21 LTS 環境チェック
echo ========================================
echo.

REM Java 21 の確認
echo [1/3] Java SE 21 LTS の確認中...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo   ✗ ERROR: Java がインストールされていません！
    echo    Java SE 21 LTS をインストールしてください。
    echo    ダウンロード: https://adoptium.net/temurin/releases/?version=21
    echo.
    pause
    exit /b 1
)

echo   ✓ Java がインストールされています
java -version 2>&1 | findstr /i "version"

REM Docker の確認
echo.
echo [2/3] Docker の確認中...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo   ✗ ERROR: Docker がインストールされていません！
    echo    Docker Desktop をインストールしてください。
    echo    ダウンロード: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

echo   ✓ Docker がインストールされています
docker --version

REM Docker Desktop の起動確認
echo.
echo [3/3] Docker Desktop の起動確認中...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo   ✗ ERROR: Docker Desktop が起動していません！
    echo.
    echo   解決方法:
    echo   1. Docker Desktop を起動してください
    echo   2. Docker Desktop が完全に起動するまで待ってください
    echo   3. 再度このスクリプトを実行してください
    echo.
    echo   Docker Desktop を起動しますか？ (Y/N)
    set /p start_docker=
    if /i "!start_docker!"=="Y" (
        start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
        echo.
        echo Docker Desktop を起動しました。完全に起動するまで待ってから再度実行してください。
    )
    echo.
    pause
    exit /b 1
)

echo   ✓ Docker Desktop が起動しています
docker info | findstr /i "Server Version"

echo.
echo ========================================
echo 環境チェック完了 - すべて正常です！
echo ========================================
echo.
echo 次のコマンドでサービスを起動できます:
echo   docker-compose up -d --build
echo.
pause

