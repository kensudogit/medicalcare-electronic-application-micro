@echo off
setlocal enabledelayedexpansion
echo ========================================
echo Java SE 21 LTS 確認スクリプト
echo ========================================
echo.

echo Java のバージョンを確認中...
java -version 2>&1 | findstr /i "version"
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Java がインストールされていません！
    echo Java SE 21 LTS をインストールしてください。
    echo ダウンロード: https://adoptium.net/temurin/releases/?version=21
    pause
    exit /b 1
)

echo.
echo Java のバージョン詳細:
java -version

echo.
echo JAVA_HOME 環境変数を確認中...
if defined JAVA_HOME (
    echo JAVA_HOME: %JAVA_HOME%
) else (
    echo WARNING: JAVA_HOME 環境変数が設定されていません。
)

echo.
echo ========================================
echo Gradle の Java バージョン設定を確認中...
echo ========================================
echo.

cd api-gateway
if exist build.gradle.kts (
    echo [api-gateway] build.gradle.kts を確認中...
    findstr /i "sourceCompatibility.*21" build.gradle.kts >nul
    if %errorlevel% equ 0 (
        echo   ✓ Java 21 が設定されています
    ) else (
        echo   ✗ Java 21 が設定されていません
    )
)
cd ..

echo.
echo すべてのサービスの Java バージョン設定を確認中...
for /d %%d in (service-discovery user-service application-service notification-service file-service audit-service) do (
    if exist "%%d\build.gradle.kts" (
        echo [%%d] build.gradle.kts を確認中...
        findstr /i "sourceCompatibility.*21" "%%d\build.gradle.kts" >nul
        if !errorlevel! equ 0 (
            echo   ✓ Java 21 が設定されています
        ) else (
            echo   ✗ Java 21 が設定されていません
        )
    )
)

echo.
echo ========================================
echo Dockerfile の Java 21 LTS 設定を確認中...
echo ========================================
echo.

for /d %%d in (api-gateway service-discovery user-service application-service notification-service file-service audit-service) do (
    if exist "%%d\Dockerfile" (
        echo [%%d] Dockerfile を確認中...
        findstr /i "eclipse-temurin:21" "%%d\Dockerfile" >nul
        if !errorlevel! equ 0 (
            echo   ✓ Java 21 LTS (eclipse-temurin:21) が設定されています
        ) else (
            echo   ✗ Java 21 LTS が設定されていません
        )
    )
)

echo.
echo ========================================
echo 確認完了
echo ========================================
echo.
pause

