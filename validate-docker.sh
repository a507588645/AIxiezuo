#!/bin/bash
# Docker Deployment Validation Script
# This script validates the Docker setup for the AI Novel Generation System
#
# Usage: ./validate-docker.sh
# Note: If you get "Permission denied", run: chmod +x validate-docker.sh

set -e

echo "======================================"
echo "Docker Deployment Validation"
echo "======================================"
echo ""

# Check if Docker is installed
echo "1. Checking Docker installation..."
if command -v docker &> /dev/null; then
    docker --version
    echo "✓ Docker is installed"
else
    echo "✗ Docker is not installed. Please install Docker first."
    exit 1
fi
echo ""

# Check if docker-compose is installed
echo "2. Checking Docker Compose installation..."
if command -v docker-compose &> /dev/null; then
    docker-compose --version
    echo "✓ Docker Compose is installed"
else
    echo "⚠ Docker Compose is not installed (optional for docker compose v2)"
fi
echo ""

# Validate Dockerfile
echo "3. Validating Dockerfile..."
if [ -f "Dockerfile" ]; then
    echo "✓ Dockerfile exists"
    # Check for basic Dockerfile structure
    if grep -q "FROM python" Dockerfile && \
       grep -q "WORKDIR /app" Dockerfile && \
       grep -q "CMD" Dockerfile; then
        echo "✓ Dockerfile has correct structure"
    else
        echo "✗ Dockerfile structure may be incomplete"
        exit 1
    fi
else
    echo "✗ Dockerfile not found"
    exit 1
fi
echo ""

# Validate docker-compose.yml
echo "4. Validating docker-compose.yml..."
if [ -f "docker-compose.yml" ]; then
    echo "✓ docker-compose.yml exists"
    # Validate YAML syntax
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('docker-compose.yml'))" 2>&1; then
            echo "✓ docker-compose.yml syntax is valid"
        else
            echo "✗ docker-compose.yml has syntax errors"
            exit 1
        fi
    fi
else
    echo "✗ docker-compose.yml not found"
    exit 1
fi
echo ""

# Check .dockerignore
echo "5. Checking .dockerignore..."
if [ -f ".dockerignore" ]; then
    echo "✓ .dockerignore exists"
else
    echo "⚠ .dockerignore not found (optional but recommended)"
fi
echo ""

# Check .env.example
echo "6. Checking .env.example..."
if [ -f ".env.example" ]; then
    echo "✓ .env.example exists"
else
    echo "⚠ .env.example not found"
fi
echo ""

# Check GitHub Actions workflow
echo "7. Checking GitHub Actions workflow..."
if [ -f ".github/workflows/docker-publish.yml" ]; then
    echo "✓ GitHub Actions workflow exists"
    # Validate YAML syntax
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/docker-publish.yml'))" 2>&1; then
            echo "✓ Workflow YAML syntax is valid"
        else
            echo "✗ Workflow YAML has syntax errors"
            exit 1
        fi
    fi
else
    echo "✗ GitHub Actions workflow not found"
    exit 1
fi
echo ""

# Check if .env exists
echo "8. Checking environment configuration..."
if [ -f ".env" ]; then
    echo "✓ .env file exists"
    # Check if it has API keys configured
    if grep -q "API_KEY=" .env; then
        echo "✓ .env file contains API key configurations"
    else
        echo "⚠ .env file may not have API keys configured"
    fi
else
    echo "⚠ .env file not found. You'll need to create it from .env.example"
fi
echo ""

# Summary
echo "======================================"
echo "Validation Summary"
echo "======================================"
echo "✓ All required files are present"
echo "✓ Configuration files are valid"
echo ""
echo "Next steps:"
echo "1. Create .env file from .env.example if not exists"
echo "2. Fill in your API keys in .env file"
echo "3. Run 'docker-compose up -d' to start the service"
echo "4. Access the application at http://localhost:5001"
echo ""
echo "For GitHub Actions:"
echo "1. Go to GitHub repository > Actions"
echo "2. Select 'Build and Push Docker Image' workflow"
echo "3. Click 'Run workflow'"
echo "4. Enter version (e.g., 1.0.0) and click 'Run workflow'"
echo ""
