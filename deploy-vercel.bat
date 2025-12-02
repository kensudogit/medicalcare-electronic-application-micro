@echo off
echo ========================================
echo Medical Care Electronic Application
echo Vercel Deployment Script
echo ========================================
echo.

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Vercel CLI is not installed.
    echo Please install it first: npm install -g vercel
    pause
    exit /b 1
)

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java is not installed or not in PATH.
    echo Please install Java 17 or later.
    pause
    exit /b 1
)

echo Building the project...
cd api-gateway
call gradlew.bat clean build -x test
if %errorlevel% neq 0 (
    echo Error: Build failed!
    pause
    exit /b 1
)
cd ..

echo.
echo Build completed successfully!
echo.

REM Check if JAR file exists
if not exist "api-gateway\build\libs\*.jar" (
    echo Error: JAR file not found after build!
    pause
    exit /b 1
)

echo JAR file found. Proceeding with deployment...
echo.

echo Deploying to Vercel...
vercel --prod

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Deployment completed successfully!
    echo ========================================
    echo.
    echo Your application is now available at:
    echo https://your-project-name.vercel.app
    echo.
    echo API Endpoints:
    echo - Health Check: /health
    echo - Users: /api/users
    echo - Applications: /api/applications
    echo - Notifications: /api/notifications
    echo - Files: /api/files
    echo.
) else (
    echo.
    echo Deployment failed! Please check the error messages above.
    echo.
)

pause
