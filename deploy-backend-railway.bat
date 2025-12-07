@echo off
echo ========================================
echo Medical Care Electronic Application
echo Backend Railway Deployment Script
echo ========================================
echo.

REM Check if Railway CLI is installed
railway --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Railway CLI is not installed.
    echo Installing Railway CLI...
    npm install -g @railway/cli
    if %errorlevel% neq 0 (
        echo Error: Failed to install Railway CLI.
        pause
        exit /b 1
    )
)

echo Railway CLI version:
railway --version
echo.

REM Check if user is logged in
railway whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo You are not logged in to Railway.
    echo Please run: railway login
    pause
    exit /b 1
)

echo.
echo Checking Railway project...
railway status >nul 2>&1
if %errorlevel% neq 0 (
    echo No Railway project linked. Initializing...
    railway init
    if %errorlevel% neq 0 (
        echo Error: Failed to initialize Railway project.
        pause
        exit /b 1
    )
)

echo.
echo Current Railway project:
railway status
echo.

echo.
echo ========================================
echo Deployment Options:
echo ========================================
echo 1. Deploy using Railway Web UI (Recommended)
echo 2. Deploy using Railway CLI
echo.
set /p choice="Select option (1 or 2): "

if "%choice%"=="1" (
    echo.
    echo ========================================
    echo Railway Web UI Deployment Instructions
    echo ========================================
    echo.
    echo 1. Go to https://railway.app
    echo 2. Create a new project or select existing project
    echo 3. Click "New" and select "GitHub Repo"
    echo 4. Connect your repository
    echo 5. In Settings ^> Build:
    echo    - Build Method: Docker Compose
    echo    - Docker Compose File: docker-compose.yml
    echo 6. Set environment variables in Variables section
    echo 7. Click "Deploy"
    echo.
    echo For detailed instructions, see DEPLOYMENT_GUIDE.md
    echo.
    pause
    exit /b 0
)

if "%choice%"=="2" (
    echo.
    echo Deploying to Railway using CLI...
    echo.
    echo Note: Railway CLI deployment with docker-compose
    echo requires linking the project first.
    echo.
    railway up
    if %errorlevel% equ 0 (
        echo.
        echo ========================================
        echo Deployment completed successfully!
        echo ========================================
        echo.
        echo Your backend services are now available.
        echo Check Railway dashboard for service URLs.
        echo.
    ) else (
        echo.
        echo Deployment failed! Please check the error messages above.
        echo.
        echo Recommendation: Use Railway Web UI for docker-compose deployments.
        echo.
    )
    pause
    exit /b 0
)

echo Invalid choice.
pause
exit /b 1

