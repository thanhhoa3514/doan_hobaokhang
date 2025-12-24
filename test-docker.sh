#!/bin/bash

# Script kiểm tra Docker setup cho Linux/Mac
# Chạy: chmod +x test-docker.sh && ./test-docker.sh

echo "=================================="
echo "  BookStore Docker Test Script   "
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check Docker installed
echo -e "${YELLOW}[1/6] Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓ Docker found: $DOCKER_VERSION${NC}"
else
    echo -e "${RED}✗ Docker not found! Please install Docker Desktop.${NC}"
    exit 1
fi

# Check Docker Compose
echo -e "${YELLOW}[2/6] Checking Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✓ Docker Compose found: $COMPOSE_VERSION${NC}"
else
    echo -e "${RED}✗ Docker Compose not found!${NC}"
    exit 1
fi

# Check if Docker is running
echo -e "${YELLOW}[3/6] Checking Docker daemon...${NC}"
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓ Docker daemon is running${NC}"
else
    echo -e "${RED}✗ Docker daemon is not running! Please start Docker Desktop.${NC}"
    exit 1
fi

# Build and start containers
echo -e "${YELLOW}[4/6] Building and starting containers...${NC}"
echo -e "${CYAN}This may take a few minutes on first run...${NC}"
docker-compose up -d --build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Containers started successfully${NC}"
else
    echo -e "${RED}✗ Failed to start containers${NC}"
    exit 1
fi

# Wait for services to be ready
echo -e "${YELLOW}[5/6] Waiting for services to be ready...${NC}"
sleep 10

# Check container status
echo -e "${YELLOW}[6/6] Checking container status...${NC}"
CONTAINERS=$(docker-compose ps --services)
for container in $CONTAINERS; do
    if docker-compose ps $container | grep -q "Up"; then
        echo -e "${GREEN}✓ $container is running${NC}"
    else
        echo -e "${RED}✗ $container is not running${NC}"
    fi
done

echo ""
echo -e "${CYAN}==================================${NC}"
echo -e "${CYAN}  Setup Complete!                 ${NC}"
echo -e "${CYAN}==================================${NC}"
echo ""
echo -e "${YELLOW}Access your application at:${NC}"
echo -e "  • Website:      http://localhost:8080/PHP/trangchu.php"
echo -e "  • phpMyAdmin:   http://localhost:8081"
echo -e "  • Health Check: http://localhost:8080/PHP/health.php"
echo ""
echo -e "${YELLOW}Database credentials:${NC}"
echo -e "  • Host:     localhost:3306"
echo -e "  • User:     root"
echo -e "  • Password: root123"
echo -e "  • Database: WEB2_BookStore"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  • View logs:        docker-compose logs -f"
echo -e "  • Stop containers:  docker-compose stop"
echo -e "  • Remove all:       docker-compose down -v"
echo ""

# Open browser (Mac/Linux)
if [[ "$OSTYPE" == "darwin"* ]]; then
    open "http://localhost:8080/PHP/trangchu.php"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "http://localhost:8080/PHP/trangchu.php" 2>/dev/null || echo "Please open http://localhost:8080/PHP/trangchu.php in your browser"
fi
