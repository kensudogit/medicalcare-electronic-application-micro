@echo off
echo ========================================
echo Vercel Setup Script
echo Medical Care Electronic Application
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

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: npm is not installed.
    pause
    exit /b 1
)

echo npm version:
npm --version
echo.

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Vercel CLI...
    npm install -g vercel
    if %errorlevel% neq 0 (
        echo Error: Failed to install Vercel CLI.
        pause
        exit /b 1
    )
    echo Vercel CLI installed successfully!
) else (
    echo Vercel CLI is already installed.
    vercel --version
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Run: vercel login
echo 2. Run: deploy-vercel.bat
echo.
echo For more information, see README-VERCEL.md
echo.
pause
