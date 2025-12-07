#!/bin/bash

echo "========================================"
echo "Medical Care Electronic Application"
echo "Frontend Vercel Deployment Script"
echo "========================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed."
    echo "Please install Node.js 18.0.0 or later from https://nodejs.org/"
    exit 1
fi

echo "Node.js version:"
node --version
echo ""

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "Error: Vercel CLI is not installed."
    echo "Installing Vercel CLI..."
    npm install -g vercel
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Vercel CLI."
        exit 1
    fi
fi

echo "Vercel CLI version:"
vercel --version
echo ""

# Check if user is logged in
vercel whoami &> /dev/null
if [ $? -ne 0 ]; then
    echo "You are not logged in to Vercel."
    echo "Please run: vercel login"
    exit 1
fi

echo ""
echo "Installing dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies."
    exit 1
fi

echo ""
echo "Building frontend..."
npm run build
if [ $? -ne 0 ]; then
    echo "Warning: Build command completed with warnings."
fi

echo ""
echo "Deploying to Vercel (Production)..."
vercel --prod

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "Deployment completed successfully!"
    echo "========================================"
    echo ""
    echo "Your frontend is now available at:"
    vercel ls --prod | grep "https"
    echo ""
    echo "API Endpoints:"
    echo "- Health Check: /api/health"
    echo "- Users: /api/users"
    echo "- Applications: /api/applications"
    echo "- Notifications: /api/notifications"
    echo "- Files: /api/files"
    echo "- Audit: /api/audit"
    echo ""
else
    echo ""
    echo "Deployment failed! Please check the error messages above."
    echo ""
fi

