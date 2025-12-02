@echo off
echo ========================================
echo Vercel Deployment Status Check
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

echo Checking Vercel deployment status...
echo.

REM List all deployments
vercel ls

echo.
echo ========================================
echo Current Project Status
echo ========================================
echo.

REM Show current project info
vercel project ls

echo.
echo ========================================
echo Environment Variables
echo ========================================
echo.

REM Show environment variables
vercel env ls

echo.
echo ========================================
echo Recent Deployments
echo ========================================
echo.

REM Show recent deployments
vercel ls --limit=5

echo.
pause
