#!/bin/bash

echo "========================================"
echo "Medical Care Electronic Application"
echo "Backend Railway Deployment Script"
echo "========================================"
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "Error: Railway CLI is not installed."
    echo "Installing Railway CLI..."
    npm install -g @railway/cli
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Railway CLI."
        exit 1
    fi
fi

echo "Railway CLI version:"
railway --version
echo ""

# Check if user is logged in
railway whoami &> /dev/null
if [ $? -ne 0 ]; then
    echo "You are not logged in to Railway."
    echo "Please run: railway login"
    exit 1
fi

echo ""
echo "Checking Railway project..."
railway status &> /dev/null
if [ $? -ne 0 ]; then
    echo "No Railway project linked. Initializing..."
    railway init
    if [ $? -ne 0 ]; then
        echo "Error: Failed to initialize Railway project."
        exit 1
    fi
fi

echo ""
echo "Current Railway project:"
railway status
echo ""

echo ""
echo "========================================"
echo "Deployment Options:"
echo "========================================"
echo "1. Deploy using Railway Web UI (Recommended)"
echo "2. Deploy using Railway CLI"
echo ""
read -p "Select option (1 or 2): " choice

if [ "$choice" == "1" ]; then
    echo ""
    echo "========================================"
    echo "Railway Web UI Deployment Instructions"
    echo "========================================"
    echo ""
    echo "1. Go to https://railway.app"
    echo "2. Create a new project or select existing project"
    echo "3. Click 'New' and select 'GitHub Repo'"
    echo "4. Connect your repository"
    echo "5. In Settings > Build:"
    echo "   - Build Method: Docker Compose"
    echo "   - Docker Compose File: docker-compose.yml"
    echo "6. Set environment variables in Variables section"
    echo "7. Click 'Deploy'"
    echo ""
    echo "For detailed instructions, see DEPLOYMENT_GUIDE.md"
    echo ""
    exit 0
fi

if [ "$choice" == "2" ]; then
    echo ""
    echo "Deploying to Railway using CLI..."
    echo ""
    echo "Note: Railway CLI deployment with docker-compose"
    echo "requires linking the project first."
    echo ""
    railway up
    if [ $? -eq 0 ]; then
        echo ""
        echo "========================================"
        echo "Deployment completed successfully!"
        echo "========================================"
        echo ""
        echo "Your backend services are now available."
        echo "Check Railway dashboard for service URLs."
        echo ""
    else
        echo ""
        echo "Deployment failed! Please check the error messages above."
        echo ""
        echo "Recommendation: Use Railway Web UI for docker-compose deployments."
        echo ""
    fi
    exit 0
fi

echo "Invalid choice."
exit 1

