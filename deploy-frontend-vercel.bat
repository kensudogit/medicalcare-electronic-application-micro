@echo off
echo ========================================
echo Medical Care Electronic Application
echo Frontend Vercel Deployment Script
echo ========================================
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed.
    echo Please install Node.js 18.0.0 or later from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js version:
node --version
echo.

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Vercel CLI is not installed.
    echo Installing Vercel CLI...
    npm install -g vercel
    if %errorlevel% neq 0 (
        echo Error: Failed to install Vercel CLI.
        pause
        exit /b 1
    )
)

echo Vercel CLI version:
vercel --version
echo.

REM Check if user is logged in
vercel whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo You are not logged in to Vercel.
    echo Please run: vercel login
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
call npm install
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies.
    pause
    exit /b 1
)

echo.
echo Building frontend...
call npm run build
if %errorlevel% neq 0 (
    echo Warning: Build command completed with warnings.
)

echo.
echo Deploying to Vercel (Production)...
vercel --prod

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Deployment completed successfully!
    echo ========================================
    echo.
    echo Your frontend is now available at:
    vercel ls --prod | findstr /C:"https"
    echo.
    echo API Endpoints:
    echo - Health Check: /api/health
    echo - Users: /api/users
    echo - Applications: /api/applications
    echo - Notifications: /api/notifications
    echo - Files: /api/files
    echo - Audit: /api/audit
    echo.
) else (
    echo.
    echo Deployment failed! Please check the error messages above.
    echo.
)

pause

