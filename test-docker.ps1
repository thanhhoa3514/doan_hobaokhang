# Script kiểm tra Docker setup
# Chạy: .\test-docker.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  BookStore Docker Test Script   " -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker installed
Write-Host "[1/6] Checking Docker installation..." -ForegroundColor Yellow
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $dockerVersion = docker --version
    Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Docker not found! Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check Docker Compose
Write-Host "[2/6] Checking Docker Compose..." -ForegroundColor Yellow
if (Get-Command docker-compose -ErrorAction SilentlyContinue) {
    $composeVersion = docker-compose --version
    Write-Host "✓ Docker Compose found: $composeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Docker Compose not found!" -ForegroundColor Red
    exit 1
}

# Check if Docker is running
Write-Host "[3/6] Checking Docker daemon..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker daemon is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker daemon is not running! Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Build and start containers
Write-Host "[4/6] Building and starting containers..." -ForegroundColor Yellow
Write-Host "This may take a few minutes on first run..." -ForegroundColor Gray
docker-compose up -d --build

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Containers started successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to start containers" -ForegroundColor Red
    exit 1
}

# Wait for services to be ready
Write-Host "[5/6] Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check container status
Write-Host "[6/6] Checking container status..." -ForegroundColor Yellow
$containers = docker-compose ps --services
foreach ($container in $containers) {
    $status = docker-compose ps $container | Select-String "Up"
    if ($status) {
        Write-Host "✓ $container is running" -ForegroundColor Green
    } else {
        Write-Host "✗ $container is not running" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!                 " -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access your application at:" -ForegroundColor Yellow
Write-Host "  • Website:     http://localhost:8080/PHP/trangchu.php" -ForegroundColor White
Write-Host "  • phpMyAdmin:  http://localhost:8081" -ForegroundColor White
Write-Host "  • Health Check: http://localhost:8080/PHP/health.php" -ForegroundColor White
Write-Host ""
Write-Host "Database credentials:" -ForegroundColor Yellow
Write-Host "  • Host:     localhost:3306" -ForegroundColor White
Write-Host "  • User:     root" -ForegroundColor White
Write-Host "  • Password: root123" -ForegroundColor White
Write-Host "  • Database: WEB2_BookStore" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  • View logs:        docker-compose logs -f" -ForegroundColor White
Write-Host "  • Stop containers:  docker-compose stop" -ForegroundColor White
Write-Host "  • Remove all:       docker-compose down -v" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to open website in browser..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Open browser
Start-Process "http://localhost:8080/PHP/trangchu.php"
